import UIKit
import PushKit
import Flutter
import flutter_callkit_incoming

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        //Setup VOIP
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Call back from Recent history
    //
    // This function triggered when user want to call other user from history phone call
    // We don't need this functions because app cannot allowed user to select specific target answered
    //    override func application(_ application: UIApplication,
    //                              continue userActivity: NSUserActivity,
    //                              restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    //
    //        guard let handleObj = userActivity.handle else {
    //            return false
    //        }
    //
    //        guard let isVideo = userActivity.isVideo else {
    //            return false
    //        }
    //        let nameCaller = handleObj.getDecryptHandle()["nameCaller"] as? String ?? ""
    //        let handle = handleObj.getDecryptHandle()["handle"] as? String ?? ""
    //        let data = flutter_callkit_incoming.Data(id: UUID().uuidString, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
    //        //set more data...
    //        data.nameCaller = "Firgia"
    //        print("startCall")
    //        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.startCall(data, fromPushKit: true)
    //
    //        return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
    //    }
        
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
}
