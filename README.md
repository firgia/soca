![up](https://user-images.githubusercontent.com/89120990/222953037-06f9f906-2a07-4014-9a31-230cbce1a8bf.png)


# Soca: Blind person helper
Soca is a blind-person helper app to connects blind people and volunteers. Soca used video calling and integrated with Google Assistant and Siri.

A new Flutter project.

## Getting Started

This project uses Flavor for the environment, and the current environment is development, staging, and Production. Therefore, you need to configure the project before the run or to build the project. Please follow this step to configure it.

### Firebase Configuration
We use firebase service to store the data and handle the Backend section. Don't hesitate to contact the code owner if you need to access the Firebase project for a real project. But if you want to use this project for personal only, you can create 3 Firebase projects (for development, staging & Production). You can follow this step if you have a prepared Firebase project (Development, Staging, and Production).

#### Android
1. Open your Firebase project > Project Settings > download the Google-Service.json file (if you don't have it, add a new android app by clicking the "Add app" button on your Firebase project Settings).
2. Now you have 3 Google-Service.json with different environments (Development, Staging, and Production)
3. Move the  Google-Service.json to folder android/app/src/{environtment}. Remember you need to move to a specific environment (check the attached image)
4.Done!

### IOS
1. Open your Firebase project > Project Settings > download the GoogleService-info.plist file. (if you don't have it, add a new android app by clicking the "Add app" button on your Firebase project Settings).
2. Now you have 3 GoogleService-info.plist file with different environments (Development, Staging, and Production)
