# TattooCreator

App de edición de video para tatuadores - crea contenido viral para Instagram.

## Características

- **Inspiración basada en tendencias**: Ideas basadas en hashtags populares de tatuajes
- **Importación de medios**: Selecciona fotos y videos desde tu galería
- **Plantillas de video**: 6 plantillas pre-diseñadas para diferentes estilos
- **Generación automática**: La app ensambla tu contenido con transiciones y música
- **Exportación optimizada**: Formatos para Instagram Reels, Stories y Posts

## Requisitos

- Flutter SDK 3.16+
- Xcode 15+
- iOS 12.0+

## Instalación

1. Clonar el repositorio
2. Ejecutar `flutter pub get`
3. Ejecutar `flutter run` o `flutter build ios`

## Estructura del proyecto

```
lib/
├── core/              # Constantes, theme, utilities
├── data/              # Models, repositories, services
├── domain/            # Entities, use cases
├── presentation/      # Providers, screens, widgets
└── infrastructure/    # Platform-specific code
```

## Uso

1. Abre la app y explora las ideas en tendencia
2. Selecciona una idea que te guste
3. Importa tus fotos y videos del proceso de tatuaje
4. Elige una plantilla de video
5. La app genera automáticamente el video
6. Exporta y comparte en Instagram

## Licencia

MIT License