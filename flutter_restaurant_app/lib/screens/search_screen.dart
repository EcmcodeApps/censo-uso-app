import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dish_model.dart';
import '../providers/dish_provider.dart';
import '../widgets/dish_card.dart';
import '../widgets/search_bar_widget.dart';

/// Pantalla principal de búsqueda de platos
/// Replica el diseño de la imagen de referencia
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  final int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    // Inicializar datos al cargar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DishProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Barra de búsqueda
          SearchBarWidget(
            controller: _searchController,
            hintText: 'Search',
            onChanged: _onSearchChanged,
            onFilterTap: _showFilterBottomSheet,
          ),

          // Lista de resultados
          Expanded(
            child: Consumer<DishProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.dishes.isEmpty) {
                  return _buildLoadingState();
                }

                if (provider.error.isNotEmpty) {
                  return _buildErrorState(provider.error);
                }

                final dishes = provider.displayedDishes;

                if (dishes.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildDishList(dishes, provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el AppBar personalizado
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text(
        'Search',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.tune, color: Colors.black87),
          onPressed: _showFilterBottomSheet,
        ),
      ],
    );
  }

  /// Construye la lista de platos
  Widget _buildDishList(List<DishModel> dishes, DishProvider provider) {
    // Calcular paginación
    final totalPages = (dishes.length / _itemsPerPage).ceil();
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, dishes.length);
    final paginatedDishes = dishes.sublist(startIndex, endIndex);

    return Column(
      children: [
        // Lista de platos
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => provider.initialize(),
            color: Colors.orange,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: paginatedDishes.length,
              itemBuilder: (context, index) {
                final dish = paginatedDishes[index];
                return DishCard(
                  dish: dish,
                  onTap: () => _onDishTap(dish),
                  onFavoriteToggle: () => _onFavoriteToggle(dish.id),
                );
              },
            ),
          ),
        ),

        // Paginación
        if (totalPages > 1) _buildPagination(totalPages),
      ],
    );
  }

  /// Construye los controles de paginación
  Widget _buildPagination(int totalPages) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botón anterior
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: _currentPage > 1 ? Colors.black87 : Colors.grey[300],
            ),
            onPressed: _currentPage > 1
                ? () {
                    setState(() => _currentPage--);
                    _scrollToTop();
                  }
                : null,
          ),

          // Indicador de página
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$_currentPage / $totalPages',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),

          // Botón siguiente
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: _currentPage < totalPages ? Colors.black87 : Colors.grey[300],
            ),
            onPressed: _currentPage < totalPages
                ? () {
                    setState(() => _currentPage++);
                    _scrollToTop();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  /// Estado de carga
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando platos...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron resultados',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otra búsqueda o ajusta los filtros',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: _resetFilters,
            icon: const Icon(Icons.refresh, color: Colors.orange),
            label: const Text(
              'Limpiar filtros',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  /// Estado de error
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Ocurrió un error',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<DishProvider>().initialize(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  /// Maneja cambios en el campo de búsqueda
  void _onSearchChanged(String query) {
    setState(() => _currentPage = 1);
    context.read<DishProvider>().searchDishes(query);
  }

  /// Maneja el tap en un plato
  void _onDishTap(DishModel dish) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DishDetailScreen(dish: dish),
      ),
    );
  }

  /// Maneja el toggle de favorito
  void _onFavoriteToggle(String dishId) {
    context.read<DishProvider>().toggleFavorite(dishId);
  }

  /// Muestra el bottom sheet de filtros
  void _showFilterBottomSheet() {
    final provider = context.read<DishProvider>();
    final stats = DishService().getStatistics();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        minPrice: stats['minPrice'].toDouble(),
        maxPrice: stats['maxPrice'].toDouble(),
        currentPriceRange: provider.priceRange,
        minRating: provider.minRating,
        categories: provider.categories,
        selectedCategory: provider.selectedCategory,
        onApply: (priceRange, minRating, category) {
          provider.applyFilters(
            priceRange: priceRange,
            minRating: minRating,
            category: category,
          );
          setState(() => _currentPage = 1);
        },
      ),
    );
  }

  /// Resetea los filtros
  void _resetFilters() {
    _searchController.clear();
    setState(() => _currentPage = 1);
    context.read<DishProvider>().resetFilters();
  }

  /// Scroll al inicio de la lista
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

/// Import necesario para el servicio
import '../services/dish_service.dart';

/// Pantalla de detalle del plato
class DishDetailScreen extends StatelessWidget {
  final DishModel dish;

  const DishDetailScreen({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // AppBar con imagen
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.orange,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    dish.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.restaurant, size: 100),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Consumer<DishProvider>(
                builder: (context, provider, _) {
                  final currentDish = provider.dishes.firstWhere(
                    (d) => d.id == dish.id,
                    orElse: () => dish,
                  );
                  return IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        currentDish.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: currentDish.isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                    onPressed: () => provider.toggleFavorite(dish.id),
                  );
                },
              ),
            ],
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre y precio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          dish.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        dish.priceFormatted,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Categoría y tiempo
                  Row(
                    children: [
                      _buildInfoChip(Icons.category, dish.category),
                      const SizedBox(width: 12),
                      _buildInfoChip(Icons.access_time, dish.preparationTimeFormatted),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Rating
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < dish.rating.floor() ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                          size: 24,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${dish.rating} (${dish.reviewsCount} reviews)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Descripción
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dish.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ingredientes
                  const Text(
                    'Ingredientes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: dish.ingredients.map((ingredient) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          ingredient,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Likes
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${dish.likesCount} personas les gusta este plato',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100), // Espacio para el botón
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: dish.isAvailable
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${dish.name} agregado al carrito'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              dish.isAvailable ? 'Agregar al Carrito - ${dish.priceFormatted}' : 'No Disponible',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
