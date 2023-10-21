# Weather

A new Flutter application.

# Weather Api: https://openweathermap.org/api

## Getting Started
## 1. Setup env
Create .env file at root project with below properties: `WEATHER_URL=https://api.openweathermap.org`
`WEATHER_ICON_URL='https://openweathermap.org/img/wn/{name}@2x.png`
`WEATHER_API_KEY='d52427dc7b69022852d8627e53ad3dcb`

### 2. Build project
1. `flutter pub clean`
2. `flutter pub get`
3. `flutter pub run build_runner build --delete-conflicting-outputs`
4. `flutter run` to run app or click run button from your IDE

### 3. Default country code in Vietnam
- const _countryCode = 'VN';
