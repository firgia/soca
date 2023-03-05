![up](https://user-images.githubusercontent.com/89120990/222953037-06f9f906-2a07-4014-9a31-230cbce1a8bf.png)


# Soca: Blind person helper
Soca is a blind-person helper app to connects blind people and volunteers. Soca used video calling and integrated with Google Assistant and Siri.

## Getting Started

This section describes an overview of the project being built. 

### Environtment
This project uses Flutter Flavor and has 3 environments. 
|                     | Development                     | Staging                        | Production                        |
|---------------------|---------------------------------|--------------------------------|-----------------------------------|
| `Debuging`          | ✅                              | ❌                              | ❌                                |
| `App Identifier`    | com.firgia.soca.dev             | com.firgia.soca.stg            | com.firgia.soca                   |
| `App Name Android`  | Soca - Dev                      | Soca - Stg                     | Soca                              |
| `App Name IOS`      | Soca - Dev                      | Soca - Stg                     | Soca                              |
| `App Icons`         | ![d](http://bit.ly/3YhoyWx)     |![s](https://bit.ly/soca-icon-s)| ![p](https://bit.ly/soca-icon-pp) |


* **Development:** Select this environment while updating or adding new features to test.
* **Staging:** Select this environment if you want to test the release app and share the App with your team.
* **Production:** Select this environment when the App is ready to deploy for public.

### Third Party
We used some third parties to sprint the development process.
![Class Diagram - Page 1 (3)](https://user-images.githubusercontent.com/89120990/222963451-42c60ab7-16a4-4ca3-882c-2e733322fcc4.png)

* **Firebase Authentication:** provides backend services, easy-to-use SDKs, and ready-made UI libraries to authenticate users to our app.
* **Firebase Realtime Database:** a cloud-hosted NoSQL database that lets us store and sync data between our users in realtime.
* **Firebase Cloud Functions:** a serverless framework that lets us automatically run backend code in response to events triggered by Firebase features and HTTPS requests.
* **Firebase Cloud Firestore:** a NoSQL document database that lets us easily store, sync, and query data for our mobile and web apps - at global scale.
* **Firebase Cloud Storage** a powerful, simple, and cost-effective object storage service built for Google scale.
* **Agora:** is the leading video, voice and live interactive streaming platform, helping developers deliver rich in-app experiences—including embedded voice and video chat, real-time recording, interactive live streaming, and real-time messaging.
* **OneSignal:** The market-leading self-serve customer engagement solution for Push Notifications, Email, SMS & In-App.

## Setup
This project uses Flavor for the environment. You'll need to configure the project before you run or build the project. Please follow this step to configure it.

### Firebase Configuration
We use firebase service to store the data and handle the Backend section. Don't hesitate to contact the code owner if you need to access the Firebase project for a real project. But if you want to use this project for personal only, you can create 3 Firebase projects (for development, staging & Production). You can follow this step if you have a prepared Firebase project (Development, Staging, and Production).

#### Android
1. Open your Firebase project > Project Settings > download the google-services.json file (if you don't have it, add a new android app by clicking the "Add app" button on your Firebase project Settings).
![Group 2](https://user-images.githubusercontent.com/89120990/222965455-79157a85-8120-4bf3-8b0f-5d743f945ebe.png)
2. Now you have 3 google-services.json with different environments (Development, Staging, and Production)
3. Move the google-services.json to folder android/app/src/{environtment}. Remember you need to move to a specific environment
![Group 5](https://user-images.githubusercontent.com/89120990/222965708-aaa50c1f-c224-4931-8898-61c0bff641b6.png)
4. Done!

#### IOS
1. Open your Firebase project > Project Settings > download the GoogleService-info.plist file. (if you don't have it, add a new android app by clicking the "Add app" button on your Firebase project Settings).
2. Now you have 3 GoogleService-info.plist file with different environments (Development, Staging, and Production)
