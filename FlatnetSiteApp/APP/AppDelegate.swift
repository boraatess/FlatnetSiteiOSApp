//
//  AppDelegate.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 3.09.2025.
//

import UIKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import SVProgressHUD
import FirebaseCore
import FirebaseMessaging
import FirebaseCrashlytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate  {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        FirebaseApp.configure()                 // ⬅️ en üstte
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        UNUserNotificationCenter.current().delegate = self

        registerForPushNotifications()          // ⬅️ bundan sonra
        setupKeyboardManager()
        appStart()
        
        return true
    }
    
    func checkAppLaunch() {
        
        if AppLaunchManager.checkFirstLaunch() {
            
            KeychainHelper.shared.clearAll()
            
        }
        
    }
    
    func setupFirebase() {
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        if let app = FirebaseApp.app() {
               print("✅ Firebase başarıyla bağlandı: \(app.name)")
        } else {
            print("❌ Firebase bağlanamadı")
        }
           
    }
 
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("notification received: \(userInfo)")
        completionHandler(.newData)
    }

    private func registerForPushNotifications() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (succes, error) in
            // 1. Check to see if permission is granted
            guard succes else { return }
            print("success is APNS registered")
        }
        
        // 2. Attempt registration for remote notifications on the main thread
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    
    func setupKeyboardManager() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        // Toolbar aktif
        IQKeyboardToolbarManager.shared.isEnabled = true
        _=IQKeyboardToolbarManager.shared.toolbarConfiguration.doneBarButtonConfiguration?.title
        // Türkçe buton
    }
    
    func appStart() {
        
        checkAppLaunch()
        
        window = .init(frame: UIScreen.main.bounds)
        let rootVC = SplashViewController()
        let navController = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
    }
    
    func checkUser() {
        
        if AuthManager.shared.isLoggedIn {

            Crashlytics.crashlytics().log("Kullanıcı girişi başladı")
            Crashlytics.crashlytics().setUserID(AuthManager.shared.currentUser?.email)
            
            print("Token:", AuthManager.shared.accessToken ?? "")
            print("User:", AuthManager.shared.currentUser?.name ?? "")
            
        } else {
            
        }
        
    }

}

extension AppDelegate: MessagingDelegate {
    
    /*
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        #if targetEnvironment(simulator)
        let mockToken = "SIMULATOR_FAKE_TOKEN_12345"
        UserDefaults.standard.set(mockToken, forKey: "fcm_token")
        NotificationCenter.default.post(name: Notification.Name("FCMToken"),
                                        object: nil,
                                        userInfo: ["token": mockToken])
        print("⚠️ Simulator kullanılıyor - mock FCM token set edildi")
        return
        #endif

        // gerçek cihazda burası çalışır
        
        guard let token = fcmToken else {
            print("hata! fcmToken boş")
        }
        print("✅ Gerçek cihaz FCM token:", token)
        UserDefaults.standard.set(token, forKey: "fcm_token")
    }*/

    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("FCM TOKEN:", fcmToken ?? "")

        
        guard let fcmtoken = fcmToken, !fcmtoken.isEmpty else { return }

        print("Firebase registration token: \(String(describing: fcmtoken))")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                
                UserDefaults.standard.set(token, forKey: "fcm_token")
                
                // self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
                
            }
            
        }
        
        if AuthManager.shared.isLoggedIn {
            
            Services.shared.setPushNotification(token: fcmtoken) { result, error in
                
                if let response = result {
                    print(response)
                    
                }
                
                else {
                    print(error ?? "bir hata oluştu.")
                    
                    
                }
                
            }
            
        }
        
        
        
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       
        Messaging.messaging().apnsToken = deviceToken
        
        print("✅ APNs token registered:", deviceToken.map { String(format: "%02.2hhx", $0) }.joined())
        
        //Messaging.messaging().apnsToken = deviceToken
        let apnToken = deviceToken.hexString
        
        UserDefaults.standard.set(apnToken, forKey: "apn_token")
        
        if AuthManager.shared.isLoggedIn {
            print("Token:", AuthManager.shared.accessToken ?? "")
            print("User:", AuthManager.shared.currentUser?.name ?? "")
            
        } else {
            
            
        }
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print(error)
        
    }
    
    // Foreground notification gösterimi
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }

    
    
}
