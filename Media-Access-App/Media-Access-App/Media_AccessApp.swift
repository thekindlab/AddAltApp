//
//  Media_AccessApp.swift
//  Media-Access
//
//  Created by Ian Vechey on 2/26/22.
// Fixed by Thuan and Selah on 1/10/2024
// where the program enters


import SwiftUI

@main
struct Media_AccessApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .background(Color.white)
        }
    }
}
