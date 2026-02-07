import '../models/dish_model.dart';

/// Servicio para gestionar los datos de platos
/// En producción, esto se conectaría a una API real
class DishService {
  // Singleton pattern
  static final DishService _instance = DishService._internal();
  factory DishService() => _instance;
  DishService._internal();

  /// Lista de platos de ejemplo (simulando una base de datos)
  final List<DishModel> _dishes = [
    DishModel(
      id: '1',
      name: 'Strawberry Cake',
      description: 'Delicioso pastel de fresa con crema batida y fresas frescas',
      imageUrl: 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400',
      price: 25.99,
      preparationTimeMin: 25,
      preparationTimeMax: 30,
      rating: 5.0,
      reviewsCount: 256,
      category: 'Postres',
      ingredients: ['Fresas', 'Harina', 'Crema', 'Azúcar', 'Huevos'],
      isPopular: true,
      likesCount: 342,
    ),
    DishModel(
      id: '2',
      name: 'French Fries',
      description: 'Papas fritas crujientes con especias y salsas artesanales',
      imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400',
      price: 8.99,
      preparationTimeMin: 15,
      preparationTimeMax: 20,
      rating: 5.0,
      reviewsCount: 120,
      category: 'Entradas',
      ingredients: ['Papas', 'Aceite', 'Sal', 'Especias'],
      likesCount: 189,
    ),
    DishModel(
      id: '3',
      name: 'Maxican Fried Rice',
      description: 'Arroz frito estilo mexicano con vegetales, frijoles y especias',
      imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
      price: 15.99,
      preparationTimeMin: 25,
      preparationTimeMax: 30,
      rating: 5.0,
      reviewsCount: 120,
      category: 'Platos Fuertes',
      ingredients: ['Arroz', 'Frijoles', 'Vegetales', 'Especias mexicanas'],
      isNew: true,
      likesCount: 156,
    ),
    DishModel(
      id: '4',
      name: 'Manchau Soup',
      description: 'Sopa tradicional asiática con verduras y fideos',
      imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400',
      price: 12.99,
      preparationTimeMin: 25,
      preparationTimeMax: 30,
      rating: 5.0,
      reviewsCount: 120,
      category: 'Sopas',
      ingredients: ['Fideos', 'Vegetales', 'Caldo', 'Especias asiáticas'],
      likesCount: 98,
    ),
    DishModel(
      id: '5',
      name: 'Golden Shots',
      description: 'Bebida refrescante con frutas tropicales',
      imageUrl: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400',
      price: 9.99,
      preparationTimeMin: 25,
      preparationTimeMax: 30,
      rating: 5.0,
      reviewsCount: 98,
      category: 'Bebidas',
      ingredients: ['Frutas tropicales', 'Hielo', 'Azúcar'],
      likesCount: 134,
    ),
    DishModel(
      id: '6',
      name: 'Pasta Carbonara',
      description: 'Pasta italiana con salsa cremosa, tocino y queso parmesano',
      imageUrl: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400',
      price: 18.99,
      preparationTimeMin: 20,
      preparationTimeMax: 25,
      rating: 4.8,
      reviewsCount: 89,
      category: 'Platos Fuertes',
      ingredients: ['Pasta', 'Tocino', 'Huevos', 'Queso Parmesano', 'Pimienta'],
      isPopular: true,
      likesCount: 267,
    ),
    DishModel(
      id: '7',
      name: 'Caesar Salad',
      description: 'Ensalada fresca con pollo a la parrilla, crutones y aderezo César',
      imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
      price: 14.99,
      preparationTimeMin: 10,
      preparationTimeMax: 15,
      rating: 4.6,
      reviewsCount: 156,
      category: 'Ensaladas',
      ingredients: ['Lechuga romana', 'Pollo', 'Crutones', 'Queso parmesano', 'Aderezo César'],
      likesCount: 198,
    ),
    DishModel(
      id: '8',
      name: 'Chocolate Brownie',
      description: 'Brownie de chocolate caliente con helado de vainilla',
      imageUrl: 'https://images.unsplash.com/photo-1564355808539-22fda35bed7e?w=400',
      price: 11.99,
      preparationTimeMin: 15,
      preparationTimeMax: 20,
      rating: 4.9,
      reviewsCount: 203,
      category: 'Postres',
      ingredients: ['Chocolate', 'Harina', 'Mantequilla', 'Huevos', 'Azúcar'],
      isPopular: true,
      isNew: true,
      likesCount: 445,
    ),
    DishModel(
      id: '9',
      name: 'Grilled Salmon',
      description: 'Salmón a la parrilla con vegetales de temporada y salsa de limón',
      imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400',
      price: 28.99,
      preparationTimeMin: 30,
      preparationTimeMax: 40,
      rating: 4.7,
      reviewsCount: 178,
      category: 'Platos Fuertes',
      ingredients: ['Salmón', 'Limón', 'Hierbas', 'Vegetales', 'Aceite de oliva'],
      likesCount: 312,
    ),
    DishModel(
      id: '10',
      name: 'Mojito Clásico',
      description: 'Cóctel refrescante de ron, menta, lima y soda',
      imageUrl: 'https://images.unsplash.com/photo-1551538827-9c037cb4f32a?w=400',
      price: 10.99,
      preparationTimeMin: 5,
      preparationTimeMax: 10,
      rating: 4.8,
      reviewsCount: 234,
      category: 'Bebidas',
      ingredients: ['Ron', 'Menta', 'Lima', 'Azúcar', 'Soda'],
      isPopular: true,
      likesCount: 389,
    ),
    DishModel(
      id: '11',
      name: 'Tacos al Pastor',
      description: 'Tacos mexicanos de cerdo marinado con piña y cilantro',
      imageUrl: 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400',
      price: 13.99,
      preparationTimeMin: 20,
      preparationTimeMax: 25,
      rating: 4.9,
      reviewsCount: 312,
      category: 'Platos Fuertes',
      ingredients: ['Cerdo', 'Piña', 'Cilantro', 'Cebolla', 'Tortillas'],
      isPopular: true,
      likesCount: 567,
    ),
    DishModel(
      id: '12',
      name: 'Sopa de Tortilla',
      description: 'Sopa mexicana tradicional con tiras de tortilla crujiente y aguacate',
      imageUrl: 'https://images.unsplash.com/photo-1578020190125-f4f7c18bc9cb?w=400',
      price: 11.99,
      preparationTimeMin: 20,
      preparationTimeMax: 30,
      rating: 4.5,
      reviewsCount: 89,
      category: 'Sopas',
      ingredients: ['Tortillas', 'Tomate', 'Chile', 'Aguacate', 'Queso'],
      likesCount: 123,
    ),
  ];

  /// Obtiene todos los platos
  Future<List<DishModel>> getAllDishes() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_dishes);
  }

  /// Busca platos por texto (nombre, descripción, ingredientes)
  Future<List<DishModel>> searchDishes(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (query.isEmpty) {
      return List.from(_dishes);
    }

    final lowercaseQuery = query.toLowerCase();
    return _dishes.where((dish) {
      return dish.name.toLowerCase().contains(lowercaseQuery) ||
          dish.description.toLowerCase().contains(lowercaseQuery) ||
          dish.ingredients.any((i) => i.toLowerCase().contains(lowercaseQuery)) ||
          dish.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Filtra platos por criterios
  Future<List<DishModel>> filterDishes({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? onlyAvailable,
    bool? onlyPopular,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return _dishes.where((dish) {
      if (category != null && category != 'Todos' && dish.category != category) {
        return false;
      }
      if (minPrice != null && dish.price < minPrice) {
        return false;
      }
      if (maxPrice != null && dish.price > maxPrice) {
        return false;
      }
      if (minRating != null && dish.rating < minRating) {
        return false;
      }
      if (onlyAvailable == true && !dish.isAvailable) {
        return false;
      }
      if (onlyPopular == true && !dish.isPopular) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Obtiene platos por categoría
  Future<List<DishModel>> getDishesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (category == 'Todos') {
      return List.from(_dishes);
    }

    return _dishes.where((dish) => dish.category == category).toList();
  }

  /// Obtiene un plato por ID
  Future<DishModel?> getDishById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _dishes.firstWhere((dish) => dish.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene los platos más populares
  Future<List<DishModel>> getPopularDishes({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final sorted = List<DishModel>.from(_dishes)
      ..sort((a, b) => b.likesCount.compareTo(a.likesCount));

    return sorted.take(limit).toList();
  }

  /// Obtiene los platos mejor calificados
  Future<List<DishModel>> getTopRatedDishes({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final sorted = List<DishModel>.from(_dishes)
      ..sort((a, b) {
        final ratingCompare = b.rating.compareTo(a.rating);
        if (ratingCompare != 0) return ratingCompare;
        return b.reviewsCount.compareTo(a.reviewsCount);
      });

    return sorted.take(limit).toList();
  }

  /// Obtiene los platos nuevos
  Future<List<DishModel>> getNewDishes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _dishes.where((dish) => dish.isNew).toList();
  }

  /// Obtiene las categorías disponibles
  List<String> getCategories() {
    final categories = <String>{'Todos'};
    for (final dish in _dishes) {
      categories.add(dish.category);
    }
    return categories.toList();
  }

  /// Alterna el estado de favorito de un plato
  Future<bool> toggleFavorite(String dishId) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final index = _dishes.indexWhere((dish) => dish.id == dishId);
    if (index != -1) {
      _dishes[index].isFavorite = !_dishes[index].isFavorite;
      if (_dishes[index].isFavorite) {
        _dishes[index].likesCount++;
      } else {
        _dishes[index].likesCount--;
      }
      return _dishes[index].isFavorite;
    }
    return false;
  }

  /// Obtiene los platos favoritos
  Future<List<DishModel>> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _dishes.where((dish) => dish.isFavorite).toList();
  }

  /// Obtiene estadísticas generales
  Map<String, dynamic> getStatistics() {
    return {
      'totalDishes': _dishes.length,
      'totalCategories': getCategories().length - 1,
      'averageRating': _dishes.fold<double>(0, (sum, d) => sum + d.rating) / _dishes.length,
      'totalReviews': _dishes.fold<int>(0, (sum, d) => sum + d.reviewsCount),
      'minPrice': _dishes.map((d) => d.price).reduce((a, b) => a < b ? a : b),
      'maxPrice': _dishes.map((d) => d.price).reduce((a, b) => a > b ? a : b),
    };
  }
}
