# Yes Order App
# BLoC Design Pattern

Flutter code example implemented by BLoC design pattern.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

## Database : Cloud Firestore

## Feature
- Product list
- Order history list
- Order detail list
- Add product for mock data
- Cutoff stock
- Product Location

## Dependencies
- cupertino_icons: ^0.1.2
- rxdart: ^0.22.1
- http: ^0.12.0+2
- cloud_firestore: ^0.12.9
- firebase_auth: ^0.14.0+2
- google_sign_in: ^4.0.1+3
- cache_image: ^0.0.3
- numberpicker: "^0.1.0"
- image_picker: ^0.6.0+8
- path_provider: ^1.2.0
- firebase_storage: ^3.0.5
- flutter_native_image: ^0.0.4
- google_maps_flutter: ^0.5.17
- location: ^2.3.5
- progress_dialog: ^1.1.0+1
- flutter_google_places: ^0.2.3
- geocoder: ^0.2.1
- geolocator: ^5.1.2
- firebase_core: ^0.4.0+8

## Getting Run
1. Setup Flutter
2. Clone the repo
- git clone https://github.com/taipower/BLOC_SHOPPING.git
- cd BLOC_SHOPPING
3. Setup Firebase
- You'll need to create a Firebase instance. Follow the instructions at https://console.firebase.google.com.
Once your Firebase instance is created, you'll need to enable google account authentication.
- Go to the Firebase Console for your new instance.
- Click "Authentication" in the left-hand menu.
- Click the "sign-in method" tab.
- Click "Google" and enable it.

3.1 Running on Android
- Create an app within your Firebase instance for Android, with package name com.example.bloc_shopping .
- Set SHA-1
- Download google-services.json . 
- place google-services.json into BLOC_SHOPPING/android/app/.

3.2 Running on IOS
- Create an app within your Firebase instance for iOS, with package name com.example.blocShopping
- Follow instructions to download GoogleService-Info.plist, and place it into BLOC_SHOPPING/ios/Runner in XCode
- Open BLOC_SHOPPING/ios/Runner/Info.plist. Locate the CFBundleURLSchemes key. The second item in the array value of this key is specific to the Firebase instance. Replace it with the value for REVERSED_CLIENT_ID from GoogleService-Info.plist
4. Run the app
Goto root project run
$ flutter run
5. Play App
- For payment credit card number 4242424242424242 is successful, other is fail

## Run Unit Test
- Goto root project run
- flutter test

## Reference
- https://medium.com/flutterpub/when-firebase-meets-bloc-pattern-fb5c405597e0
- https://github.com/SAGARSURI/Goals
