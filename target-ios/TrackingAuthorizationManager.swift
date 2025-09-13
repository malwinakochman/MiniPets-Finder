import AppTrackingTransparency
import AdSupport
import UIKit

class TrackingAuthorizationManager {
    static let shared = TrackingAuthorizationManager()
    
    private init() {}
    
    typealias AuthorizationCompletion = (ATTrackingManager.AuthorizationStatus) -> Void
    
    // Check current authorization status
    var authorizationStatus: ATTrackingManager.AuthorizationStatus {
        return ATTrackingManager.trackingAuthorizationStatus
    }
    
    // Request tracking authorization with optional completion handler
    func requestTrackingAuthorization(completion: AuthorizationCompletion? = nil) {
        // Check if we're already in a determined state
        if authorizationStatus != .notDetermined {
            print("[TrackingAuthorizationManager] Authorization already determined: \(self.statusString(for: authorizationStatus))")
            completion?(authorizationStatus)
            return
        }
        
        // Request tracking immediately - no delays
        print("[TrackingAuthorizationManager] Requesting tracking authorization immediately")
        ATTrackingManager.requestTrackingAuthorization { status in
            print("[TrackingAuthorizationManager] Authorization status: \(self.statusString(for: status))")
            
            // Execute completion handler on main thread
            DispatchQueue.main.async {
                completion?(status)
            }
        }
    }
    
    // Determine if tracking is authorized
    var isTrackingAuthorized: Bool {
        return authorizationStatus == .authorized
    }
    
    // Convert status to readable string for debugging
    private func statusString(for status: ATTrackingManager.AuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorized:
            return "authorized"
        @unknown default:
            return "unknown"
        }
    }
}