# Assets Folder - Slike

## Struktura

```
assets/
├── images/          - PNG, JPG slike
│   ├── logo.png
│   ├── splash.png
│   ├── apartment.png
│   ├── internship.png
│   ├── other.png
│   └── profile_placeholder.png
└── icons/           - Ostale slike (opciono)
```

## Ikonice

**Ikonice NISU u assets-ima!** Material Design ikone (`Icons.logout`, `Icons.search`, `Icons.person`, itd.) su već dostupne kroz Flutter biblioteku - nisu hardcoded.

## Kako Dodati Slike

1. **Spremi sliku u `assets/images/`**
2. **Ažurira `lib/constants/assets.dart`:**
   ```dart
   static const String myImage = 'assets/images/myimage.png';
   ```

3. **Koristi u kodu:**
   ```dart
   import 'package:skriptarnica/constants/assets.dart';
   
   Image.asset(AppAssets.logoImage)
   ```

## Veličine Preporuke

- **Logo**: 200x200px
- **Splash**: 1080x1920px
- **Ad Images**: 300x200px
- **Profile**: 100x100px

## Note

- `pubspec.yaml` je već konfiguriran sa `assets/images/`
- Flutter će automatski učitati sve slike iz tog foldera
