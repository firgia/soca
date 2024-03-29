import UIKit
import PushKit
import Flutter
import flutter_callkit_incoming

enum ChannelName {
    static let siri = "com.firgia.soca/siri"
}

enum UserActivityType {
    static let callVolunteer = "com.firgia.soca.call_volunteer"
}


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // Setup Siri shortcuts
        createUserActivity()
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
          
        let siriChannel = FlutterEventChannel(name: ChannelName.siri, binaryMessenger: controller.binaryMessenger)
        siriChannel.setStreamHandler(self)
        
        // Setup VOIP
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Handle updated push credentials
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print(credentials.token)
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print(deviceToken)
        //Save deviceToken to your server
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("didInvalidatePushTokenFor")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    }
    
    // Handle incoming pushes
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("didReceiveIncomingPushWith")
        guard type == .voIP else { return }

        let dictionary = payload.dictionaryPayload;
        print(dictionary)
        
        guard let customData = dictionary["custom"] as? [String: Any] else{return}
        guard let contentData = customData["a"] as? [String: Any] else{return}
        guard let uuid = contentData["uuid"] as? String else{return}
        guard let voipType = contentData["type"] as? String else {return}
        
        if(voipType != "incoming_video_call" && voipType != "missed_video_call") {return}
        
        guard let userCaller = contentData["user_caller"] as? [String: Any] else{return}
        
        let avatar = userCaller["avatar"] as? String ?? ""
        let nameCaller = userCaller["name"] as? String ?? ""
        let data = flutter_callkit_incoming.Data(id: uuid, nameCaller: nameCaller, handle: "", type: 1)
            
        if(voipType == "incoming_video_call") {
            //set more data
            data.appName = "Soca"
            data.avatar = avatar
            data.extra = contentData as NSDictionary
            data.iconName = "AppIcon"
            // custom ringtone
            // data.ringtonePath = "notification_call.aiff"
            data.supportsDTMF = true
            data.supportsHolding = false
            data.supportsGrouping = false
            data.supportsUngrouping = false
            data.maximumCallGroups = 1
            
            SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)
        } else if (voipType == "missed_video_call"){
            SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endCall(data)
        }
    }
    
    /* SIRI SHORTCUTS */
   override func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
       if(eventSink != nil) {eventSink!(userActivityType)}
       return false
   }
   
   func createUserActivity(){
       let activity = NSUserActivity(activityType: UserActivityType.callVolunteer)
       
       activity.title = "Call a volunteer"
       activity.isEligibleForSearch = true
       activity.isEligibleForPrediction = true
       
       self.userActivity = activity
       self.userActivity?.becomeCurrent()
   }
   
   func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
       self.eventSink = events
       return nil
   }
   
   func onCancel(withArguments arguments: Any?) -> FlutterError? {
       eventSink = nil
       return nil
   }
}
