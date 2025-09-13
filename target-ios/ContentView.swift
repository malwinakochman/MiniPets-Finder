import SwiftUI
import UIKit
import Vision
import SwiftUI
import AVFoundation
import Vision
import Combine
import GoogleMobileAds

// Utility struct to detect iPad and provide dynamic sizing
struct DeviceSize {
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static func dynamicSize(phone: CGFloat, pad: CGFloat) -> CGFloat {
        return isIPad ? pad : phone
    }
}

struct ContentView: View {
    @State private var detectedCode: String?
    @State private var currentFigure: LPSFigure?
    @State private var figureCount: Int = 0
    @State private var codeVisible: Bool = false
    @State private var codeBoundingBox: CGRect? = nil // Normalized (0-1)
    @State private var selectedTab: Int = 0
    @State private var showClearAlert = false
    @State private var showAllFigures = false // Controls the sheet for all figurines
    @ObservedObject private var historyManager = HistoryManager.shared
    @ObservedObject private var wishlistManager = WishlistManager.shared
    // --- Add state for scan search bar ---
    @State private var showScanSearchBar = false
    @State private var scanSearchText = ""
    @FocusState private var scanSearchBarFocused: Bool
    // --- New states for debounced search ---
    @State private var searchIsLoading = false
    @State private var searchPerformedText = ""
    @State private var searchDebounceTimer: Timer? = nil
    // --- Camera permission state ---
    @State private var cameraPermissionDenied = false

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // Main scanner and overlays
                if selectedTab == 0 {
                    ZStack(alignment: .top) {
                        // --- Main scanner and overlays (below search icon) ---
                        ZStack {
                            LiveTextScannerViewWithBox { code, boundingBox in
                                detectedCode = code
                                codeBoundingBox = boundingBox
                                if let figure = lpsFigures[code] {
                                    currentFigure = figure
                                    codeVisible = true
                                    // Add to history
                                    historyManager.addEntry(code: code, name: figure.name, imageName: figure.imageName)
                                    // --- Wishlist logic: ensure all codes for this figure are in wishlist, including the newly scanned code ---
                                    let codesForFigure = lpsFigures.filter { $0.value.imageName == figure.imageName }.map { $0.key }
                                    let codesInWishlist = codesForFigure.filter { wishlistManager.isInWishlist(code: $0) }
                                    if !codesInWishlist.contains(code) {
                                        // Add the newly scanned code to wishlist if any code for this figure is already in wishlist
                                        if !codesInWishlist.isEmpty {
                                            wishlistManager.toggle(code: code)
                                        }
                                    }
                                }
                                // Check if any code for this figure is in the wishlist
                                let isFigureInWishlist = wishlistManager.codes.contains { wishlistCode in
                                    if let wishlistFigure = lpsFigures[wishlistCode] {
                                        return wishlistFigure.imageName == lpsFigures[code]?.imageName
                                    }
                                    return false
                                }
                                // If any code for this figure is in wishlist, treat as in wishlist
                                if isFigureInWishlist {
                                    // Optionally, you can set a state to reflect this in the UI
                                }
                            } onCodeLost: {
                                codeVisible = false
                            } onCameraPermissionDenied: {
                                cameraPermissionDenied = true
                            }
                            .edgesIgnoringSafeArea(.all)
                            
                            
                            // Camera permission denied message
                            if cameraPermissionDenied {
                                // Full-screen blocking overlay
                                Rectangle()
                                    .fill(Color.black.opacity(0.7))
                                    .edgesIgnoringSafeArea(.all)
                                    .zIndex(100)
                                
                                // Modal pop-up for camera permissions (without settings button)
                                VStack(spacing: 24) {
                                    // Icon
                                    ZStack {
                                        Circle()
                                            .fill(Color(hex: "#cbb1cd").opacity(0.3))
                                            .frame(width: 110, height: 110)
                                        
                                        Image("camera_access_icon")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 70, height: 70)
                                            .foregroundColor(Color(hex: "#cbb1cd"))
                                            .shadow(color: Color(hex: "#cbb1cd").opacity(0.7), radius: 5, x: 0, y: 0)
                                    }
                                    
                                    // Text content
                                    VStack(spacing: 12) {
                                        Text("Camera Access Required")
                                            .font(.title2.bold())
                                            .foregroundColor(.white)
                                        
                                        Text("Please enable camera access in Settings to scan and identify pet figures by camera.")
                                            .font(.body)
                                            .foregroundColor(.white.opacity(0.9))
                                            .multilineTextAlignment(.center)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.horizontal)
                                    }
                                }
                                .padding(30)
                                .background(
                                    ZStack {
                                        VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                                            .fill(Color.black.opacity(0.3))
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color(hex: "#cbb1cd").opacity(0.6), Color(hex: "#cbb1cd").opacity(0.3)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ), 
                                            lineWidth: 2
                                        )
                                )
                                .shadow(color: Color.black.opacity(0.5), radius: 20, y: 10)
                                .padding(.horizontal, 40)
                                .zIndex(101) // Above the background overlay
                            }

                            // Only show the figurine photo overlay near the code
                            if let figure = currentFigure, codeVisible, let box = codeBoundingBox {
                                let frame = CGRect(x: box.minX * geo.size.width,
                                                   y: box.minY * geo.size.height,
                                                   width: box.width * geo.size.width,
                                                   height: box.height * geo.size.height)
                                let side = max(180, min(frame.width, frame.height, 300))
                                VStack(spacing: 0) {
                                    Image(figure.imageName)
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(width: side, height: side)
                                        .clipShape(RoundedRectangle(cornerRadius: 32))
                                        .shadow(radius: 14)
                                    Text(figure.name)
                                        .font(.headline)
                                        .padding(.top, 8)
                                        .padding(.bottom, 12)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 32)
                                        .fill(.ultraThinMaterial)
                                )
                                .cornerRadius(32)
                                .position(x: frame.midX, y: frame.minY - side/2 - 16 < 0 ? frame.maxY + side/2 + 16 : frame.minY - side/2 - 16)
                                .animation(.spring(), value: codeVisible)
                            }

                            // Title image for scanning and search icon in one HStack
                            if !cameraPermissionDenied {
                                HStack(alignment: .center) {
                                    Image("scan_title")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 64)
                                        .clipped()
                                    Spacer()
                                    Button(action: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            showScanSearchBar = true
                                            scanSearchBarFocused = true
                                        }
                                    }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.15))
                                            .frame(width: 44, height: 44)
                                            .background(
                                                VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                                                    .clipShape(Circle())
                                            )
                                            
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 22, weight: .semibold))
                                            .foregroundColor(Color(hex: "#cbb1cd"))
                                    }
                                    .shadow(radius: 6, y: 2)
                                }
                                .padding(.trailing, 18)
                            }
                            .padding(.top, 18)
                            .padding(.horizontal)
                            .background(Color.clear)
                            }
                        }
                        
                        // --- Top bar with search icon (removed duplicate) ---
                        /* Removed duplicate search icon */
                        // --- Modern animated search bar overlay ---
                        if showScanSearchBar {
                            VStack(spacing: 0) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(Color(hex: "#cbb1cd"))
                                        .padding(.leading, 5)
                                    ZStack(alignment: .leading) {
                                        if scanSearchText.isEmpty {
                                            Text("Search by code")
                                                .foregroundColor(Color.white.opacity(0.55))
                                                .font(.system(size: 19, weight: .semibold))
                                                .padding(.leading, 4)
                                        }
                                        TextField("", text: $scanSearchText)
                                            .padding(8)
                                            .background(Color.white.opacity(0.18))
                                            .cornerRadius(12)
                                            .font(.system(size: 18, weight: .medium))
                                            .autocapitalization(.none)
                                            .disableAutocorrection(true)
                                            .focused($scanSearchBarFocused)
                                            .onChange(of: scanSearchText) { newValue in
                                                searchIsLoading = true
                                                searchDebounceTimer?.invalidate()
                                                searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                                                    searchIsLoading = false
                                                    searchPerformedText = newValue
                                                }
                                            }
                                    }
                                    if !scanSearchText.isEmpty {
                                        Button(action: { scanSearchText = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Button(action: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            showScanSearchBar = false
                                            scanSearchText = ""
                                            scanSearchBarFocused = false
                                        }
                                    }) {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white.opacity(0.7))
                                            .padding(8)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 18)
                                .padding(.bottom, 8)
                                .background(VisualEffectBlur(blurStyle: .systemUltraThinMaterial).opacity(0.97))
                                .cornerRadius(22)
                                .shadow(radius: 12, y: 4)
                                // --- Search result logic ---
                                if !scanSearchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    if searchIsLoading {
                                        HStack {
                                            Spacer()
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#cbb1cd")))
                                                .scaleEffect(1.5)
                                                .padding(24)
                                            Spacer()
                                        }
                                    } else if let bestCode = lpsFigures.keys.filter({ $0.lowercased().contains(searchPerformedText.lowercased()) }).sorted().first, let figure = lpsFigures[bestCode] {
                                        VStack(spacing: 0) {
                                            Button(action: {
                                                currentFigure = figure
                                                codeVisible = true
                                                // Add to history if not already there
                                                historyManager.addEntry(code: bestCode, name: figure.name, imageName: figure.imageName)
                                                // Increment scan count and show ad if needed only for unique codes
                                                AdMobManager.shared.incrementForUniqueCodeAndShowAdIfNeeded(code: bestCode)
                                                showScanSearchBar = false
                                                scanSearchText = ""
                                                scanSearchBarFocused = false
                                            }) {
                                                HStack(spacing: 16) {
                                                    Image(figure.imageName)
                                                        .resizable()
                                                        .frame(width: 56, height: 56)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                    VStack(alignment: .leading) {
                                                        Text(figure.name)
                                                            .font(.headline)
                                                        Text(bestCode)
                                                            .font(.caption)
                                                            .foregroundColor(.gray)
                                                    }
                                                    Spacer()
                                                }
                                                .padding()
                                            }
                                        }
                                        .background(VisualEffectBlur(blurStyle: .systemUltraThinMaterial).opacity(0.92))
                                        .cornerRadius(22)
                                        .padding(.horizontal, 12)
                                        .transition(.move(edge: .top).combined(with: .opacity))
                                    } else {
                                        HStack {
                                            Spacer()
                                            Text("No results found.")
                                                .foregroundColor(.gray)
                                                .padding(24)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .padding(.top, 0)
                            .padding(.horizontal, 0)
                            .zIndex(10)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        LiveTextScannerViewWithBox { code, boundingBox in
                            detectedCode = code
                            codeBoundingBox = boundingBox
                            if let figure = lpsFigures[code] {
                                currentFigure = figure
                                codeVisible = true
                                // Add to history
                                historyManager.addEntry(code: code, name: figure.name, imageName: figure.imageName)
                                // Increment scan count and show ad if needed only for unique codes
                                AdMobManager.shared.incrementForUniqueCodeAndShowAdIfNeeded(code: code)
                                // --- Wishlist logic: ensure all codes for this figure are in wishlist, including the newly scanned code ---
                                let codesForFigure = lpsFigures.filter { $0.value.imageName == figure.imageName }.map { $0.key }
                                let codesInWishlist = codesForFigure.filter { wishlistManager.isInWishlist(code: $0) }
                                if !codesInWishlist.contains(code) {
                                    // Add the newly scanned code to wishlist if any code for this figure is already in wishlist
                                    if !codesInWishlist.isEmpty {
                                        wishlistManager.toggle(code: code)
                                    }
                                }
                            }
                            // Check if any code for this figure is in the wishlist
                            let isFigureInWishlist = wishlistManager.codes.contains { wishlistCode in
                                if let wishlistFigure = lpsFigures[wishlistCode] {
                                    return wishlistFigure.imageName == lpsFigures[code]?.imageName
                                }
                                return false
                            }
                            // If any code for this figure is in wishlist, treat as in wishlist
                            if isFigureInWishlist {
                                // Optionally, you can set a state to reflect this in the UI
                            }
                        } onCodeLost: {
                            codeVisible = false
                        } onCameraPermissionDenied: {
                            cameraPermissionDenied = true
                        }
                        .edgesIgnoringSafeArea(.all)

                        // Only show the figurine photo overlay near the code
                        if let figure = currentFigure, codeVisible, let box = codeBoundingBox {
                            let frame = CGRect(x: box.minX * geo.size.width,
                                               y: box.minY * geo.size.height,
                                               width: box.width * geo.size.width,
                                               height: box.height * geo.size.height)
                            let side = max(180, min(frame.width, frame.height, 300))
                            VStack(spacing: 0) {
                                Image(figure.imageName)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(width: side, height: side)
                                    .clipShape(RoundedRectangle(cornerRadius: 32))
                                    .shadow(radius: 14)
                                Text(figure.name)
                                    .font(.headline)
                                    .padding(.top, 8)
                                    .padding(.bottom, 12)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 32)
                                    .fill(.ultraThinMaterial)
                            )
                            .cornerRadius(32)
                            .position(x: frame.midX, y: frame.minY - side/2 - 16 < 0 ? frame.maxY + side/2 + 16 : frame.minY - side/2 - 16)
                            .animation(.spring(), value: codeVisible)
                        }

                        // Title image for scanning and search icon in one HStack
                        HStack(alignment: .center) {
                            Image("scan_title")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 64)
                                .clipped()
                            Spacer()
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    showScanSearchBar = true
                                    scanSearchBarFocused = true
                                }
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(Color(hex: "#cbb1cd"))
                                    .padding(10)
                                    .background(VisualEffectBlur(blurStyle: .systemUltraThinMaterial).opacity(0.85))
                                    .clipShape(Circle())
                                    .shadow(radius: 6, y: 2)
                            }
                            .padding(.trailing, 18)
                        }
                        .padding(.top, 18)
                        .padding(.horizontal)
                        .background(Color.clear)
                    }
                } else if selectedTab == 1 {
                    // History tab
                    VStack(alignment: .leading) {
                        HStack {
                            Image("history_title")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 64) // Increased height for better visibility
                                .clipped()
                            Spacer()
                            if !historyManager.entries.isEmpty {
                                Button(action: { showClearAlert = true }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(Color(hex: "#cbb1cd"))
                                }
                                .buttonStyle(PlainButtonStyle())
                                .alert(isPresented: $showClearAlert) {
                                    Alert(
                                        title: Text("Clear History?"),
                                        message: Text("Are you sure you want to remove all your history? This action cannot be undone."),
                                        primaryButton: .destructive(Text("Yes, clear all")) {
                                            historyManager.clear()
                                        },
                                        secondaryButton: .cancel(Text("No, keep it"))
                                    )
                                }
                            }
                        }
                        .padding(.top, 4)
                        .padding(.horizontal)
                        BannerAdView()
                            .frame(height: 50)
                            .padding(.vertical, 8)
                        if historyManager.entries.isEmpty {
                            Spacer()
                            Text("No history yet.")
                                .foregroundColor(.gray)
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                            Spacer()
                        } else {
                            let limitedEntries = Array(historyManager.entries.prefix(10))
                            List(limitedEntries) { entry in
                                HStack {
                                    Image(entry.imageName)
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    VStack(alignment: .leading) {
                                        Text(entry.name)
                                            .font(.headline)
                                        Text(entry.code)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text(entry.date, style: .date)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                            .listStyle(PlainListStyle())
                            .padding(.bottom, 64) // Add padding for navbar
                        }
                    }
                    .background(Color(.systemGroupedBackground))
                } else if selectedTab == 2 {
                    // Wishlist tab
                    VStack(alignment: .leading) {
                        HStack {
                            Image("wishlist_title")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 64)
                                .clipped()
                            Spacer()
                            Button(action: { showAllFigures = true }) {
                                Text("List of all")
                                    .font(.headline)
                                    .foregroundColor(Color(hex: "#cbb1cd"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Capsule().fill(Color.white.opacity(0.12)))
                            }
                        }
                        .padding(.top, 4)
                        .padding(.horizontal)
                        if wishlistManager.codes.isEmpty {
                            Spacer()
                            Text("No pets in wishlist.")
                                .foregroundColor(.gray)
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                            Spacer()
                        } else {
                            // Group wishlist codes by figure
                            let grouped = Dictionary(grouping: Array(wishlistManager.codes)) { code in
                                lpsFigures[code]?.imageName ?? code
                            }
                            ScrollView {
                                LazyVStack(spacing: 16) {
                                    ForEach(grouped.keys.sorted(), id: \.self) { imageName in
                                        if let codes = grouped[imageName], let firstCode = codes.first, let figure = lpsFigures[firstCode] {
                                            HStack(spacing: 16) {
                                                Image(figure.imageName)
                                                    .resizable()
                                                    .frame(width: 56, height: 56)
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                VStack(alignment: .leading) {
                                                    Text(figure.name)
                                                        .font(.headline)
                                                    Text({
                                                        let sortedCodes: [String]
                                                        if let detectedCode = detectedCode, codes.contains(detectedCode) {
                                                            sortedCodes = [detectedCode] + codes.filter { $0 != detectedCode }.sorted()
                                                        } else {
                                                            sortedCodes = codes.sorted()
                                                        }
                                                        return sortedCodes.joined(separator: " | ")
                                                    }())
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                }
                                                Spacer()
                                                Button(action: {
                                                    // Remove all codes for this figure from wishlist
                                                    codes.forEach { wishlistManager.toggle(code: $0) }
                                                }) {
                                                    Image(systemName: wishlistManager.isInWishlist(code: firstCode) ? "heart.fill" : "heart")
                                                        .resizable()
                                                        .frame(width: 28, height: 28)
                                                        .foregroundColor(Color(hex: "#d6bcd8"))
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                }
                                .padding(.top)
                                .padding(.bottom, 64) // Add padding for navbar
                            }
                        }
                    }
                    .background(Color(.systemGroupedBackground))
                    .sheet(isPresented: $showAllFigures, onDismiss: {
                        // Show ad with cooldown, then switch to wishlist tab ONLY if user was not already on wishlist
                        AdMobManager.shared.showWishlistAdWithCooldown()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            // Only switch if user was not already on wishlist before opening sheet
                            if selectedTab != 2 {
                                selectedTab = 2
                            }
                        }
                    }) {
                        AllFiguresSheet(wishlistManager: wishlistManager)
                            .onAppear {
                                AdMobManager.shared.loadInterstitial()
                                print("[AdMobManager] Preloading interstitial for List of all sheet.")
                            }
                    }
                } else {
                    // Help tab
                    VStack(alignment: .leading) {
                        HStack {
                            Image("help_title")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 64)
                                .clipped()
                            Spacer()
                        }
                        .padding(.top, 4)
                        .padding(.horizontal)
                        HStack {
                            Spacer()
                            ZStack {
                                // Glowing effect
                                Circle()
                                    .fill(Color(hex: "#cbb1cd").opacity(0.25))
                                    .frame(width: 160, height: 160)
                                    .blur(radius: 16)
                                Circle()
                                    .fill(Color.white.opacity(0.10))
                                    .frame(width: 140, height: 140)
                                    .blur(radius: 4)
                                Image("AppIcon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                                    .shadow(color: Color.gray.opacity(0.45), radius: 16, x: 0, y: 8)
                            }
                            Spacer()
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 4)
                        VStack(alignment: .center, spacing: 10) {
                            Text("More information about app at:")
                                .font(.headline)
                                .foregroundColor(Color.primary)
                                .multilineTextAlignment(.center)
                            Link(destination: URL(string: "https://malvapps.com")!) {
                                Text("malvapps.com")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "#cbb1cd"))
                                    .underline()
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 18)
                                    .background(
                                        Capsule()
                                            .fill(Color.white.opacity(0.12))
                                            .shadow(color: Color(hex: "#cbb1cd").opacity(0.18), radius: 8, x: 0, y: 2)
                                    )
                            }
                            
                            Spacer().frame(height: 16)
                            
                            ScrollView {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("This is a fan-made app. Basic Fun!, LITTLEST PET SHOP™, and HASBRO® do not sponsor, authorize, or endorse this app. The app does not sell or distribute figures it serves solely as a tool for collectors.")
                                        .font(.body)
                                        .foregroundColor(Color.primary)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal)
                                    
                                    Text("With the release of the latest figure series, you can identify which figure is inside the package by scanning a special code located on the bottom.")
                                        .font(.body)
                                        .foregroundColor(Color.primary)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal)
                                    
                                    HStack {
                                        Spacer()
                                        Image("codebox")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: DeviceSize.isIPad ? 300 : 200)
                                            .cornerRadius(8)
                                            .padding(.vertical, 8)
                                        Spacer()
                                    }
                                    
                                    Text("This is not official information from the manufacturer, so the method may not always work, but many users report that the data codes correctly match the figures.")
                                        .font(.body)
                                        .foregroundColor(Color.primary)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal)
                                    
                                    Text("The app lets you quickly scan the code and reveal which figure should be inside the package.")
                                        .font(.body)
                                        .foregroundColor(Color.primary)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal)
                                    
                                    Text("Please keep in mind that these identifications are not 100% guaranteed, as there is always a chance that errors occur during the packaging process at the factory.")
                                        .font(.body)
                                        .foregroundColor(Color.primary)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal)
                                }
                                .padding(.vertical, 8)
                            }
                            .frame(maxWidth: .infinity, maxHeight: DeviceSize.isIPad ? 600 : 300)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.10))
                            )
                            .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        Spacer()
                    }
                }
                // Codes with adding (counter) - just above the navbar
                VStack(spacing: 0) {
                    if selectedTab == 0, let figure = currentFigure, codeVisible {
                        // Check if any code for this figure is in the wishlist
                        let isFigureInWishlist = wishlistManager.codes.contains { wishlistCode in
                            if let wishlistFigure = lpsFigures[wishlistCode] {
                                return wishlistFigure.imageName == figure.imageName
                            }
                            return false
                        }
                        HStack(spacing: 16) {
                            Image(figure.imageName)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Text(figure.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                            Button(action: {
                                // Toggle all codes for this figure in wishlist
                                let codesForFigure = lpsFigures.filter { $0.value.imageName == figure.imageName }.map { $0.key }
                                let anyInWishlist = codesForFigure.contains { wishlistManager.isInWishlist(code: $0) }
                                codesForFigure.forEach { code in
                                    if anyInWishlist {
                                        if wishlistManager.isInWishlist(code: code) {
                                            wishlistManager.toggle(code: code)
                                        }
                                    } else {
                                        if !wishlistManager.isInWishlist(code: code) {
                                            wishlistManager.toggle(code: code)
                                        }
                                    }
                                }
                                // Switch to wishlist tab after adding/removing
                                selectedTab = 2
                            }) {
                                Image(systemName: isFigureInWishlist ? "heart.fill" : "heart")
                                    .font(.title)
                                    .padding(8)
                                    .foregroundColor(Color(hex: "#d6bcd8"))
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .shadow(radius: 8)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                    // Custom Tab Bar with animated belt highlight in front of icon, no white circle
                    ZStack(alignment: .bottom) {
                        HStack(spacing: 0) {
                            ForEach(0..<4) { idx in
                                navImageItem(imageName: tabImageName(for: idx), selected: selectedTab == idx, showBelt: selectedTab == idx)
                                    .onTapGesture { selectedTab = idx }
                            }
                        }
                        .frame(height: 60)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 0)
                    }
                    .frame(height: 70)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                    )
                    .clipShape(Capsule())
                    .padding(.horizontal, 6)
                    .padding(.bottom, 2) // smaller bottom padding, closer to edge
                }
            }
        }
        .onAppear {
            codeVisible = false
            selectedTab = 0 // Always open on scan tab after splash
            AdMobManager.shared.loadInterstitial() // Ensure ad is loaded on appear
        }
        .onChange(of: selectedTab) { newValue in
            // Show interstitial ad with cooldown when switching to wishlist tab (index 2)
            if newValue == 2 {
                AdMobManager.shared.showWishlistAdWithCooldown()
            }
        }
    }

    // Helper to get image name for tab index
    func tabImageName(for idx: Int) -> String {
        switch idx {
        case 0: return "scan"
        case 1: return "history"
        case 2: return "wishlist"
        case 3: return "help"
        default: return "scan"
        }
    }

    // Update navImageItem: no white circle, belt in front of icon, centered
    func navImageItem(imageName: String, selected: Bool, showBelt: Bool) -> some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: selected ? 38 : 30, height: selected ? 38 : 30)
                    .scaleEffect(selected ? 1.2 : 1.0)
                    .offset(y: selected ? -5 : 0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selected)
                if showBelt {
                    Capsule()
                        .fill(Color(hex: "#b1bfab"))
                        .frame(width: 38, height: 6)
                        .offset(y: 8)
                        .transition(.scale)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showBelt)
                }
            }
            .frame(maxWidth: .infinity)
            Spacer().frame(height: 6)
        }
        .padding(.vertical, 4)
    }
}

// HeartCheckbox: animated heart with celebration effect, using project binding
struct HeartCheckbox: View {
    @Binding var isLiked: Bool
    @State private var animateCelebrate = false

    var body: some View {
        ZStack {
            // Heart outline
            HeartShape()
                .stroke(Color(red: 1, green: 91/255, blue: 137/255), lineWidth: 2)
                .frame(width: 32, height: 32)
            // Filled heart with scale/brightness animation
            if isLiked {
                HeartShape()
                    .fill(Color(red: 1, green: 91/255, blue: 137/255))
                    .frame(width: 32, height: 32)
                    .scaleEffect(isLiked ? 1.2 : 0)
                    .brightness(isLiked ? 0.3 : 0)
                    .animation(.easeInOut(duration: 0.3), value: isLiked)
            }
            // Celebrate effect (dots)
            if animateCelebrate {
                CelebrateEffect()
                    .frame(width: 60, height: 60)
                    .animation(.easeOut(duration: 0.5), value: animateCelebrate)
                    .transition(.scale)
            }
            // Transparent toggle button
            Button(action: {
                if !isLiked {
                    animateCelebrate = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        animateCelebrate = false
                    }
                }
                isLiked.toggle()
            }) {
                Color.clear
            }
            .frame(width: 32, height: 32)
            .contentShape(Rectangle())
        }
        .frame(width: 32, height: 32)
    }
}

// AnimatedHeartView: animated heart with radiating lines, using @Binding for project integration
struct AnimatedHeartView: View {
    @Binding var isLiked: Bool
    @State private var animateLines = false

    var body: some View {
        ZStack {
            // Radiating animated lines
            ForEach(0..<8) { i in
                Rectangle()
                    .fill(Color(red: 1, green: 91/255, blue: 137/255).opacity(isLiked ? 1 : 0))
                    .frame(width: 2.5, height: 16)
                    .offset(y: -28)
                    .rotationEffect(.degrees(Double(i) / 8 * 360))
                    .scaleEffect(animateLines ? 1 : 0.1, anchor: .bottom)
                    .opacity(animateLines ? 1 : 0)
                    .animation(Animation.easeOut(duration: 0.4).delay(Double(i) * 0.05), value: animateLines)
            }
            // Heart icon
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundColor(isLiked ? Color(red: 1, green: 91/255, blue: 137/255) : .gray)
                .scaleEffect(isLiked ? 1.2 : 1)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isLiked)
            // Transparent tap area
            Button(action: {
                isLiked.toggle()
                if isLiked {
                    animateLines = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        animateLines = false
                    }
                }
            }) {
                Color.clear
            }
            .frame(width: 40, height: 40)
            .contentShape(Rectangle())
        }
        .frame(width: 40, height: 40)
    }
}

// SVG-like heart shape (as in your example)
struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: width * 0.5, y: height * 0.9))
        path.addCurve(to: CGPoint(x: 0, y: height * 0.35),
                      control1: CGPoint(x: width * 0.1, y: height * 0.9),
                      control2: CGPoint(x: 0, y: height * 0.6))
        path.addArc(center: CGPoint(x: width * 0.25, y: height * 0.25),
                    radius: width * 0.25,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        path.addArc(center: CGPoint(x: width * 0.75, y: height * 0.25),
                    radius: width * 0.25,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        path.addCurve(to: CGPoint(x: width * 0.5, y: height * 0.9),
                      control1: CGPoint(x: width, y: height * 0.6),
                      control2: CGPoint(x: width * 0.9, y: height * 0.9))
        return path
    }
}

// Celebrate effect: dots around the heart
struct CelebrateEffect: View {
    var body: some View {
        ZStack {
            Group {
                Circle().frame(width: 6, height: 6).offset(x: -18, y: -18)
                Circle().frame(width: 6, height: 6).offset(x: -18, y: 0)
                Circle().frame(width: 6, height: 6).offset(x: -12, y: 18)
                Circle().frame(width: 6, height: 6).offset(x: 18, y: -18)
                Circle().frame(width: 6, height: 6).offset(x: 18, y: 0)
                Circle().frame(width: 6, height: 6).offset(x: 12, y: 18)
            }
            .foregroundColor(Color(red: 1, green: 91/255, blue: 137/255))
            .opacity(0.8)
        }
    }
}

// Helper to use hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Sheet view for all figurines, grouped by wave
struct AllFiguresSheet: View {
    @ObservedObject var wishlistManager: WishlistManager
    @State private var selectedWave: String? = nil
    @State private var searchText: String = ""
    let waveOrder = ["Wave 1", "Wave 2", "Wave 3", "Wave 4", "Wave 5"]
    // Group figures by wave using number ranges
    var figuresByWave: [String: [LPSFigure]] {
        var result: [String: [LPSFigure]] = ["Wave 1": [], "Wave 2": [], "Wave 3": [], "Wave 4": [], "Wave 5": []]
        for figure in Set(lpsFigures.values) {
            let number: Int? = {
                let comps = figure.name.components(separatedBy: CharacterSet.decimalDigits.inverted)
                if let numStr = comps.first(where: { !$0.isEmpty }), let num = Int(numStr) {
                    return num
                }
                return nil
            }()
            if let num = number {
                if (1...18).contains(num) {
                    result["Wave 1", default: []].append(figure)
                } else if (70...87).contains(num) {
                    result["Wave 2", default: []].append(figure)
                } else if (131...148).contains(num) {
                    result["Wave 3", default: []].append(figure)
                } else if (225...242).contains(num) {
                    result["Wave 4", default: []].append(figure)
                } else if (num >= 300) {
                    result["Wave 5", default: []].append(figure)
                }
            }
        }
        return result
    }
    // Filtered figures for search
    var filteredFigures: [LPSFigure] {
        let allFigures = Set(lpsFigures.values)
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return [] }
        return allFigures.filter { figure in
            let lower = trimmed.lowercased()
            let nameLower = figure.name.lowercased()
            let codeMatch = lpsFigures.first(where: { $0.value == figure })?.key.contains(trimmed) ?? false
            // Extract all numbers from the figure name
            let numbersInName = figure.name.components(separatedBy: CharacterSet.decimalDigits.inverted).filter { !$0.isEmpty }
            let numberMatch: Bool = {
                if let searchNum = Int(trimmed) {
                    // Match if any number in the name matches, or if the name contains '#searchNum' or 'searchNum' as a word
                    let hashMatch = figure.name.contains("#\(searchNum)")
                    let plainMatch = numbersInName.contains { $0 == String(searchNum) }
                    let wordMatch = figure.name.split(separator: " ").contains { $0 == trimmed }
                    return hashMatch || plainMatch || wordMatch
                }
                // Also match if the name contains the search string (for partials)
                return nameLower.contains(lower)
            }()
            let nameMatch = nameLower.contains(lower)
            return nameMatch || numberMatch || codeMatch
        }.sorted { lhs, rhs in
            let lnum = Int(lhs.name.components(separatedBy: CharacterSet.decimalDigits.inverted).first(where: { !$0.isEmpty }) ?? "0") ?? 0
            let rnum = Int(rhs.name.components(separatedBy: CharacterSet.decimalDigits.inverted).first(where: { !$0.isEmpty }) ?? "0") ?? 0
            return lnum < rnum
        }
    }
    var body: some View {
        NavigationView {
            ZStack {
                VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                    .opacity(0.85)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    // Modern search bar (now above bookmarks)
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(hex: "#cbb1cd"))
                        ZStack(alignment: .leading) {
                            if searchText.isEmpty {
                                Text("Search by number or name")
                                    .foregroundColor(Color.white.opacity(0.55))
                                    .font(.system(size: 19, weight: .semibold))
                                    .padding(.leading, 4)
                            }
                            TextField("", text: $searchText)
                                .padding(8)
                                .background(Color.white.opacity(0.18))
                                .cornerRadius(12)
                                .font(.system(size: 18, weight: .medium))
                        }
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    .padding(.bottom, 6)
                    
                    // Scrollable wave selector with proper spacing for SOON label
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(waveOrder, id: \.self) { wave in
                                if wave == "Wave 5" {
                                    Button(action: {}) {
                                        ZStack(alignment: .topTrailing) {
                                            Text(wave)
                                                .fontWeight(.regular)
                                                .foregroundColor(Color.gray.opacity(0.55))
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 16)
                                                .padding(.top, 10) // Extra top padding for the SOON label
                                                .background(Color.clear)
                                                .cornerRadius(16)
                                            
                                            Text("SOON")
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                                .padding(.horizontal, 7)
                                                .padding(.vertical, 2)
                                                .background(Color(hex: "#cbb1cd").opacity(0.7))
                                                .cornerRadius(8)
                                                .offset(x: 18, y: -10)
                                        }
                                    }
                                    .disabled(true)
                                } else {
                                    Button(action: { selectedWave = wave }) {
                                        Text(wave)
                                            .fontWeight(selectedWave == wave ? .bold : .regular)
                                            .foregroundColor(selectedWave == wave ? Color(hex: "#cbb1cd") : .primary)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 16)
                                            .padding(.top, 10) // Add matching top padding to keep all buttons aligned
                                            .background(selectedWave == wave ? Color(hex: "#f3e8fa").opacity(0.7) : Color.clear)
                                            .cornerRadius(16)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 12) // Add top padding to the HStack to ensure SOON label is visible
                    }
                    .padding(.bottom, 4)
                    
                    Divider()
                    
                    // Show search results if searching
                    if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                        let searchNum = Int(trimmed)
                        List {
                            ForEach(filteredFigures, id: \.imageName) { figure in
                                HStack(spacing: 16) {
                                    Image(figure.imageName)
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    VStack(alignment: .leading) {
                                        Text(figure.name)
                                            .font(.headline)
                                    }
                                    Spacer()
                                    Button(action: {
                                        let codesForFigure = lpsFigures.filter { $0.value.imageName == figure.imageName }.map { $0.key }
                                        let anyInWishlist = codesForFigure.contains { wishlistManager.isInWishlist(code: $0) }
                                        codesForFigure.forEach { code in
                                            if anyInWishlist {
                                                if wishlistManager.isInWishlist(code: code) {
                                                    wishlistManager.toggle(code: code)
                                                }
                                            } else {
                                                if !wishlistManager.isInWishlist(code: code) {
                                                    wishlistManager.toggle(code: code)
                                                }
                                            }
                                        }
                                    }) {
                                        let codesForFigure = lpsFigures.filter { $0.value.imageName == figure.imageName }.map { $0.key }
                                        let anyInWishlist = codesForFigure.contains { wishlistManager.isInWishlist(code: $0) }
                                        Image(systemName: anyInWishlist ? "heart.fill" : "heart")
                                            .resizable()
                                            .frame(width: 28, height: 28)
                                            .foregroundColor(Color(hex: "#d6bcd8"))
                                    }
                                }
                            }
                        }
                        .background(Color.clear)
                    } else if let wave = selectedWave, let figures = figuresByWave[wave], !figures.isEmpty {
                        List {
                            ForEach(figures.sorted(by: { lhs, rhs in
                                let lnum = Int(lhs.name.components(separatedBy: CharacterSet.decimalDigits.inverted).first(where: { !$0.isEmpty }) ?? "0") ?? 0
                                let rnum = Int(rhs.name.components(separatedBy: CharacterSet.decimalDigits.inverted).first(where: { !$0.isEmpty }) ?? "0") ?? 0
                                return lnum < rnum
                            }), id: \.imageName) { figure in
                                HStack(spacing: 16) {
                                    Image(figure.imageName)
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    VStack(alignment: .leading) {
                                        Text(figure.name)
                                            .font(.headline)
                                    }
                                    Spacer()
                                    Button(action: {
                                        let codesForFigure = lpsFigures.filter { $0.value.imageName == figure.imageName }.map { $0.key }
                                        let anyInWishlist = codesForFigure.contains { wishlistManager.isInWishlist(code: $0) }
                                        codesForFigure.forEach { code in
                                            if anyInWishlist {
                                                if wishlistManager.isInWishlist(code: code) {
                                                    wishlistManager.toggle(code: code)
                                                }
                                            } else {
                                                if !wishlistManager.isInWishlist(code: code) {
                                                    wishlistManager.toggle(code: code)
                                                }
                                            }
                                        }
                                    }) {
                                        let codesForFigure = lpsFigures.filter { $0.value.imageName == figure.imageName }.map { $0.key }
                                        let anyInWishlist = codesForFigure.contains { wishlistManager.isInWishlist(code: $0) }
                                        Image(systemName: anyInWishlist ? "heart.fill" : "heart")
                                            .resizable()
                                            .frame(width: 28, height: 28)
                                            .foregroundColor(Color(hex: "#d6bcd8"))
                                    }
                                }
                            }
                        }
                        .background(Color.clear)
                    } else {
                        Spacer()
                        Text("Select a wave to see figures")
                            .foregroundColor(.gray)
                            .padding(.top, 40)
                        Spacer()
                    }
                }
                .navigationTitle("All Figurines")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    if selectedWave == nil {
                        selectedWave = waveOrder.first
                    }
                }
            }
        }
    }
}
