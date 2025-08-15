# Disaster Guardian - Emergency Management Mobile App

A comprehensive cross-platform Disaster Management Mobile App built with Flutter, designed to help communities prepare for and respond to disasters effectively.

## 🚨 Features

### Core Functionality

#### 🔐 User Authentication
- **Sign up/Login** with email and password
- **Role-based access**: Citizen, Volunteer, or Authority
- **Google Account integration** (ready for implementation)
- **Profile management** with role-specific features

#### 🚨 Real-time Disaster Alerts
- **Live alerts** from weather APIs and government sources
- **Push notifications** for location-based warnings
- **Severity-based filtering** (Critical, Warning, Advisory)
- **Alert categorization** (Flood, Earthquake, Fire, Cyclone, etc.)
- **Offline alert caching** for emergency situations

#### 🗺️ Live Interactive Map
- **Google Maps integration** with real-time data
- **Color-coded markers** for different alert severities
- **Shelter locations** with capacity and status
- **Incident reports** with media attachments
- **User location tracking** with privacy controls

#### 📱 Incident Reporting
- **Multi-media support**: Photos, videos, audio recordings
- **GPS coordinates** automatic capture
- **SOS emergency mode** for immediate response
- **Offline reporting** with sync when connected
- **Status tracking** for reported incidents

#### 📱 Offline Mode
- **SQLite database** for local data storage
- **Cached alerts** and instructions
- **Offline incident reporting**
- **Automatic sync** when internet is restored

#### 👥 Volunteer Management
- **Volunteer registration** with skills and availability
- **Task assignment** and tracking
- **Real-time status updates**
- **Performance ratings** and feedback
- **Location-based task matching**

#### 🏠 Shelter Management (Authorities)
- **Add/Edit shelters** with capacity and amenities
- **Real-time occupancy tracking**
- **Status updates** (Open, Full, Closed, Maintenance)
- **Contact information** management

### Technical Features

#### 🔧 Architecture
- **MVVM pattern** with Riverpod state management
- **Clean architecture** with separated concerns
- **Repository pattern** for data access
- **Service layer** for business logic

#### 🔥 Backend Integration
- **Firebase Authentication** for user management
- **Cloud Firestore** for real-time data
- **Firebase Storage** for media files
- **Cloud Functions** for server-side logic
- **Firebase Cloud Messaging** for push notifications

#### 📱 Mobile Features
- **Cross-platform** (Android & iOS)
- **Responsive design** for all screen sizes
- **Dark mode** support
- **Multilingual support** (English, Hindi, Telugu, Tamil)
- **Accessibility features** for inclusive design

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (3.4.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd disaster_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication, Firestore, Storage, and Cloud Messaging
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the respective platform folders

4. **API Keys Configuration**
   - Get Google Maps API key from Google Cloud Console
   - Update the API key in `android/app/src/main/AndroidManifest.xml`
   - For iOS, update in `ios/Runner/AppDelegate.swift`

5. **Generate model files**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

### Environment Configuration

Create a `.env` file in the root directory:
```env
OPENWEATHER_API_KEY=your_openweather_api_key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

## 📱 App Structure

```
lib/
├── main.dart                 # App entry point
├── providers.dart            # Riverpod providers
├── alert.dart               # Alert model
├── models/                  # Data models
│   ├── user_model.dart
│   ├── incident_report.dart
│   ├── volunteer_task.dart
│   └── shelter.dart
├── services/                # Business logic services
│   ├── auth_service.dart
│   ├── database_service.dart
│   ├── notification_service.dart
│   ├── location_service.dart
│   ├── incident_service.dart
│   ├── volunteer_service.dart
│   └── disaster_alert_service.dart
└── screens/                 # UI screens
    ├── dashboard_screen.dart
    ├── alerts_screen.dart
    ├── map_screen.dart
    ├── incident_report_screen.dart
    ├── volunteer_screen.dart
    ├── shelter_screen.dart
    ├── profile_screen.dart
    └── ...
```

## 🔧 Configuration

### Firebase Setup
1. Enable Authentication methods (Email/Password, Google)
2. Create Firestore collections:
   - `users` - User profiles
   - `alerts` - Disaster alerts
   - `incidents` - Incident reports
   - `volunteers` - Volunteer information
   - `volunteer_tasks` - Task assignments
   - `shelters` - Emergency shelters

### Permissions
Add the following permissions to your app:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to show nearby alerts and shelters</string>
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to capture incident photos</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to record incident audio</string>
```

## 🚀 Deployment

### Android
1. Build the APK:
   ```bash
   flutter build apk --release
   ```

2. Build the App Bundle:
   ```bash
   flutter build appbundle --release
   ```

### iOS
1. Build for iOS:
   ```bash
   flutter build ios --release
   ```

2. Archive and upload to App Store Connect

## 📊 Testing

Run the test suite:
```bash
flutter test
```

### Test Coverage
- Unit tests for services
- Widget tests for UI components
- Integration tests for user flows

## 🔒 Security Features

- **Data encryption** for sensitive information
- **Secure API communication** with HTTPS
- **User authentication** with Firebase Auth
- **Role-based access control**
- **Input validation** and sanitization

## 🌐 API Integration

### Weather Alerts
- OpenWeather API for weather alerts
- Government disaster APIs (configurable)
- Custom alert creation for authorities

### Maps Integration
- Google Maps for location services
- Geocoding for address resolution
- Distance calculations for nearby features

## 📈 Performance Optimization

- **Image compression** for media uploads
- **Lazy loading** for large datasets
- **Caching strategies** for offline functionality
- **Background sync** for data updates

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Emergency Features

### SOS Mode
- **One-tap emergency** reporting
- **Immediate notification** to authorities
- **Location sharing** for quick response
- **Emergency contacts** integration

### Offline Capabilities
- **Cached emergency procedures**
- **Offline incident reporting**
- **Local shelter information**
- **Emergency contact access**

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🔄 Updates

Stay updated with the latest features and security patches by regularly updating the app and dependencies.

---

**Disaster Guardian** - Empowering communities through technology for better disaster preparedness and response.
