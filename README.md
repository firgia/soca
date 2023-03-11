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
1. Open your Firebase project > Project Settings > download the GoogleService-info.plist file. (if you don't have it, add a new iOS app by clicking the "Add app" button on your Firebase project Settings).
![Group 7](https://user-images.githubusercontent.com/89120990/224487684-0faaa432-a1dd-498d-b5ef-99af4b6ed55f.png)

2. Now you have 3 GoogleService-info.plist file with different environments (Development, Staging, and Production)
3. Create a "config" folder, and create three folders inside "config" folder with the following name "production", "development", and "staging". Move all GoogleService-Info.plist to a specific environment folder. 
<img width="344" alt="Screenshot 2023-03-11 at 20 39 06" src="https://user-images.githubusercontent.com/89120990/224488079-63dca4d1-bc6c-4e77-b581-a25611ec1993.png">

4. Open your project on XCode.
5. Drag your "config" folder to runner section.
6. Check "copy items if needed", and "Runner". And then click finish button.
![Group 8](https://user-images.githubusercontent.com/89120990/224488536-69573d9e-d8d8-4d3e-baf7-4b556aaededc.png)

7. You will see the config folder on runner after click finish button
![Group 9](https://user-images.githubusercontent.com/89120990/224488722-ebfeb8f3-81a3-4628-b3ba-ab2ea0901e8c.png)

8. Open GoogleService-Info.plist on your config > Development folder and copy "REVERSED_CLIENT_ID" value. 
![Group 10](https://user-images.githubusercontent.com/89120990/224489345-09f80c80-fce9-4633-af87-0cf4b68213cd.png)

9. Go to targets Runner > Build Settings > fill out filter with "Reversed_Client_ID", and paste your REVERSED_CLIENT_ID to Debug-Development, Profile-Development, and Release-Development value.
![Group 11](https://user-images.githubusercontent.com/89120990/224489482-0bb19bac-7160-40c5-bd24-329c2623e25c.png)

10. Repeat step 8 and 9 for staging and production environtment.
12. Done!


