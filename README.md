![up](https://user-images.githubusercontent.com/89120990/222953037-06f9f906-2a07-4014-9a31-230cbce1a8bf.png)


# Soca: Blind person helper
Soca is a blind-person helper app to connects blind people and volunteers. Soca used video calling and integrated with Google Assistant and Siri.

A new Flutter project.

## Getting Started

This project uses Flavor for the environment, and the current environment is development, staging, and Production. Therefore, you need to configure the project before the run or to build the project.

### Environtment
This project uses Flutter Flavor and has 3 environments. 
|                     | Development                     | Staging                        | Production                        |
|---------------------|---------------------------------|--------------------------------|-----------------------------------|
| `Debuging`          | ✅                              | ❌                              | ❌                                |
| `App Identifier`    | com.firgia.soca.dev             | com.firgia.soca.stg            | com.firgia.soca                   |
| `App Name Android`  | Soca - Dev                      | Soca - Stg                     | Soca                              |
| `App Name IOS`      | Soca - Dev                      | Soca - Stg                     | Soca                              |
| `App Icons`         | ![d](http://bit.ly/3YhoyWx)     |![s](https://bit.ly/soca-icon-s)| ![p](https://bit.ly/soca-icon-pp) |


* Development: Select this environment while updating or adding new features to test.
* Staging: Select this environment if you want to test the release app and share the App with your team.
* Production: Select this environment when the App is ready to deploy for public.

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
