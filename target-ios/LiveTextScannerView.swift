import Foundation
import Dispatch
import Vision
import SwiftUI
import UIKit
import AVFoundation

struct LiveTextScannerView: UIViewControllerRepresentable {
    var onCodeDetected: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        let session = AVCaptureSession()
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return controller }

        session.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        session.addOutput(output)

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = UIScreen.main.bounds
        previewLayer.videoGravity = .resizeAspectFill
        controller.view.layer.addSublayer(previewLayer)

        session.startRunning()
        context.coordinator.session = session

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: LiveTextScannerView
        var lastDetected: String?
        var session: AVCaptureSession?

        init(parent: LiveTextScannerView) {
            self.parent = parent
        }

        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            let request = VNRecognizeTextRequest { [weak self] request, error in
                guard let self = self, error == nil else { return }
                let results = request.results as? [VNRecognizedTextObservation] ?? []
                for observation in results {
                    if let candidate = observation.topCandidates(1).first {
                        let text = candidate.string.trimmingCharacters(in: .whitespacesAndNewlines)
                        // Szukaj kodów w formacie np. 26123101ES (8 cyfr + 2 litery)
                        if let match = text.range(of: "\\d{8}[A-Z]{2}", options: .regularExpression) {
                            let code = String(text[match])
                            if code != self.lastDetected {
                                self.lastDetected = code
                                DispatchQueue.main.async {
                                    self.parent.onCodeDetected(code)
                                }
                            }
                        }
                    }
                }
            }
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en-US", "pl-PL"]
            request.usesLanguageCorrection = false

            try? requestHandler.perform([request])
        }
    }
}
