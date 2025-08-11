import SwiftUI
struct PoseDetectionScreen: View {
    @StateObject var viewModel: PoseDetectionViewModel

    init(poseName: String) {
        let vm = PoseDetectionViewModel()
        vm.targetPose = poseName
        _viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            CameraView()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 8) {
                // ⏱ Timer
                Text("Time: \(formattedTime(viewModel.elapsedSeconds))")
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)

                // ✅ Pose status
                Text(viewModel.poseStatus)
                    .font(.title2)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
            }
            .padding(.bottom)
        }
        .onAppear {
            viewModel.startPoseTimer(poseName: viewModel.targetPose)
        }
        .onDisappear {
            viewModel.stopPoseTimer()
        }
        .navigationTitle("Practice")
        .navigationBarTitleDisplayMode(.inline)
    }

    func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}
