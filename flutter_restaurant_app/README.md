# 🍽️ Restaurant Ecommerce - Flutter App

Aplicación de ecommerce para restaurante con servicio de delivery a domicilio desarrollada en Flutter.

[![Open in Firebase Studio](https://firebase.studio/button.svg)](https://idx.google.com/import?url=https://github.com/EcmcodeApps/censo-uso-app)

---

## 🚀 Abrir en Google IDX / Firebase Studio (Recomendado)

> **IDX** es el IDE en la nube de Google — no necesitas instalar NADA en tu computador.

### Paso 1 — Ir a Firebase Studio

Abre tu navegador y entra a:
```
https://firebase.studio
```
Inicia sesión con tu cuenta de Google.

---

### Paso 2 — Importar el proyecto desde GitHub

1. Haz clic en **"Import a repo"** o **"New workspace"**
2. Selecciona **"Import from GitHub"**
3. Pega esta URL del repositorio:
   ```
   https://github.com/EcmcodeApps/censo-uso-app
   ```
4. En tipo de proyecto selecciona **"Flutter"**
5. Haz clic en **"Create Workspace"**

> IDX detectará automáticamente el archivo `.idx/dev.nix` y configurará Flutter, el SDK de Android y todas las herramientas necesarias.

---

### Paso 3 — Esperar la configuración automática (~2 minutos)

IDX hará todo esto solo:
- ✅ Instala Flutter SDK
- ✅ Instala Android SDK
- ✅ Instala extensiones de Dart y Flutter
- ✅ Ejecuta `flutter pub get` (instala dependencias)

---

### Paso 4 — Ejecutar la app

Una vez que el workspace esté listo, tienes dos opciones:

**Opción A — Panel de Preview (más fácil):**
1. Busca el panel **"Preview"** en el lado derecho
2. Selecciona **"Android"**
3. ¡El emulador abre directo en el navegador!

**Opción B — Terminal integrada:**
```bash
# Para ver en el emulador Android (recomendado)
flutter run

# Para ver en el navegador web
flutter run -d chrome

# Para instalar dependencias si hace falta
flutter pub get
```

---

### Paso 5 — ¡Listo! Empieza a editar

- Abre `lib/main.dart` para ver la estructura principal
- Abre `lib/screens/search_screen.dart` para editar la pantalla de búsqueda
- Cada cambio que guardes se refleja al instante con **Hot Reload** (Ctrl+S)

---

## 📱 Características de la App

| Función | Descripción |
|---------|-------------|
| 🔍 **Buscador** | Busca por nombre, ingredientes o categoría |
| ⭐ **Calificaciones** | Estrellas + promedio + número de reviews |
| ❤️ **Favoritos** | Botón de corazón con contador de likes |
| 🏷️ **Filtros** | Por categoría, rango de precio y rating mínimo |
| 📄 **Paginación** | Navega entre páginas de resultados |
| 🛒 **Detalle del plato** | Pantalla completa con ingredientes y precio |

---

## 📁 Estructura del Proyecto

```
flutter_restaurant_app/
├── .idx/
│   └── dev.nix              ← Configuración automática de IDX
├── lib/
│   ├── main.dart            ← Punto de entrada + navegación
│   ├── constants/
│   │   └── app_constants.dart   ← Colores, estilos
│   ├── models/
│   │   └── dish_model.dart      ← Modelo de datos del plato
│   ├── providers/
│   │   └── dish_provider.dart   ← Estado global
│   ├── screens/
│   │   └── search_screen.dart   ← Pantalla de búsqueda principal
│   ├── services/
│   │   └── dish_service.dart    ← Datos y lógica de búsqueda
│   └── widgets/
│       ├── dish_card.dart       ← Tarjeta visual del plato
│       └── search_bar_widget.dart ← Barra de búsqueda y filtros
├── pubspec.yaml             ← Dependencias del proyecto
└── launch.sh               ← Script de inicio rápido
```

---

## 🎨 Platos de Muestra Incluidos

La app viene con **12 platos** de ejemplo listos para probar:

| Plato | Categoría | Rating |
|-------|-----------|--------|
| Strawberry Cake | Postres | ⭐ 5.0 |
| French Fries | Entradas | ⭐ 5.0 |
| Maxican Fried Rice | Platos Fuertes | ⭐ 5.0 |
| Pasta Carbonara | Platos Fuertes | ⭐ 4.8 |
| Tacos al Pastor | Platos Fuertes | ⭐ 4.9 |
| Chocolate Brownie | Postres | ⭐ 4.9 |
| Grilled Salmon | Platos Fuertes | ⭐ 4.7 |
| Mojito Clásico | Bebidas | ⭐ 4.8 |
| Caesar Salad | Ensaladas | ⭐ 4.6 |
| Manchau Soup | Sopas | ⭐ 5.0 |

---

## 🔧 Personalización Rápida

### Cambiar colores
Edita `lib/constants/app_constants.dart`:
```dart
static const Color primary = Color(0xFFFF9800); // Naranja → cambia aquí
```

### Agregar un plato nuevo
Edita `lib/services/dish_service.dart` y agrega al final de la lista:
```dart
DishModel(
  id: '13',
  name: 'Tu Nuevo Plato',
  description: 'Descripción deliciosa',
  imageUrl: 'https://tu-imagen.com/foto.jpg',
  price: 18.99,
  preparationTimeMin: 20,
  preparationTimeMax: 30,
  rating: 4.7,
  reviewsCount: 45,
  category: 'Platos Fuertes',
  ingredients: ['Ingrediente 1', 'Ingrediente 2'],
),
```

---

## 🔮 Ideas para Próximas Versiones

1. 🛒 **Carrito de compras** con gestión de cantidades
2. 💳 **Checkout** con MercadoPago o Stripe
3. 📍 **Tracking GPS** del domiciliario en tiempo real
4. 🔔 **Notificaciones push** con Firebase
5. 💬 **Chat** con el restaurante
6. 🎟️ **Cupones** y descuentos
7. 📸 **Reviews con fotos** de los clientes
8. 📊 **Dashboard** para el administrador del restaurante

---

## ❓ Solución de Problemas en IDX

**El emulador no carga:**
```bash
# En la terminal de IDX ejecuta:
flutter clean
flutter pub get
flutter run
```

**Error de dependencias:**
```bash
flutter pub upgrade
flutter pub get
```

**Hot reload no funciona:**
- Presiona `r` en la terminal para hot reload manual
- Presiona `R` para hot restart completo

---

Desarrollado con ❤️ en Flutter para Google IDX / Firebase Studio
