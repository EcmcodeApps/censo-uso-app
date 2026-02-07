import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/dish_model.dart';

/// Widget que representa una tarjeta de plato en la lista de búsqueda
/// Similar al diseño mostrado en la imagen de referencia
class DishCard extends StatelessWidget {
  final DishModel dish;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onAddToCart;

  const DishCard({
    super.key,
    required this.dish,
    this.onTap,
    this.onFavoriteToggle,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del plato con botón de favorito
            _buildDishImage(),
            const SizedBox(width: 16),
            // Información del plato
            Expanded(
              child: _buildDishInfo(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye la imagen del plato con el botón de favorito superpuesto
  Widget _buildDishImage() {
    return Stack(
      children: [
        // Imagen del plato
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: dish.imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 100,
              height: 100,
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 100,
              height: 100,
              color: Colors.grey[200],
              child: const Icon(
                Icons.restaurant,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        // Botón de favorito
        Positioned(
          top: 4,
          right: 4,
          child: _buildFavoriteButton(),
        ),
      ],
    );
  }

  /// Construye el botón de favorito (corazón)
  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: onFavoriteToggle,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          dish.isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 18,
          color: dish.isFavorite ? Colors.red : Colors.orange,
        ),
      ),
    );
  }

  /// Construye la información del plato (nombre, tiempo, calificación)
  Widget _buildDishInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nombre del plato
        Text(
          dish.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        // Tiempo de preparación
        _buildPreparationTime(),
        const SizedBox(height: 8),
        // Calificación y reviews
        _buildRatingRow(),
      ],
    );
  }

  /// Construye la fila del tiempo de preparación
  Widget _buildPreparationTime() {
    return Row(
      children: [
        Icon(
          Icons.access_time_outlined,
          size: 16,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Text(
          dish.preparationTimeFormatted,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// Construye la fila de calificación con estrellas y número de reviews
  Widget _buildRatingRow() {
    return Row(
      children: [
        // Estrellas de calificación
        _buildStarRating(),
        const SizedBox(width: 8),
        // Calificación numérica
        Text(
          dish.rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 4),
        // Número de reviews
        Text(
          '(${dish.reviewsCount} Reviews)',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[500],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// Construye las estrellas de calificación
  Widget _buildStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isFullStar = index < dish.rating.floor();
        final isHalfStar = index == dish.rating.floor() &&
            dish.rating % 1 >= 0.5;

        IconData iconData;
        if (isFullStar) {
          iconData = Icons.star;
        } else if (isHalfStar) {
          iconData = Icons.star_half;
        } else {
          iconData = Icons.star_border;
        }

        return Icon(
          iconData,
          size: 18,
          color: Colors.orange,
        );
      }),
    );
  }
}

/// Widget de tarjeta de plato con diseño horizontal más detallado
/// Incluye precio y botón de agregar al carrito
class DishCardExtended extends StatelessWidget {
  final DishModel dish;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onAddToCart;

  const DishCardExtended({
    super.key,
    required this.dish,
    this.onTap,
    this.onFavoriteToggle,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Parte superior: imagen y favorito
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: dish.imageUrl,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Icon(Icons.restaurant, size: 50),
                    ),
                  ),
                ),
                // Badges
                Positioned(
                  top: 12,
                  left: 12,
                  child: _buildBadges(),
                ),
                // Botón favorito
                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildFavoriteButton(),
                ),
              ],
            ),
            // Parte inferior: información
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          dish.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        dish.priceFormatted,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Tiempo y calificación
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        dish.preparationTimeFormatted,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      _buildCompactRating(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Botón agregar al carrito
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: dish.isAvailable ? onAddToCart : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        dish.isAvailable ? 'Agregar al Carrito' : 'No Disponible',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadges() {
    final badges = <Widget>[];

    if (dish.isNew) {
      badges.add(_buildBadge('Nuevo', Colors.green));
    }
    if (dish.isPopular) {
      badges.add(_buildBadge('Popular', Colors.orange));
    }

    return Row(children: badges);
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: onFavoriteToggle,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          dish.isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 20,
          color: dish.isFavorite ? Colors.red : Colors.orange,
        ),
      ),
    );
  }

  Widget _buildCompactRating() {
    return Row(
      children: [
        const Icon(Icons.star, size: 16, color: Colors.orange),
        const SizedBox(width: 4),
        Text(
          '${dish.rating.toStringAsFixed(1)} (${dish.reviewsCount})',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
