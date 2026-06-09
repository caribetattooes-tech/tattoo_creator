class TrendItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> suggestedHashtags;
  final String? exampleImageUrl;
  final int popularityScore; // 1-100
  final bool isNew;

  const TrendItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.suggestedHashtags,
    this.exampleImageUrl,
    required this.popularityScore,
    this.isNew = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'suggestedHashtags': suggestedHashtags,
      'exampleImageUrl': exampleImageUrl,
      'popularityScore': popularityScore,
      'isNew': isNew,
    };
  }

  factory TrendItem.fromJson(Map<String, dynamic> json) {
    return TrendItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      suggestedHashtags: List<String>.from(json['suggestedHashtags'] as List),
      exampleImageUrl: json['exampleImageUrl'] as String?,
      popularityScore: json['popularityScore'] as int,
      isNew: json['isNew'] as bool? ?? false,
    );
  }
}

// Predefined trend items for tattoo content
class TrendData {
  TrendData._();

  static const List<TrendItem> tattooTrends = [
    TrendItem(
      id: '1',
      title: 'Proceso Time-lapse',
      description: 'Muestra el tatuaje en tiempo real acelerado',
      category: 'Proceso',
      suggestedHashtags: ['#timelapse', '#tattooprocess', '#tattooing'],
      popularityScore: 95,
      isNew: false,
    ),
    TrendItem(
      id: '2',
      title: 'Before & After',
      description: 'Comparación del diseño inicial vs resultado final',
      category: 'Before/After',
      suggestedHashtags: ['#beforeandafter', '#tattootransformation', '#freshink'],
      popularityScore: 92,
      isNew: false,
    ),
    TrendItem(
      id: '3',
      title: 'Close-up Detalles',
      description: 'Primeros planos del trabajo de líneas y sombras',
      category: 'Detalles',
      suggestedHashtags: ['#tattoodetail', '#closeuptattoo', '#tattootechnology'],
      popularityScore: 88,
      isNew: false,
    ),
    TrendItem(
      id: '4',
      title: 'Diseño al Final',
      description: 'Muetra el diseño terminado desde diferentes ángulos',
      category: 'Diseño',
      suggestedHashtags: ['#tattoodesign', '#customtattoo', '#tattooidea'],
      popularityScore: 85,
      isNew: true,
    ),
    TrendItem(
      id: '5',
      title: 'Behind the Scenes',
      description: 'Momentos del estudio, preparación, herramientas',
      category: 'Estudio',
      suggestedHashtags: ['#tattoostudio', '#tattooartistlife', '#inklife'],
      popularityScore: 82,
      isNew: false,
    ),
    TrendItem(
      id: '6',
      title: 'Proceso de Sanación',
      description: 'Evolución del tatuaje durante la sanación',
      category: 'Proceso',
      suggestedHashtags: ['#healingtattoo', '#tattoocare', '#tattooaftercare'],
      popularityScore: 78,
      isNew: true,
    ),
    TrendItem(
      id: '7',
      title: 'Blackwork Arte',
      description: 'Trabajos en negro puro, patrones geométricos',
      category: 'Estilos',
      suggestedHashtags: ['#blackworktattoo', '#blackink', '#neotraditional'],
      popularityScore: 90,
      isNew: true,
    ),
    TrendItem(
      id: '8',
      title: 'Cliente Reacciona',
      description: 'Reacción del cliente al ver su tatuaje terminado',
      category: 'Testimonial',
      suggestedHashtags: ['#tattooreaction', '#clientlove', '#happyclient'],
      popularityScore: 87,
      isNew: false,
    ),
  ];
}