/// Modelo de datos para representar un plato del restaurante
class DishModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final int preparationTimeMin;
  final int preparationTimeMax;
  final double rating;
  final int reviewsCount;
  final String category;
  final List<String> ingredients;
  final bool isAvailable;
  final bool isPopular;
  final bool isNew;
  bool isFavorite;
  int likesCount;

  DishModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.preparationTimeMin,
    required this.preparationTimeMax,
    required this.rating,
    required this.reviewsCount,
    required this.category,
    this.ingredients = const [],
    this.isAvailable = true,
    this.isPopular = false,
    this.isNew = false,
    this.isFavorite = false,
    this.likesCount = 0,
  });

  /// Retorna el tiempo de preparación formateado
  String get preparationTimeFormatted {
    return '$preparationTimeMin-$preparationTimeMax min';
  }

  /// Retorna el precio formateado con símbolo de moneda
  String get priceFormatted {
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Crea una copia del modelo con valores modificados
  DishModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    int? preparationTimeMin,
    int? preparationTimeMax,
    double? rating,
    int? reviewsCount,
    String? category,
    List<String>? ingredients,
    bool? isAvailable,
    bool? isPopular,
    bool? isNew,
    bool? isFavorite,
    int? likesCount,
  }) {
    return DishModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      preparationTimeMin: preparationTimeMin ?? this.preparationTimeMin,
      preparationTimeMax: preparationTimeMax ?? this.preparationTimeMax,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      isAvailable: isAvailable ?? this.isAvailable,
      isPopular: isPopular ?? this.isPopular,
      isNew: isNew ?? this.isNew,
      isFavorite: isFavorite ?? this.isFavorite,
      likesCount: likesCount ?? this.likesCount,
    );
  }

  /// Convierte a Map para almacenamiento o API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'preparationTimeMin': preparationTimeMin,
      'preparationTimeMax': preparationTimeMax,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'category': category,
      'ingredients': ingredients,
      'isAvailable': isAvailable,
      'isPopular': isPopular,
      'isNew': isNew,
      'isFavorite': isFavorite,
      'likesCount': likesCount,
    };
  }

  /// Crea un DishModel desde un Map (JSON)
  factory DishModel.fromJson(Map<String, dynamic> json) {
    return DishModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      preparationTimeMin: json['preparationTimeMin'] ?? 15,
      preparationTimeMax: json['preparationTimeMax'] ?? 30,
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? 0,
      category: json['category'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      isAvailable: json['isAvailable'] ?? true,
      isPopular: json['isPopular'] ?? false,
      isNew: json['isNew'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      likesCount: json['likesCount'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'DishModel(id: $id, name: $name, rating: $rating, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DishModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Modelo para representar una reseña de un plato
class ReviewModel {
  final String id;
  final String dishId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final int helpfulCount;

  ReviewModel({
    required this.id,
    required this.dishId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.helpfulCount = 0,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      dishId: json['dishId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userAvatarUrl: json['userAvatarUrl'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      helpfulCount: json['helpfulCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dishId': dishId,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'helpfulCount': helpfulCount,
    };
  }
}

/// Categorías de platos disponibles
enum DishCategory {
  all('Todos', 'all'),
  appetizers('Entradas', 'appetizers'),
  mainCourse('Platos Fuertes', 'main_course'),
  desserts('Postres', 'desserts'),
  drinks('Bebidas', 'drinks'),
  soups('Sopas', 'soups'),
  salads('Ensaladas', 'salads'),
  specials('Especiales', 'specials');

  final String displayName;
  final String value;

  const DishCategory(this.displayName, this.value);
}
