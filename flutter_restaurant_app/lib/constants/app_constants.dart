import 'package:flutter/material.dart';

/// Constantes de la aplicación
class AppConstants {
  AppConstants._();

  // Nombre de la aplicación
  static const String appName = 'Restaurant Delivery';
  static const String appVersion = '1.0.0';

  // Información del restaurante
  static const String restaurantName = 'Sabores del Chef';
  static const String restaurantSlogan = 'Deliciosa comida a tu puerta';
  static const String restaurantPhone = '+57 300 123 4567';
  static const String restaurantEmail = 'info@saboreschef.com';

  // Tiempos
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Paginación
  static const int itemsPerPage = 10;
  static const int maxSearchResults = 50;

  // Validación
  static const int minSearchLength = 2;
  static const int maxCartItems = 20;

  // URLs (para producción conectar con API real)
  static const String baseApiUrl = 'https://api.restaurant.com/v1';
  static const String imagesBaseUrl = 'https://images.restaurant.com';
}

/// Colores personalizados de la aplicación
class AppColors {
  AppColors._();

  // Colores principales
  static const Color primary = Color(0xFFFF9800);
  static const Color primaryDark = Color(0xFFF57C00);
  static const Color primaryLight = Color(0xFFFFE0B2);

  // Colores secundarios
  static const Color secondary = Color(0xFF4CAF50);
  static const Color accent = Color(0xFFFF5722);

  // Colores neutros
  static const Color background = Color(0xFFF8F8F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Estados
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Rating
  static const Color starFilled = Color(0xFFFFB300);
  static const Color starEmpty = Color(0xFFE0E0E0);

  // Favoritos
  static const Color favoriteActive = Color(0xFFE91E63);
  static const Color favoriteInactive = Color(0xFFBDBDBD);
}

/// Estilos de texto
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle price = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle rating = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}

/// Decoraciones reutilizables
class AppDecorations {
  AppDecorations._();

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get searchBarDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  static BoxDecoration chipDecoration({bool isSelected = false}) => BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade300,
        ),
      );
}

/// Dimensiones estándar
class AppDimensions {
  AppDimensions._();

  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // Iconos
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // Imágenes
  static const double dishImageSmall = 80.0;
  static const double dishImageMedium = 120.0;
  static const double dishImageLarge = 200.0;

  // AppBar
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 72.0;
}
