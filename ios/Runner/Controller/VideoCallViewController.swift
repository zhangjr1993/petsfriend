import UIKit
import AVFoundation
import Toast_Swift

class VideoCallViewController: UIViewController {
    private let petData: PetsCodable
    private let bgImageView = UIImageView()
    private let localPreview = UIView()
    private let connectingLabel = UILabel()
    private let switchCameraBtn = UIButton(type: .custom)
    private let closeCameraBtn = UIButton(type: .custom)
    private let hangupBtn = UIButton(type: .custom)
    private var cameraSession: AVCaptureSession?
    private var videoLayer: AVCaptureVideoPreviewLayer?
    private var isFrontCamera = true
    private var isCameraOn = true
    private var debounce = false
    private var timer: Timer?
    private var connectAnimIndex = 0
    private let connectAnimTexts = ["正在接通中.", "正在接通中..", "正在接通中…"]
    private var callStartTime: Date?
    private var audioPlayer: AVAudioPlayer?

    init(petData: PetsCodable) {
        self.petData = petData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startCamera()
        startConnectAnim()
        startTimeoutTimer()
        playRingtone()
        navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCamera()
        timer?.invalidate()
        stopRingtone()
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 修复摄像头采集画面黑屏问题
        DispatchQueue.main.async {
            self.videoLayer?.frame = self.localPreview.bounds
        }
    }
    private func setupUI() {
        // 1. 背景图
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
        bgImageView.setAppImg(petData.petPic)
        bgImageView.frame = view.bounds
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bgImageView)
        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        // 2. 本地预览画面
        localPreview.backgroundColor = .black
        localPreview.layer.cornerRadius = 12
        localPreview.clipsToBounds = true
        localPreview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(localPreview)
        NSLayoutConstraint.activate([
            localPreview.widthAnchor.constraint(equalToConstant: 120),
            localPreview.heightAnchor.constraint(equalToConstant: 160),
            localPreview.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            localPreview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        // 3. 动态文字
        connectingLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        connectingLabel.textColor = .white
        connectingLabel.textAlignment = .center
        connectingLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        connectingLabel.layer.cornerRadius = 12
        connectingLabel.layer.masksToBounds = true
        connectingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectingLabel)
        NSLayoutConstraint.activate([
            connectingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            connectingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            connectingLabel.heightAnchor.constraint(equalToConstant: 36),
            connectingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
        // 4. 摄像头切换按钮
        switchCameraBtn.setBackgroundImage(UIImage(named: "icon_camera_nor"), for: .normal)
        switchCameraBtn.translatesAutoresizingMaskIntoConstraints = false
        switchCameraBtn.addTarget(self, action: #selector(switchCameraTapped), for: .touchUpInside)
        view.addSubview(switchCameraBtn)
        NSLayoutConstraint.activate([
            switchCameraBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60),
            switchCameraBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -140),
            switchCameraBtn.widthAnchor.constraint(equalToConstant: 60),
            switchCameraBtn.heightAnchor.constraint(equalToConstant: 60)
        ])
        // 5. 摄像头关闭按钮
        closeCameraBtn.setBackgroundImage(UIImage(named: "icon_video_off"), for: .normal)
        closeCameraBtn.translatesAutoresizingMaskIntoConstraints = false
        closeCameraBtn.addTarget(self, action: #selector(closeCameraTapped), for: .touchUpInside)
        view.addSubview(closeCameraBtn)
        NSLayoutConstraint.activate([
            closeCameraBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            closeCameraBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -140),
            closeCameraBtn.widthAnchor.constraint(equalToConstant: 60),
            closeCameraBtn.heightAnchor.constraint(equalToConstant: 60)
        ])
        // 6. 挂断按钮
        hangupBtn.setImage(UIImage(named: "icon_hangup_nor"), for: .normal)
        hangupBtn.translatesAutoresizingMaskIntoConstraints = false
        hangupBtn.addTarget(self, action: #selector(hangupTapped), for: .touchUpInside)
        view.addSubview(hangupBtn)
        NSLayoutConstraint.activate([
            hangupBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hangupBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            hangupBtn.widthAnchor.constraint(equalToConstant: 72),
            hangupBtn.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    // MARK: - 摄像头采集
    private func startCamera() {
        guard isCameraOn else { localPreview.backgroundColor = .black; return }
        let session = AVCaptureSession()
        session.sessionPreset = .medium
        guard let device = cameraDevice(isFront: isFrontCamera),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        if session.canAddInput(input) { session.addInput(input) }
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        DispatchQueue.main.async {
            previewLayer.frame = self.localPreview.bounds
            self.localPreview.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            self.localPreview.layer.addSublayer(previewLayer)
            self.videoLayer = previewLayer
        }
        cameraSession = session
        DispatchQueue.global().async { session.startRunning() }
    }
    private func stopCamera() {
        cameraSession?.stopRunning()
        cameraSession = nil
        videoLayer?.removeFromSuperlayer()
    }
    private func cameraDevice(isFront: Bool) -> AVCaptureDevice? {
        let pos: AVCaptureDevice.Position = isFront ? .front : .back
        return AVCaptureDevice.devices(for: .video).first { $0.position == pos }
    }
    // MARK: - 动态文字动画
    private func startConnectAnim() {
        connectAnimIndex = 0
        connectingLabel.text = connectAnimTexts[connectAnimIndex]
        timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.connectAnimIndex = (self.connectAnimIndex + 1) % self.connectAnimTexts.count
            self.connectingLabel.text = self.connectAnimTexts[self.connectAnimIndex]
        }
    }
    // MARK: - 60s超时
    private func startTimeoutTimer() {
        callStartTime = Date()
        Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.stopRingtone()
            self.saveMissedCallMessage()
            // 先关闭页面，关闭后在主窗口window上toast
            self.dismiss(animated: true) {
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    window.makeToast("对方不在线，请稍后再拨")
                }
            }
        }
    }
    // MARK: - 铃声播放
    private func playRingtone() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            if let url = Bundle.main.url(forResource: "callingVoip", withExtension: "mp3", subdirectory: "Runner/Resource") ?? Bundle.main.url(forResource: "callingVoip", withExtension: "mp3") {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.play()
            }
        } catch {
            print("铃声播放失败", error)
        }
    }
    private func stopRingtone() {
        audioPlayer?.stop()
        audioPlayer = nil
        try? AVAudioSession.sharedInstance().setActive(false)
    }
    @objc private func appDidEnterBackground() {
        // 保持铃声播放
        audioPlayer?.play()
    }
    @objc private func appWillEnterForeground() {
        // 保持铃声播放
        audioPlayer?.play()
    }
    // MARK: - 按钮事件
    @objc private func switchCameraTapped() {
        guard !debounce else { return }
        debounce = true
        isFrontCamera.toggle()
        stopCamera()
        startCamera()
        self.view.makeToast("切换成功")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { self.debounce = false }
    }
    @objc private func closeCameraTapped() {
        isCameraOn.toggle()
        if isCameraOn {
            startCamera()
        } else {
            stopCamera()
            localPreview.backgroundColor = .black
        }
    }
    @objc private func hangupTapped() {
        stopCamera()
        stopRingtone()
        saveMissedCallMessage()
        dismiss(animated: true)
    }
    // MARK: - 消息记录
    private func saveMissedCallMessage() {
        // 生成一条消息记录[通话 未接听]
        let chatId = "\(petData.id)"
        let rec = ChatMessageRecord(
            msgId: UUID().uuidString,
            chatId: chatId,
            isMe: true,
            type: "text",
            content: "[通话 未接听]",
            timestamp: Int64(Date().timeIntervalSince1970)
        )
        ChatMessageDBManager.shared.insertMessage(rec)
    }
    // MARK: - Toast
    private func showToast(_ text: String) {
        self.view.makeToast(text)
    }
} 
