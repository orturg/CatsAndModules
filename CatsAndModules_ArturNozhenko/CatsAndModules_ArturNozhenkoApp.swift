//
//  CatsAndModules_ArturNozhenkoApp.swift
//  CatsAndModules_ArturNozhenko
//
//  Created by Artur Nozhenko on 17.05.2026.
//

import SwiftUI
import Firebase
import FirebaseCrashlytics

@main
struct CatsAndModules_ArturNozhenkoApp: App {
    
    @State private var isAlertPresented = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            CatsListScreen()
                .onAppear {
                    Crashlytics.crashlytics().setCustomValue(
                        Date().getDateAndTime(),
                        forKey: "app_launched"
                    )
                    
                    let isFirstLaunch = UserDefaults.standard.value(forKey: "isSetCrashlyticsCollectionEnabled") == nil
                    
                    if isFirstLaunch {
                        isAlertPresented = true
                    } else {
                        guard let isSetCrashlyticsCollectionEnabled = UserDefaults.standard.value(forKey: "isSetCrashlyticsCollectionEnabled") as? Bool else { return }
                        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(isSetCrashlyticsCollectionEnabled)
                    }
                }
            
                .alert("Do you agree to collect crash logs?", isPresented: $isAlertPresented, actions: {
                    Button("Cancel", role: .cancel) { UserDefaults.standard.set(false, forKey: "isSetCrashlyticsCollectionEnabled") }
                    
                    Button("Agree", role: .confirm) { UserDefaults.standard.set(true, forKey: "isSetCrashlyticsCollectionEnabled") }
                }, message: {
                    Text("We collect crash logs to improve user experience. Do you agree to share your crash data?")
                })
                
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
