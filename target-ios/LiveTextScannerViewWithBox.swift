import Foundation
import Dispatch
import Vision
import SwiftUI
import UIKit
import AVFoundation

struct LiveTextScannerViewWithBox: UIViewControllerRepresentable {
    var onCodeDetected: (String, CGRect) -> Void
    var onCodeLost: () -> Void
    var onCameraPermissionDenied: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        
        // Delay camera permission check - this allows tracking permission to show first
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            print("[LiveTextScannerViewWithBox] Now checking camera permission (delayed to allow tracking permission first)")
            self.checkCameraPermission(controller: controller, context: context)
        }
        
        return controller
    }
    
    private func checkCameraPermission(controller: UIViewController, context: Context) {
        // Check camera permission status
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authStatus {
        case .authorized:
            setupCameraSession(controller: controller, context: context)
        case .notDetermined:
            // Request camera permission
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        _ = self.setupCameraSession(controller: controller, context: context)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.onCameraPermissionDenied()
                    }
                }
            }
        case .denied, .restricted:
            // Camera permission denied
            DispatchQueue.main.async {
                self.onCameraPermissionDenied()
            }
        @unknown default:
            break
        }
    }
    
    private func setupCameraSession(controller: UIViewController, context: Context) -> Bool {
        let session = AVCaptureSession()
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.default(for: .video) else {
            print("Failed to get camera device")
            onCameraPermissionDenied()
            return false
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
            
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
            session.addOutput(output)

            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = UIScreen.main.bounds
            previewLayer.videoGravity = .resizeAspectFill
            
            // Ensure the preview fills the screen appropriately on different devices
            if UIDevice.current.userInterfaceIdiom == .pad {
                // For iPad, we might need to ensure proper centering and scaling
                previewLayer.contentsGravity = .resizeAspectFill
            }
            
            controller.view.layer.addSublayer(previewLayer)

            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
            }
            context.coordinator.session = session
            context.coordinator.previewLayer = previewLayer
            
            return true
        } catch {
            print("Failed to setup camera: \(error.localizedDescription)")
            onCameraPermissionDenied()
            return false
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: LiveTextScannerViewWithBox
        var lastDetected: String?
        var lastBoundingBox: CGRect?
        var session: AVCaptureSession?
        var previewLayer: AVCaptureVideoPreviewLayer?
        var lastDetectionTime: Date = Date()
        let codeLostTimeout: TimeInterval = 0.5
        var timer: Timer?

        init(parent: LiveTextScannerViewWithBox) {
            self.parent = parent
            super.init()
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if Date().timeIntervalSince(self.lastDetectionTime) > self.codeLostTimeout {
                    if self.lastDetected != nil {
                        self.lastDetected = nil
                        self.lastBoundingBox = nil
                        DispatchQueue.main.async {
                            self.parent.onCodeLost()
                        }
                    }
                }
            }
        }

        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            let request = VNRecognizeTextRequest { [weak self] request, error in
                guard let self = self, error == nil else { return }
                let results = request.results as? [VNRecognizedTextObservation] ?? []
                var found = false
                for observation in results {
                    if let candidate = observation.topCandidates(1).first {
                        let text = candidate.string.trimmingCharacters(in: .whitespacesAndNewlines)
                        if let match = text.range(of: "\\d{8,11}[A-Z]{2}", options: .regularExpression) {
                            let code = String(text[match])
                            let boundingBox = observation.boundingBox // normalized
                            if code != self.lastDetected || self.lastBoundingBox != boundingBox {
                                self.lastDetected = code
                                self.lastBoundingBox = boundingBox
                                DispatchQueue.main.async {
                                    self.parent.onCodeDetected(code, boundingBox)
                                }
                            }
                            self.lastDetectionTime = Date()
                            found = true
                            break
                        }
                    }
                }
                if !found {
                    // No code found in this frame
                }
            }
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en-US", "pl-PL"]
            request.usesLanguageCorrection = false
            try? requestHandler.perform([request])
        }
    }
}
