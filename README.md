# Wasla Academy Platform

A comprehensive educational platform connecting students with universities, institutes, and trainers across Yemen.

## 📱 About the App

**Wasla Academy** is an integrated e-learning platform designed to:
- Connect students with educational service providers (universities, institutes, trainers)
- Provide online courses across various fields
- Manage live lectures and exams
- Issue verified digital certificates
- Enable communication between students and instructors

## ✨ Features

### For Students
- ✅ Browse courses by category and level  
- ✅ Enroll in free or paid courses  
- ✅ Track lesson progress  
- ✅ Attend live classes  
- ✅ Take exams and receive certificates  
- ✅ Participate in discussions  
- ✅ Chat with instructors  

### For Instructors and Institutions
- ✅ Create and manage courses  
- ✅ Add lessons and learning materials  
- ✅ Create and manage exams  
- ✅ Monitor student progress  
- ✅ Issue certificates  

## 🛠️ Technologies Used

- **Framework**: Flutter 3.4.3+  
- **State Management**: BLoC Pattern  
- **Database**: Supabase (PostgreSQL)  
- **Storage**: Supabase Storage  
- **Authentication**: Supabase Auth  
- **UI**: Material Design + Custom Widgets  

## 📦 Main Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.5
  equatable: ^2.0.5
  flutter_screenutil: ^5.9.0
  cached_network_image: ^3.3.1
  carousel_slider: ^4.2.1
  video_player: ^2.9.2
  intl: ^0.19.0
```

## 🚀 Getting Started

### Requirements
- Flutter SDK 3.4.3+  
- Dart SDK 3.0.0+  
- Android Studio or VS Code  
- Supabase account (for production)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/fahm99/wasla_academy-ELearning-platform.git
cd wasla_academy-ELearning-platform
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🗂️ Project Structure

```
lib/
├── src/
│   ├── blocs/
│   ├── config/
│   ├── constants/
│   ├── data/
│   │   └── repositories/
│   ├── models/
│   ├── services/
│   ├── utils/
│   ├── views/
│   └── widgets/
└── main.dart

assets/
├── data/
└── images/
```

## 🔧 Configuration

### 1. Setup Supabase

Follow the steps in [SUPABASE_INTEGRATION_GUIDE.md](SUPABASE_INTEGRATION_GUIDE.md)

### 2. Update Supabase Configuration

In `lib/src/config/supabase_config.dart`:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

## 📱 Available Screens

- ✅ Splash Screen  
- ✅ Login & Signup  
- ✅ Home Page  
- ✅ Course List  
- ✅ Course Details  
- ✅ Course Player  
- ✅ Exams  
- ✅ Profile  
- ✅ Settings  
- ✅ Notifications  
- ✅ Chats  
- ✅ Discussions  
- ✅ Certificates & Achievements  
- ✅ Live Lectures  

## 🎨 Design

- ✅ Light & Dark Mode  
- ✅ Arabic RTL Support  
- ✅ Fully Responsive Layout  
- ✅ Material Design 3  

## 📄 Documentation

- [Development Plan](DEVELOPMENT_PLAN.md)  
- [Supabase Integration Guide](SUPABASE_INTEGRATION_GUIDE.md)  
- [Flutter HTML Integration Summary](FLUTTER_HTML_INTEGRATION_SUMMARY.md)

## 🧪 Testing

```bash
flutter test
flutter analyze
flutter format .
```

## 📦 Build for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contribution

We welcome contributions!  
1. Fork the repository  
2. Create a feature branch  
3. Commit your changes  
4. Push your branch  
5. Open a Pull Request  

## 📝 License

This project is licensed under the [MIT License](LICENSE).

## 📞 Contact

- 🌐 Website: [waslaacademy.com](https://waslaacademy.com)  
- 📧 Email: info@waslaacademy.com  
- 🛠️ Support: support@waslaacademy.com  

## 🙏 Acknowledgment

Thanks to everyone contributing to this project!

---
