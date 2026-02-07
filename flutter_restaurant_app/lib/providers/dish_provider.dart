import 'package:flutter/foundation.dart';
import '../models/dish_model.dart';
import '../services/dish_service.dart';

/// Provider para gestionar el estado de los platos
/// Utiliza el patrón ChangeNotifier para notificar a los widgets
class DishProvider extends ChangeNotifier {
  final DishService _dishService = DishService();

  // Estado
  List<DishModel> _dishes = [];
  List<DishModel> _searchResults = [];
  List<DishModel> _favorites = [];
  List<String> _categories = [];

  bool _isLoading = false;
  bool _isSearching = false;
  String _error = '';
  String _searchQuery = '';
  String _selectedCategory = 'Todos';

  // Filtros
  RangeValues _priceRange = const RangeValues(0, 100);
  double _minRating = 0;

  // Getters
  List<DishModel> get dishes => _dishes;
  List<DishModel> get searchResults => _searchResults;
  List<DishModel> get favorites => _favorites;
  List<String> get categories => _categories;

  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  RangeValues get priceRange => _priceRange;
  double get minRating => _minRating;

  /// Platos a mostrar (filtrados o búsqueda)
  List<DishModel> get displayedDishes {
    if (_searchQuery.isNotEmpty || _isSearching) {
      return _searchResults;
    }
    return _applyFilters(_dishes);
  }

  /// Inicializa los datos
  Future<void> initialize() async {
    _setLoading(true);
    try {
      _dishes = await _dishService.getAllDishes();
      _categories = _dishService.getCategories();
      _favorites = await _dishService.getFavorites();

      final stats = _dishService.getStatistics();
      _priceRange = RangeValues(
        stats['minPrice'].toDouble(),
        stats['maxPrice'].toDouble(),
      );

      _error = '';
    } catch (e) {
      _error = 'Error al cargar los platos: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Busca platos por texto
  Future<void> searchDishes(String query) async {
    _searchQuery = query;
    _isSearching = query.isNotEmpty;

    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      _searchResults = await _dishService.searchDishes(query);
      _searchResults = _applyFilters(_searchResults);
      _error = '';
    } catch (e) {
      _error = 'Error en la búsqueda: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Filtra por categoría
  Future<void> filterByCategory(String category) async {
    _selectedCategory = category;
    _setLoading(true);

    try {
      if (_searchQuery.isNotEmpty) {
        _searchResults = await _dishService.searchDishes(_searchQuery);
        if (category != 'Todos') {
          _searchResults = _searchResults
              .where((dish) => dish.category == category)
              .toList();
        }
      } else {
        _dishes = await _dishService.getDishesByCategory(category);
      }
      _error = '';
    } catch (e) {
      _error = 'Error al filtrar: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Aplica filtros avanzados
  void applyFilters({
    RangeValues? priceRange,
    double? minRating,
    String? category,
  }) {
    if (priceRange != null) _priceRange = priceRange;
    if (minRating != null) _minRating = minRating;
    if (category != null) _selectedCategory = category;
    notifyListeners();
  }

  /// Resetea todos los filtros
  Future<void> resetFilters() async {
    final stats = _dishService.getStatistics();
    _priceRange = RangeValues(
      stats['minPrice'].toDouble(),
      stats['maxPrice'].toDouble(),
    );
    _minRating = 0;
    _selectedCategory = 'Todos';
    _searchQuery = '';
    _isSearching = false;
    _searchResults = [];

    await initialize();
  }

  /// Alterna favorito de un plato
  Future<void> toggleFavorite(String dishId) async {
    try {
      final isFavorite = await _dishService.toggleFavorite(dishId);

      // Actualizar en la lista principal
      _updateDishFavorite(dishId, isFavorite, _dishes);
      _updateDishFavorite(dishId, isFavorite, _searchResults);

      // Actualizar lista de favoritos
      _favorites = await _dishService.getFavorites();

      notifyListeners();
    } catch (e) {
      _error = 'Error al actualizar favorito: $e';
      notifyListeners();
    }
  }

  /// Obtiene platos populares
  Future<List<DishModel>> getPopularDishes({int limit = 5}) async {
    return await _dishService.getPopularDishes(limit: limit);
  }

  /// Obtiene platos mejor calificados
  Future<List<DishModel>> getTopRatedDishes({int limit = 5}) async {
    return await _dishService.getTopRatedDishes(limit: limit);
  }

  /// Obtiene un plato por ID
  Future<DishModel?> getDishById(String id) async {
    return await _dishService.getDishById(id);
  }

  /// Limpia la búsqueda
  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    _searchResults = [];
    notifyListeners();
  }

  // Métodos privados

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<DishModel> _applyFilters(List<DishModel> dishes) {
    return dishes.where((dish) {
      // Filtro de categoría
      if (_selectedCategory != 'Todos' && dish.category != _selectedCategory) {
        return false;
      }

      // Filtro de precio
      if (dish.price < _priceRange.start || dish.price > _priceRange.end) {
        return false;
      }

      // Filtro de calificación
      if (dish.rating < _minRating) {
        return false;
      }

      return true;
    }).toList();
  }

  void _updateDishFavorite(String dishId, bool isFavorite, List<DishModel> list) {
    final index = list.indexWhere((d) => d.id == dishId);
    if (index != -1) {
      list[index].isFavorite = isFavorite;
      if (isFavorite) {
        list[index].likesCount++;
      } else {
        list[index].likesCount--;
      }
    }
  }
}
