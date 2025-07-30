import UIKit
import AVFoundation

class PetVoicePrintViewController: UIViewController {
    
    // MARK: - UI Components
    private var tableView: UITableView!
    private var addButton: UIButton!
    
    // MARK: - Data
    private var voicePrints: [PetVoicePrint] = []
    
    // MARK: - Audio
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var isRecording = false
    private var isPlaying = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupNavigationBar()
        setupTableView()
        setupAddButton()
        loadVoicePrints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Setup Methods
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(hex: "#FFFBF4").cgColor,
            UIColor(hex: "#FCF8FF").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor(hex: "#111111")
        
        title = "声纹识别"
        
        // 隐藏系统返回按钮，使用自定义返回按钮
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(backTapped))
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VoicePrintCell.self, forCellReuseIdentifier: "VoicePrintCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
    }
    
    private func setupAddButton() {
        addButton = UIButton(type: .custom)
        addButton.setTitle("录制新声纹", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = UIColor(hex: "#FF9800")
        addButton.layer.cornerRadius = 25
        addButton.addTarget(self, action: #selector(addVoicePrintTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func loadVoicePrints() {
        // 从本地加载声纹数据
        if let data = UserDefaults.standard.data(forKey: "pet_voice_prints"),
           let prints = try? JSONDecoder().decode([PetVoicePrint].self, from: data) {
            voicePrints = prints
        }
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func addVoicePrintTapped() {
        let alert = UIAlertController(title: "录制声纹", message: "请选择宠物类型", preferredStyle: .actionSheet)
        
        for voiceType in PetVoicePrint.VoiceType.allCases {
            alert.addAction(UIAlertAction(title: voiceType.displayName, style: .default) { _ in
                self.showRecordingAlert(for: voiceType)
            })
        }
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showRecordingAlert(for voiceType: PetVoicePrint.VoiceType) {
        let alert = UIAlertController(title: "录制\(voiceType.displayName)", message: "请确保环境安静，然后点击开始录制", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "开始录制", style: .default) { _ in
            self.startRecording(voiceType: voiceType)
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }
    
    private func startRecording(voiceType: PetVoicePrint.VoiceType) {
        // 请求麦克风权限
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.setupAudioRecorder()
                    self?.showRecordingUI(voiceType: voiceType)
                } else {
                    self?.showPermissionAlert()
                }
            }
        }
    }
    
    private func setupAudioRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentsPath.appendingPathComponent("voice_print_\(Date().timeIntervalSince1970).m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
        } catch {
            print("录音设置失败: \(error)")
        }
    }
    
    private func showRecordingUI(voiceType: PetVoicePrint.VoiceType) {
        let alert = UIAlertController(title: "正在录制", message: "请让宠物发出\(voiceType.displayName)声音", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "停止录制", style: .destructive) { _ in
            self.stopRecording(voiceType: voiceType)
        })
        
        present(alert, animated: true) {
            self.audioRecorder?.record()
            self.isRecording = true
        }
    }
    
    private func stopRecording(voiceType: PetVoicePrint.VoiceType) {
        audioRecorder?.stop()
        isRecording = false
        
        // 保存声纹
        if let recorder = audioRecorder,
           let audioData = try? Data(contentsOf: recorder.url) {
            
            let voicePrint = PetVoicePrint(
                id: UUID().uuidString,
                petName: "我的宠物",
                petType: "未知",
                voiceData: audioData,
                voiceType: voiceType,
                recordedDate: Date(),
                description: "录制的\(voiceType.displayName)"
            )
            
            voicePrints.append(voicePrint)
            saveVoicePrints()
            tableView.reloadData()
            
            showSuccessAlert()
        }
    }
    
    private func saveVoicePrints() {
        if let data = try? JSONEncoder().encode(voicePrints) {
            UserDefaults.standard.set(data, forKey: "pet_voice_prints")
        }
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(title: "需要麦克风权限", message: "请在设置中允许应用访问麦克风", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "录制成功", message: "声纹已保存", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension PetVoicePrintViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voicePrints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoicePrintCell", for: indexPath) as! VoicePrintCell
        let voicePrint = voicePrints[indexPath.row]
        cell.configure(with: voicePrint)
        cell.playButton.tag = indexPath.row
        cell.playButton.addTarget(self, action: #selector(playVoicePrint(_:)), for: .touchUpInside)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PetVoicePrintViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            voicePrints.remove(at: indexPath.row)
            saveVoicePrints()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Actions
extension PetVoicePrintViewController {
    @objc private func playVoicePrint(_ sender: UIButton) {
        let voicePrint = voicePrints[sender.tag]
        
        do {
            audioPlayer = try AVAudioPlayer(data: voicePrint.voiceData)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
            
            // 更新按钮状态
            if let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? VoicePrintCell {
                cell.playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            }
        } catch {
            print("播放失败: \(error)")
        }
    }
}

// MARK: - AVAudioRecorderDelegate
extension PetVoicePrintViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("录音失败")
        }
    }
}

// MARK: - AVAudioPlayerDelegate
extension PetVoicePrintViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        
        // 恢复所有播放按钮状态
        for i in 0..<voicePrints.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? VoicePrintCell {
                cell.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
    }
}

// MARK: - VoicePrintCell
class VoicePrintCell: UITableViewCell {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    let playButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor(hex: "#666666")
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)
        
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = UIColor(hex: "#FF9800")
        playButton.backgroundColor = UIColor(hex: "#FF9800").withAlphaComponent(0.1)
        playButton.layer.cornerRadius = 20
        playButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -16),
            
            playButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            playButton.widthAnchor.constraint(equalToConstant: 40),
            playButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with voicePrint: PetVoicePrint) {
        titleLabel.text = voicePrint.description
        subtitleLabel.text = "录制时间: \(formatDate(voicePrint.recordedDate))"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
} 
