//
//  ChatterUpAppApp.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 26/04/2024.
//

import SwiftUI
import FirebaseCore

@main
struct ChatterUpAppApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SignInView()
            }
            .accentColor(Color.theme.primaryBlue)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
