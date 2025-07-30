import UIKit
import Photos
import AVFoundation

class EditProfileViewController: UIViewController {
    
    // MARK: - UI Components
    private var avatarImageView: UIImageView!
    private var nicknameTextField: UITextField!
    private var saveButton: UIButton!
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    
    // MARK: - Properties
    private var selectedImage: UIImage?
    private var originalUserInfo: UserManager.UserInfo
    
    // MARK: - Lifecycle
    init() {
        self.originalUserInfo = UserManager.shared.userInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupNavigationBar()
        setupUI()
        configureWithUserInfo()
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
        
        title = "编辑资料"
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(backTapped))
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 8
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 头像区域
        let avatarContainer = UIView()
        avatarContainer.backgroundColor = UIColor(hex: "#F8F9FA")
        avatarContainer.layer.cornerRadius = 12
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarContainer)
        
        avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 40
        avatarImageView.backgroundColor = UIColor(hex: "#E9ECEF")
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.addSubview(avatarImageView)
        
        let avatarLabel = UILabel()
        avatarLabel.text = "点击更换头像"
        avatarLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        avatarLabel.textColor = UIColor(hex: "#6C757D")
        avatarLabel.textAlignment = .center
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.addSubview(avatarLabel)
        
        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarContainer.addGestureRecognizer(avatarTapGesture)
        
        // 昵称区域
        let nicknameContainer = UIView()
        nicknameContainer.backgroundColor = UIColor(hex: "#F8F9FA")
        nicknameContainer.layer.cornerRadius = 12
        nicknameContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nicknameContainer)
        
        let nicknameLabel = UILabel()
        nicknameLabel.text = "昵称"
        nicknameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nicknameLabel.textColor = UIColor(hex: "#111111")
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameContainer.addSubview(nicknameLabel)
        
        nicknameTextField = UITextField()
        nicknameTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        nicknameTextField.textColor = UIColor(hex: "#111111")
        nicknameTextField.placeholder = "请输入昵称"
        nicknameTextField.borderStyle = .none
        nicknameTextField.backgroundColor = .clear
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        nicknameContainer.addSubview(nicknameTextField)
        
        // 保存按钮
        saveButton = UIButton(type: .system)
        saveButton.setTitle("保存", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        saveButton.backgroundColor = UIColor(hex: "#007AFF")
        saveButton.layer.cornerRadius = 12
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        contentView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            avatarContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            avatarContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            avatarContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            avatarContainer.heightAnchor.constraint(equalToConstant: 120),
            
            avatarImageView.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: avatarContainer.topAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatarLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            
            nicknameContainer.topAnchor.constraint(equalTo: avatarContainer.bottomAnchor, constant: 20),
            nicknameContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nicknameContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nicknameContainer.heightAnchor.constraint(equalToConstant: 60),
            
            nicknameLabel.leadingAnchor.constraint(equalTo: nicknameContainer.leadingAnchor, constant: 15),
            nicknameLabel.centerYAnchor.constraint(equalTo: nicknameContainer.centerYAnchor),
            nicknameLabel.widthAnchor.constraint(equalToConstant: 60),
            
            nicknameTextField.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 15),
            nicknameTextField.trailingAnchor.constraint(equalTo: nicknameContainer.trailingAnchor, constant: -15),
            nicknameTextField.centerYAnchor.constraint(equalTo: nicknameContainer.centerYAnchor),
            
            saveButton.topAnchor.constraint(equalTo: nicknameContainer.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureWithUserInfo() {
        let userInfo = UserManager.shared.userInfo
        
        // 设置头像
        if let image = UIImage(named: userInfo.avatar) {
            avatarImageView.image = image
        } else {
            avatarImageView.image = UIImage(named: "icon_head")
        }
        
        // 设置昵称
        nicknameTextField.text = userInfo.nickname
    }
    
    // MARK: - Actions
    @objc private func avatarTapped() {
        let alert = UIAlertController(title: "选择头像", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "从相册选择", style: .default) { _ in
            self.requestPhotoLibraryAccess()
        })
        
        alert.addAction(UIAlertAction(title: "拍照", style: .default) { _ in
            self.requestCameraAccess()
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard let nickname = nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !nickname.isEmpty else {
            showAlert(title: "提示", message: "请输入昵称")
            return
        }
        
        // 保存用户信息
        UserManager.shared.updateUserInfo(
            avatar: selectedImage != nil ? "custom_avatar" : originalUserInfo.avatar,
            nickname: nickname
        )
        
        // 如果有自定义头像，保存到本地
        if let selectedImage = selectedImage {
            saveCustomAvatar(selectedImage)
        }
        
        showAlert(title: "成功", message: "资料保存成功") { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Photo Methods
    private func requestPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            presentImagePicker(sourceType: .photoLibrary)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if #available(iOS 14, *) {
                        if status == .authorized || status == .limited {
                            self?.presentImagePicker(sourceType: .photoLibrary)
                        } else {
                            self?.showAlert(title: "提示", message: "需要相册权限才能选择头像")
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        case .denied, .restricted:
            showAlert(title: "提示", message: "请在设置中允许访问相册")
        @unknown default:
            break
        }
    }
    
    private func requestCameraAccess() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            presentImagePicker(sourceType: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.presentImagePicker(sourceType: .camera)
                    } else {
                        self?.showAlert(title: "提示", message: "需要相机权限才能拍照")
                    }
                }
            }
        case .denied, .restricted:
            showAlert(title: "提示", message: "请在设置中允许访问相机")
        @unknown default:
            break
        }
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    private func saveCustomAvatar(_ image: UIImage) {
        // 这里可以保存自定义头像到本地文件系统
        // 简化处理，实际项目中可能需要更复杂的文件管理
        print("保存自定义头像")
    }
    
    private func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: completion))
        present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            avatarImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            avatarImageView.image = originalImage
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
} 
