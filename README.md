# 📷 MCast – IoT WebCam Streaming

---

## 🌟 Features

### 🔐 Security Features
- App Lock with Passcode 🔢
- Biometric Authentication (Fingerprint) 🧬
- Secret Key for Passcode Recovery 🔑

### 🎥 Video Streaming
- Real-time MJPEG stream from ESP32-CAM 📡
- Editable IP for dynamic connections 🌐

### 🎨 Customization
- Light / Dark Theme toggle 🌗
- Settings panel with editable options ⚙️

---

## ⚙️ Hardware Setup

### 🧰 Requirements

- ✅ ESP32-CAM board

### 📦 ESP32-CAM (Firmware)

1. Install [ESP-IDF](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/)
2. Clone the repo:  
   ```bash
   git clone https://github.com/mabdullahm773/MCast.git
   cd MicroCam/hardware/esp32-cam
3. Configure and Build:
    Change the SSID and PAssword according to your internet connection in esp wifi code
    ```bash
    idf.py build
    idf.py -p PORT flash
    idf.py monitor
4.  Copy the Esp IP address by monitoring it


## 📱 Flutter App Setup
1. Install Flutter: flutter.dev
2. Navigate to app folder
    ```bash
    cd MicroCam/mobile
3. Get Dependencies
    ```bash
    flutter pub get
4. Run the app:
    ```bash
    flutter run
5. 📱 App requires camera stream IP (e.g., http://192.168.x.x) in settings which is assigned to the micro controller

