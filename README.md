# 🧘‍♀️ Yoga Pose Detector

An iOS app built with **Swift**, **SwiftUI**, **ARKit**, **AVFoundation**, and **Vision** that detects and teaches yoga poses in real time. The app guides users through yoga poses, provides AR-based tutorials, and helps maintain consistency with streak and calendar tracking.

---

## ✨ Features

- 📸 **Real-Time Pose Detection**
  - Uses Apple's **Vision** framework to analyze camera input.
  - Detects and evaluates yoga poses based on body landmarks.

- 🧍‍♀️ **Supported Poses**
  - Vrikshasana (Tree Pose)  
  - Tadasana (Mountain Pose)  
  - Trikonasana (Triangle Pose)  
  - Warrior II Pose  
  - Goddess Pose  

- 🧠 **AR Tutorials**
  - `ARViewScreen.swift` uses **ARKit** to visualize 3D `.usdz` models (e.g., `Vrikshasana.usdz`) that demonstrate correct yoga form.

- 📅 **Calendar & Streak Tracking**
  - `CalendarView.swift` and `StreakSheetView.swift` help users track daily yoga sessions and maintain streaks.

- 💬 **Learning Mode**
  - `LearnMoreScreen.swift` and `LetsExplore.swift` introduce poses and benefits.

- 🏠 **Home Dashboard**
  - `HomeView.swift` provides easy navigation across pose detection, tutorials, and streak progress.

---

## 🧩 Tech Stack

- **Swift 5**
- **SwiftUI** – Declarative user interface  
- **Vision Framework** – Detects human body poses  
- **ARKit** – Displays 3D yoga pose tutorials  
- **AVFoundation** – Handles real-time camera feed  
- **Combine** – For reactive data updates  

---

## 🏗️ Project Structure

```
YogaPoseDetector/
├── YogaPoseDetectorApp.swift      # Entry point
│
├── Views/
│   ├── HomeView.swift              # Main dashboard
│   ├── CameraView.swift            # Camera feed UI
│   ├── ARViewScreen.swift          # ARKit tutorial view
│   ├── CalendarView.swift          # Session calendar
│   ├── StreakSheetView.swift       # Streak tracker
│   ├── LearnMoreScreen.swift       # Pose information screen
│   ├── LetsExplore.swift           # Guided exploration screen
│
├── Controllers/
│   ├── CameraViewController.swift  # Handles live video input
│   ├── PoseDetection.swift         # Core Vision pose detection logic
│
├── Poses/
│   ├── VrikshasanaPose.swift
│   ├── TadasanaPose.swift
│   ├── TrikonasanaPose.swift
│   ├── Warrior2Pose.swift
│   ├── GoddessPose.swift
│
└── Assets/
    ├── Vrikshasana.usdz            # 3D model for AR tutorial
```

---

## 🚀 How It Works

1. **CameraView** uses **AVFoundation** to capture live frames.  
2. **PoseDetection.swift** processes frames using **Vision**'s `VNDetectHumanBodyPoseRequest`.  
3. The detected body joints are compared with ideal pose angles (defined in individual pose files).  
4. **Pose feedback** (Correct/Incorrect) is displayed in real time.  
5. Users can switch to **ARViewScreen** to view a 3D demonstration of the same pose.  
6. The **CalendarView** and **StreakSheetView** log each successful session, helping track progress.

---

## 📱 App Flow

```
HomeView → CameraView → PoseDetection
    ↓
ARViewScreen (Tutorial)
    ↓
CalendarView / StreakSheetView
```

---

## 🧠 Future Roadmap

- 🗣️ Add **voice guidance** during practice  
- 🧘 Add more poses (Cobra, Downward Dog, etc.)
- 📊 Track pose accuracy percentages  
- ☁️ Integrate **HealthKit** for activity syncing  
- 🎯 Add user achievements and reminders  

---

## 🛠️ Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/mayukhbaidya18/Yoga-Pose-Detector.git
   ```

2. Open the project in Xcode 15+.

3. Enable camera and motion access permissions in your project settings.

4. Connect an iPhone device (ARKit requires a real device).

5. Build and run (⌘ + R).

---

## 👨‍💻 Developer

**Mayukh Baidya**  
📍 India  
📧 4mayukh@gmail.com

---

## 🪷 License

This project is licensed under the MIT License.  
Feel free to use and modify it for learning or personal use.

---

## 🌸 Acknowledgements

- Apple's Vision and ARKit frameworks
- Yoga instructors and open 3D pose datasets used for reference
