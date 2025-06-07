import UIKit
import Vision

func RecognizeText(from image: UIImage, completion: @escaping (String) -> Void) {
    guard let cgImage = image.cgImage else {
        completion("")
        return
    }

    let request = VNRecognizeTextRequest { request, error in
        guard error == nil else {
            completion("")
            return
        }

        let observations = request.results as? [VNRecognizedTextObservation] ?? []
        let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
        let fullText = recognizedStrings.joined(separator: " ")
        completion(fullText)
    }

    request.recognitionLevel = .accurate
    request.recognitionLanguages = ["pl-PL", "en-US"] // dopasuj języki
    request.usesLanguageCorrection = true

    let requests = [request]
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    DispatchQueue.global(qos: .userInitiated).async {
        do {
            try handler.perform(requests)
        } catch {
            completion("")
        }
    }
}
