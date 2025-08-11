import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @EnvironmentObject var viewModel: PoseDetectionViewModel

    func makeUIViewController(context: Context) -> CameraViewController {
        let vc = CameraViewController()
        vc.viewModel = viewModel // ✅ Inject the view model
        return vc
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // No-op
    }
}
