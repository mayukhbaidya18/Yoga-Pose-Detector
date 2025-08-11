import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // Configure AR session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        arView.session.run(config)

        // Try to place model continuously until surface is found
        context.coordinator.tryPlacingModel(on: arView)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var hasPlacedModel = false

        func tryPlacingModel(on arView: ARView) {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                guard !self.hasPlacedModel else {
                    timer.invalidate()
                    return
                }

                guard let raycastResult = arView.raycast(from: arView.center, allowing: .estimatedPlane, alignment: .horizontal).first else {
                    print("⏳ Waiting for surface...")
                    return
                }

                // Surface found — place the model
                let modelEntity = try! Entity.loadModel(named: "Vrikshasana") // or "Vrikshasana"
                modelEntity.setScale(SIMD3<Float>(0.5, 0.5, 0.5), relativeTo: modelEntity)

                let anchor = AnchorEntity(world: raycastResult.worldTransform)
                anchor.addChild(modelEntity)
                arView.scene.addAnchor(anchor)

                print("✅ Model placed and anchored to floor")
                self.hasPlacedModel = true
                timer.invalidate()
            }
        }
    }
}



struct ARViewScreen: View {
    var body: some View {
        ARViewContainer()
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("Tutorial")
    }
}
