# Weather

A new Flutter application.

## Getting Started
## 1. Setup env
Create .env file at root project with below properties:
WEATHER_URL='https://api.openweathermap.org'
WEATHER_ICON_URL='https://openweathermap.org/img/wn/{name}@2x.png'
WEATHER_API_KEY='4496a83fcd217b8f04f8c2c57a582805'

### 2. Build project
1. `flutter pub clean`
2. `flutter pub get`
3. `flutter pub run build_runner build --delete-conflicting-outputs`
4. `flutter run` to run app or click run button from your IDE
