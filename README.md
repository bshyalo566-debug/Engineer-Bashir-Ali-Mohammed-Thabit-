# Barcode Print Pro - Enterprise

**Enterprise-grade offline barcode scanning and thermal printing for Android.**

## Designed by
**Engineer Bashir Ali Muhammad Thabet**

**Contact: 776430697**

---

## Features

- **Barcode Scanning** - Real-time camera scanning using ML Kit
- **OCR Text Recognition** - Extract product names and prices from labels
- **ZPL II Thermal Printing** - Direct USB printing to Zebra printers
- **Encrypted Database** - AES-256 encrypted SQLite with SQLCipher
- **Print History** - Full history with search and export
- **User Authentication** - Secure login with session management
- **Multi-language** - Arabic & English support
- **Material 3 Design** - Modern UI with dark mode

## Architecture

Clean Architecture with BLoC pattern:
```
lib/
├── core/           # Errors, Database, DI, Utils
├── features/
│   ├── auth/       # Login & Authentication
│   ├── scanning/   # OCR + Barcode scanning
│   ├── printing/   # ZPL generator + USB drivers
│   ├── history/    # Print records & analytics
│   └── settings/   # App configuration
```

## Default Login

- **Username:** `admin`
- **Password:** `password`

## Build Instructions

### Prerequisites
- Flutter SDK >= 3.24.0
- Android Studio / VS Code
- Android device with USB OTG support

### Steps

```bash
# 1. Extract the ZIP file
cd barcode_print_pro

# 2. Get dependencies
flutter pub get

# 3. Build release APK
flutter build apk --release

# 4. Install on device
flutter install
```

The APK will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```

### USB Printer Setup
1. Connect Zebra printer via USB OTG cable
2. Grant USB permission when prompted
3. Go to "Printers" screen and tap "Connect"

## Dependencies

| Package | Purpose |
|---------|---------|
| `mobile_scanner` | Camera barcode scanning |
| `google_mlkit_text_recognition` | OCR text extraction |
| `usb_serial` | USB thermal printer communication |
| `sqflite_sqlcipher` | Encrypted SQLite database |
| `flutter_bloc` | State management |
| `get_it` | Dependency injection |

## License

Proprietary - All rights reserved.

---

**This application was designed by Engineer Bashir Ali Muhammad Thabet**
