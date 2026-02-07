# 🍽️ Restaurant Ecommerce - Flutter App

Aplicación de ecommerce para restaurante con servicio de delivery a domicilio desarrollada en Flutter.

## 📱 Características

- ✅ **Búsqueda de platos** con filtros avanzados
- ✅ **Sistema de calificaciones** con estrellas y promedios
- ✅ **Me gusta / Favoritos** con contador de likes
- ✅ **Filtros por categoría**, precio y calificación
- ✅ **Diseño responsivo** para Android e iOS
- ✅ **Paginación** de resultados
- ✅ **Estado manejado con Provider**

## 🚀 Guía de Implementación Paso a Paso

### Requisitos Previos

1. **Flutter SDK** (versión 3.0.0 o superior)
2. **Android Studio** o **VS Code**
3. **Dart SDK** (incluido con Flutter)
4. Dispositivo físico o emulador

### Paso 1: Instalar Flutter

```bash
# macOS/Linux
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verificar instalación
flutter doctor
```

### Paso 2: Configurar Android Studio

1. Descargar Android Studio desde: https://developer.android.com/studio
2. Instalar el plugin de Flutter:
   - Abrir Android Studio
   - File → Settings → Plugins
   - Buscar "Flutter" e instalar
   - Reiniciar Android Studio

3. Configurar el SDK de Android:
   - File → Settings → Languages & Frameworks → Flutter
   - Seleccionar la ruta del Flutter SDK

### Paso 3: Crear el Proyecto

```bash
# Opción A: Copiar los archivos del proyecto existente
cd flutter_restaurant_app
flutter pub get

# Opción B: Crear proyecto nuevo y copiar archivos
flutter create restaurant_ecommerce
cd restaurant_ecommerce
# Copiar los archivos de lib/ al nuevo proyecto
```

### Paso 4: Instalar Dependencias

El archivo `pubspec.yaml` incluye las siguientes dependencias:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  google_fonts: ^6.1.0
  flutter_rating_bar: ^4.0.1
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  provider: ^6.1.1
  intl: ^0.18.1
  uuid: ^4.2.2
```

Ejecutar:
```bash
flutter pub get
```

### Paso 5: Crear Carpeta de Assets

```bash
mkdir -p assets/images
mkdir -p assets/fonts
```

### Paso 6: Ejecutar la Aplicación

```bash
# Listar dispositivos disponibles
flutter devices

# Ejecutar en modo debug
flutter run

# Ejecutar en dispositivo específico
flutter run -d <device_id>

# Ejecutar con hot reload
flutter run --hot
```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada
├── constants/
│   └── app_constants.dart       # Colores, estilos, dimensiones
├── models/
│   └── dish_model.dart          # Modelo de datos para platos
├── providers/
│   └── dish_provider.dart       # Estado global con Provider
├── screens/
│   └── search_screen.dart       # Pantalla de búsqueda principal
├── services/
│   └── dish_service.dart        # Servicio de datos (mock/API)
└── widgets/
    ├── dish_card.dart           # Tarjeta de plato
    ├── search_bar_widget.dart   # Barra de búsqueda y filtros
    └── widgets.dart             # Exportaciones
```

## 🎨 Componentes Principales

### DishCard
Widget que muestra cada plato con:
- Imagen con placeholder
- Botón de favorito
- Nombre del plato
- Tiempo de preparación
- Calificación con estrellas
- Número de reviews

### SearchBarWidget
Barra de búsqueda con:
- Campo de texto con icono
- Botón de limpiar búsqueda
- Botón de filtros

### FilterBottomSheet
Panel de filtros con:
- Selector de categoría
- Rango de precio (slider)
- Calificación mínima (slider)

## 🔧 Personalización

### Cambiar Colores
Editar `lib/constants/app_constants.dart`:

```dart
class AppColors {
  static const Color primary = Color(0xFFFF9800);
  static const Color secondary = Color(0xFF4CAF50);
  // ...
}
```

### Agregar Nuevos Platos
Editar `lib/services/dish_service.dart`:

```dart
DishModel(
  id: '13',
  name: 'Nuevo Plato',
  description: 'Descripción del plato',
  imageUrl: 'https://...',
  price: 15.99,
  preparationTimeMin: 20,
  preparationTimeMax: 30,
  rating: 4.5,
  reviewsCount: 50,
  category: 'Platos Fuertes',
  ingredients: ['Ingrediente 1', 'Ingrediente 2'],
),
```

### Conectar con API Real
Modificar `lib/services/dish_service.dart`:

```dart
Future<List<DishModel>> getAllDishes() async {
  final response = await http.get(Uri.parse('$baseUrl/dishes'));
  final List<dynamic> data = json.decode(response.body);
  return data.map((json) => DishModel.fromJson(json)).toList();
}
```

## 📱 Screenshots

La aplicación replica el diseño de la imagen de referencia con:
- AppBar con botón atrás y título "Search"
- Barra de búsqueda con filtros
- Lista de platos con tarjetas
- Paginación en la parte inferior
- Sistema de favoritos interactivo

## 🔮 Próximas Funcionalidades (Ideas)

1. **Carrito de compras** con gestión de cantidades
2. **Checkout** con múltiples métodos de pago
3. **Tracking en tiempo real** del pedido
4. **Notificaciones push** para estado del pedido
5. **Historial de pedidos** del usuario
6. **Sistema de cupones** y descuentos
7. **Reviews y comentarios** de usuarios
8. **Geolocalización** para entregas
9. **Chat con el restaurante**
10. **Modo offline** con datos en caché

## 🛠️ Comandos Útiles

```bash
# Limpiar y reconstruir
flutter clean && flutter pub get

# Analizar código
flutter analyze

# Ejecutar tests
flutter test

# Construir APK
flutter build apk --release

# Construir iOS
flutter build ios --release

# Ver dependencias desactualizadas
flutter pub outdated
```

## 📄 Licencia

Este proyecto es de código abierto para fines educativos.

---

Desarrollado con ❤️ usando Flutter
