import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = "ca-app-pub-8536372587204241/5043750521"
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        
        // Create request with proper privacy settings
        let request = Request()
        
        // If ATT permission was granted, we can use personalized ads
        if ATTrackingManager.trackingAuthorizationStatus == .authorized {
            print("[BannerAdView] Loading personalized ads")
        } else {
            // Otherwise, respect user's privacy preference
            print("[BannerAdView] Loading non-personalized ads")
            
            // Set up extra parameters for a non-personalized ad request
            // This is the equivalent to "tagForChildDirectedTreatment" in older SDKs
            let extras = RequestConfiguration()
            extras.tagForChildDirectedTreatment = true
        }
        
        banner.load(request)
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {}
}
