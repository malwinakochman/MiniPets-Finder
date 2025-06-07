import SwiftUI
import UIKit
import Vision
import SwiftUI
import AVFoundation
import Vision

struct ContentView: View {
    @State private var detectedCode: String?
    @State private var currentFigure: LPSFigure?
    @State private var figureCount: Int = 0

    var body: some View {
        ZStack {
            LiveTextScannerView { code in
                detectedCode = code
                if let figure = lpsFigures[code] {
                    currentFigure = figure
                }
            }
            .edgesIgnoringSafeArea(.all)

            if let figure = currentFigure {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Image(figure.imageName)
                                .resizable()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 8)
                            Text(figure.name)
                                .font(.headline)
                                .padding(.top, 8)
                        }
                        .background(.ultraThinMaterial)
                        .cornerRadius(24)
                        .padding()
                    }
                }
                .transition(.move(edge: .trailing))
                .animation(.spring(), value: currentFigure)
            }

            // Dolny pasek z licznikiem
            VStack {
                Spacer()
                if let figure = currentFigure {
                    HStack(spacing: 16) {
                        Image(figure.imageName)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text(figure.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        Button(action: { if figureCount > 0 { figureCount -= 1 } }) {
                            Image(systemName: "minus")
                                .font(.title)
                                .padding(8)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                        Text("\(figureCount)")
                            .font(.title2)
                            .frame(width: 40)
                        Button(action: { figureCount += 1 }) {
                            Image(systemName: "plus")
                                .font(.title)
                                .padding(8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(radius: 8)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
        }
    }
}
