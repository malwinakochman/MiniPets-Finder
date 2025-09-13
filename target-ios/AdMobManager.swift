import GoogleMobileAds
import UIKit
import AppTrackingTransparency

class AdMobManager {
    static let shared = AdMobManager()
    private var interstitial: InterstitialAd?
    private var scanCount = 0
    private var lastAdDisplayTime: Date? = nil
    private let adCooldownInterval: TimeInterval = 120 // 2 minutes in seconds
    private var processedCodes = Set<String>() // Track already processed codes
    private var adsInitialized = false
    
    private init() {
        // Don't load ads in init - we'll load them after checking tracking authorization
    }
    
    // Initialize and start loading ads after tracking permission is determined
    func initializeAds() {
        if adsInitialized {
            return
        }
        
        print("[AdMobManager] Initializing Mobile Ads SDK")
        MobileAds.shared.start { [weak self] _ in
            print("[AdMobManager] Mobile Ads SDK initialization completed")
            self?.adsInitialized = true
            self?.loadInterstitial()
        }
    }
    
    func loadInterstitial() {
        print("[AdMobManager] Loading interstitial ad...")
        let request = GoogleMobileAds.Request()
        
        // Set personalization based on tracking authorization status
        let trackingStatus = TrackingAuthorizationManager.shared.authorizationStatus
        if trackingStatus == .authorized {
            // User consented to tracking - personalized ads
            print("[AdMobManager] Loading personalized ads (tracking authorized)")
        } else {
            // User did not consent to tracking - non-personalized ads
            print("[AdMobManager] Loading non-personalized ads (tracking not authorized)")
            // Set non-personalized ads flag
            let extras = Extras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
        }
        
        InterstitialAd.load(with: "ca-app-pub-8536372587204241/9005926700", request: request) { [weak self] ad, error in
            if let error = error {
                print("[AdMobManager] Failed to load interstitial: \(error.localizedDescription)")
            }
            if let ad = ad {
                print("[AdMobManager] Interstitial ad loaded successfully.")
                self?.interstitial = ad
            } else {
                print("[AdMobManager] Interstitial ad is nil after loading.")
            }
        }
    }
    
    func rootViewController() -> UIViewController? {
        // Get the first connected scene and its key window
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController
    }

    func showInterstitialIfAvailable(from root: UIViewController? = AdMobManager.shared.rootViewController()) {
        print("[AdMobManager] Attempting to show interstitial. Scan count: \(scanCount)")
        if let interstitial = interstitial, let root = root {
            print("[AdMobManager] RootViewController type: \(type(of: root))")
            // Add a delay to ensure the view hierarchy is ready after sheet dismissal
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if root.presentedViewController == nil {
                    print("[AdMobManager] Presenting interstitial ad after delay.")
                    interstitial.present(from: root)
                    self.interstitial = nil
                    self.loadInterstitial()
                } else {
                    print("[AdMobManager] RootViewController is presenting another view controller. Ad not shown.")
                }
            }
        } else {
            print("[AdMobManager] Interstitial not available or rootViewController is nil.")
        }
    }
    
    func incrementScanAndShowAdIfNeeded(from root: UIViewController? = AdMobManager.shared.rootViewController()) {
        scanCount += 1
        print("[AdMobManager] incrementScanAndShowAdIfNeeded called. Current scanCount: \(scanCount)")
        if scanCount % 5 == 0 {
            showInterstitialIfAvailable(from: root)
        }
    }
    
    // Function to count each scan even if it's the same code as before
    // but avoid counting repeated detections of the same code in rapid succession
    private var lastCodeScanned: String? = nil
    private var lastScanTime: Date? = nil
    private let repeatScanCooldown: TimeInterval = 15 // 15 seconds cooldown for the same code
    
    func incrementForUniqueCodeAndShowAdIfNeeded(code: String, from root: UIViewController? = AdMobManager.shared.rootViewController()) {
        let currentTime = Date()
        
        // Don't count the same code if scanned again within the cooldown period
        if let lastCode = lastCodeScanned, 
           let lastTime = lastScanTime,
           code == lastCode && 
           currentTime.timeIntervalSince(lastTime) < repeatScanCooldown {
            print("[AdMobManager] Same code detected within cooldown period, not counting: \(code)")
            return
        }
        
        // Update the last code and time
        lastCodeScanned = code
        lastScanTime = currentTime
        
        // Increment counter for each successful scan
        scanCount += 1
        print("[AdMobManager] Code scanned and counted. Current scanCount: \(scanCount)")
        
        if scanCount % 5 == 0 {
            showInterstitialIfAvailable(from: root)
        }
    }
    
    func showWishlistAdWithCooldown(from root: UIViewController? = AdMobManager.shared.rootViewController()) {
        let currentTime = Date()
        print("[AdMobManager] Checking if wishlist ad can be shown...")
        
        // Check if enough time has passed since last ad display
        if let lastTime = lastAdDisplayTime {
            let timeSinceLastAd = currentTime.timeIntervalSince(lastTime)
            print("[AdMobManager] Time since last ad: \(timeSinceLastAd) seconds")
            
            if timeSinceLastAd < adCooldownInterval {
                let remainingCooldown = adCooldownInterval - timeSinceLastAd
                print("[AdMobManager] Ad on cooldown. \(remainingCooldown) seconds remaining.")
                return
            }
        }
        
        // Update the last display time before attempting to show the ad
        // This ensures the cooldown applies even if the ad fails to load or show
        lastAdDisplayTime = currentTime
        print("[AdMobManager] Wishlist ad cooldown timer started.")
        
        // Then try to show the ad
        if let interstitial = interstitial, let root = root {
            print("[AdMobManager] Valid interstitial found, attempting to show.")
            showInterstitialIfAvailable(from: root)
        } else {
            print("[AdMobManager] No valid interstitial available to show.")
            loadInterstitial() // Try to load a new ad for next time
        }
    }
}
