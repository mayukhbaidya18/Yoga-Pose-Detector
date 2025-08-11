import UIKit
import AVFoundation
import Vision
import Combine

class PoseDetectionViewModel: ObservableObject {
    @Published var poseStatus: String = "Waiting for pose..."
    
    @Published var yogaDates: Set<Date> = [] {
        didSet {
            saveYogaDates()
        }
    }
    var targetPose: String = "vrikshasana"
    private let yogaDatesKey = "YogaDatesKey"
    init() {
        loadYogaDates()
        loadPoseDurations()
    }
    private func saveYogaDates() {
        let encoded = yogaDates.map { $0.timeIntervalSince1970 }
        UserDefaults.standard.set(encoded, forKey: yogaDatesKey)
    }
    private func loadYogaDates() {
        if let saved = UserDefaults.standard.array(forKey: yogaDatesKey) as? [Double] {
            yogaDates = Set(saved.map { Date(timeIntervalSince1970: $0) })
        }
    }
    var maxStreak: Int {
        let sortedDates = yogaDates
            .map { Calendar.current.startOfDay(for: $0) }
            .sorted()

        guard sortedDates.count > 1 else {
            return yogaDates.isEmpty ? 0 : 1
        }

        var streak = 1
        var maxStreak = 1

        for i in 1..<sortedDates.count {
            let prev = sortedDates[i - 1]
            let curr = sortedDates[i]

            if Calendar.current.date(byAdding: .day, value: 1, to: prev) == curr {
                streak += 1
                maxStreak = max(maxStreak, streak)
            } else {
                streak = 1
            }
        }

        return maxStreak
    }
    
    @Published var poseDurations: [String: TimeInterval] = [:]  // seconds per pose
    @Published var elapsedSeconds: Int = 0 // 🔄 Live counter for UI
    private var timer: Timer? // 🔁 Repeats every second to update elapsedSeconds
    private var poseStartTime: Date?
    private var currentPoseName: String?
    private let durationsKey = "PoseDurationsKey"
    
        func startPoseTimer(poseName: String) {
            currentPoseName = poseName
            poseStartTime = Date()
            elapsedSeconds = 0

            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                guard let start = self.poseStartTime else { return }
                self.elapsedSeconds = Int(Date().timeIntervalSince(start))
            }
        }

        func stopPoseTimer() {
            timer?.invalidate()
            timer = nil

            guard let start = poseStartTime, let pose = currentPoseName else { return }
            let duration = Date().timeIntervalSince(start)
            poseDurations[pose, default: 0] += duration
            savePoseDurations() // ✅ Save after update
            poseStartTime = nil
            currentPoseName = nil
        }
        private func savePoseDurations() {
            let rawDict = poseDurations.mapValues { $0 }
            UserDefaults.standard.set(rawDict, forKey: durationsKey)
        }

        private func loadPoseDurations() {
            if let saved = UserDefaults.standard.dictionary(forKey: durationsKey) as? [String: Double] {
                poseDurations = saved
            }
        }

}
class CameraViewController: UIViewController {
    var viewModel: PoseDetectionViewModel?
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    private func setupCamera() {
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .front),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("❌ Could not access front camera")
            return
        }

        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high

        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.commitConfiguration()
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                      didOutput sampleBuffer: CMSampleBuffer,
                      from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let request = VNDetectHumanBodyPoseRequest()
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                            orientation: .leftMirrored,
                                            options: [:])
        do {
            try handler.perform([request])
            guard let observation = request.results?.first else {
                print("❌ Could not find body pose")
                return
            }

            let points = try observation.recognizedPoints(.all)

            DispatchQueue.main.async {
                guard let poseName = self.viewModel?.targetPose else { return }

                switch poseName {
                case "Vrikshasana":
                    let isDetected = VrikshasanaPose.isPoseDetected(from: points)
                    self.viewModel?.poseStatus = isDetected ? "✅ Vrikshasana Detected" : "❌ Not Vrikshasana"
                    if isDetected {
                        let today = Calendar.current.startOfDay(for: Date())
                        self.viewModel?.yogaDates.insert(today)
                    }

                case "Trikonasana":
                    let isDetected = TrikonasanaPose.isPoseDetected(from: points)
                    self.viewModel?.poseStatus = isDetected ? "✅ Trikonasana Detected" : "❌ Not Trikonasana"
                    if isDetected {
                        let today = Calendar.current.startOfDay(for: Date())
                        self.viewModel?.yogaDates.insert(today)
                    }

                case "Warrior 2":
                    let isDetected = Warrior2Pose.isPoseDetected(from: points)
                    self.viewModel?.poseStatus = isDetected ? "✅ Warrior 2 Detected" : "❌ Not Warrior 2"
                    if isDetected {
                        let today = Calendar.current.startOfDay(for: Date())
                        self.viewModel?.yogaDates.insert(today)
                    }

                case "Tadasana":
                    let isDetected = TadasanaPose.isPoseDetected(from: points)
                    self.viewModel?.poseStatus = isDetected ? "✅ Tadasana Detected" : "❌ Not Tadasana"
                    if isDetected {
                        let today = Calendar.current.startOfDay(for: Date())
                        self.viewModel?.yogaDates.insert(today)
                    }

                case "Goddess pose":
                    let isDetected = GoddessPose.isPoseDetected(from: points)
                    self.viewModel?.poseStatus = isDetected ? "✅ Goddess Pose Detected" : "❌ Not Goddess Pose"
                    if isDetected {
                        let today = Calendar.current.startOfDay(for: Date())
                        self.viewModel?.yogaDates.insert(today)
                    }

                default:
                    self.viewModel?.poseStatus = "❓ Unknown Pose"
                }

            }
        } catch {
            print("❌ Vision error: \(error)")
        }
    }
}
