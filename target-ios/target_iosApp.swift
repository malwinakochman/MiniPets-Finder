//
//  target_iosApp.swift
//  target-ios
//
//  Created by Malwina Kochman on 07/06/2025.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import UIKit

@main
struct target_iosApp: App {
    @State private var showSplash = true
    // Reset tracking permission to force it to show again
    @State private var hasRequestedTracking = false
    @State private var timer: Timer? = nil
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .opacity(showSplash ? 0 : 1)
                    .onAppear {
                        // Request tracking immediately after splash disappears
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if !hasRequestedTracking {
                                print("[App] Will request tracking permission")
                                requestTracking()
                                hasRequestedTracking = true
                                // Only store this in UserDefaults after successfully showing dialog
                            }
                        }
                    }
                    
                if showSplash {
                    SplashView(showSplash: $showSplash)
                        .transition(.opacity)
                }
            }
            .preferredColorScheme(.dark)
            .onAppear {
                // Initialize AdMob in the background
                AdMobManager.shared.initializeAds()
            }
        }
    }
    
    private func requestTracking() {
        // Request tracking on the main thread
        print("[App] Requesting tracking authorization NOW")
        
        // Reset the UserDefaults value for testing
        UserDefaults.standard.removeObject(forKey: "hasRequestedTracking")
        
        DispatchQueue.main.async {
            // Check current status first
            let currentStatus = ATTrackingManager.trackingAuthorizationStatus
            print("[App] Current tracking status before request: \(currentStatus.rawValue)")
            
            // Use direct ATTrackingManager request for maximum visibility
            ATTrackingManager.requestTrackingAuthorization { status in
                print("[App] ATT status after request: \(status.rawValue)")
                
                // Only now save to UserDefaults that we've shown the dialog
                DispatchQueue.main.async {
                    UserDefaults.standard.set(true, forKey: "hasRequestedTracking")
                    print("[App] Saved tracking request status to UserDefaults")
                }
            }
        }
    }
}
