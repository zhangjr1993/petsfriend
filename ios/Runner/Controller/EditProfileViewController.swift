import UIKit
import Photos
import AVFoundation
// UserProfile相关内容已移至UserProfile+Cache.swift

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    private var avatarImageView: UIImageView!
    private var addPhotoButton: UIButton!
    private var nameTextField: UITextField!
    private var saveButton: UIButton!
    private var avatarImage: UIImage?
    private var nickname: String = ""
    private var canSave: Bool { avatarImage != nil && !(nameTextField.text?.isEmpty ?? true) }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTopBar()
        setupAvatarSection()
        setupNameSection()
        setupSaveButton()
        updateSaveButtonState()
    }

    private func setupTopBar() {
        let topBar = UIView()
        topBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBar)
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 44 + UIApplication.statusBarHeight)
        ])
        // 返回按钮
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "back_black"), for: .normal)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        topBar.addSubview(backBtn)
        NSLayoutConstraint.activate([
            backBtn.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 8),
            backBtn.topAnchor.constraint(equalTo: topBar.topAnchor, constant: UIApplication.statusBarHeight + 6),
            backBtn.widthAnchor.constraint(equalToConstant: 32),
            backBtn.heightAnchor.constraint(equalToConstant: 32)
        ])
        // 标题
        let titleLab = UILabel()
        titleLab.text = "编辑"
        titleLab.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLab.textColor = UIColor(hex: "#111111")
        titleLab.textAlignment = .center
        titleLab.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(titleLab)
        NSLayoutConstraint.activate([
            titleLab.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            titleLab.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor)
        ])
    }

    private func setupAvatarSection() {
        let avatarTitle = UILabel()
        avatarTitle.text = "头像"
        avatarTitle.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        avatarTitle.textColor = UIColor(hex: "#111111")
        avatarTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarTitle)
        NSLayoutConstraint.activate([
            avatarTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            avatarTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 44 + UIApplication.statusBarHeight + 32)
        ])
        avatarImageView = UIImageView()
        avatarImageView.backgroundColor = UIColor.systemGray5
        avatarImageView.layer.cornerRadius = 12
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: avatarTitle.topAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 98),
            avatarImageView.heightAnchor.constraint(equalToConstant: 98)
        ])
        addPhotoButton = UIButton(type: .custom)
        addPhotoButton.setBackgroundImage(UIImage(named: "btn_edit_photo"), for: .normal)
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        view.addSubview(addPhotoButton)
        NSLayoutConstraint.activate([
            addPhotoButton.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            addPhotoButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 98),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 98)
        ])
    }

    private func setupNameSection() {
        let nameTitle = UILabel()
        nameTitle.text = "昵称"
        nameTitle.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        nameTitle.textColor = UIColor(hex: "#111111")
        nameTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTitle)
        NSLayoutConstraint.activate([
            nameTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameTitle.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 32)
        ])
        let nameBg = UIView()
        nameBg.backgroundColor = UIColor(hex: "#F5F5F5")
        nameBg.layer.cornerRadius = 8
        nameBg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameBg)
        NSLayoutConstraint.activate([
            nameBg.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameBg.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            nameBg.topAnchor.constraint(equalTo: nameTitle.bottomAnchor, constant: 8),
            nameBg.heightAnchor.constraint(equalToConstant: 48)
        ])
        nameTextField = UITextField()
        nameTextField.placeholder = "请输入"
        nameTextField.font = UIFont.systemFont(ofSize: 15)
        nameTextField.textColor = UIColor(hex: "#111111")
        nameTextField.delegate = self
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.returnKeyType = .done
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        nameBg.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: nameBg.leadingAnchor, constant: 12),
            nameTextField.trailingAnchor.constraint(equalTo: nameBg.trailingAnchor, constant: -48),
            nameTextField.centerYAnchor.constraint(equalTo: nameBg.centerYAnchor),
            nameTextField.heightAnchor.constraint(equalTo: nameBg.heightAnchor)
        ])
        let countLabel = UILabel()
        countLabel.text = "0/10"
        countLabel.font = UIFont.systemFont(ofSize: 13)
        countLabel.textColor = UIColor(hex: "#999999")
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        nameBg.addSubview(countLabel)
        NSLayoutConstraint.activate([
            countLabel.trailingAnchor.constraint(equalTo: nameBg.trailingAnchor, constant: -12),
            countLabel.centerYAnchor.constraint(equalTo: nameBg.centerYAnchor)
        ])
        // 限制10字
        func updateCount() {
            let count = nameTextField.text?.count ?? 0
            countLabel.text = "\(count)/10"
        }
        updateCount()
        // iOS13兼容：用addTarget和textFieldChanged里直接调用updateCount
        self.updateCount = updateCount
    }

    private var updateCount: (() -> Void)?

    private func setupSaveButton() {
        saveButton = UIButton(type: .custom)
        saveButton.setTitle("保存", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = UIColor(hex: "#F3AF4B")
        saveButton.layer.cornerRadius = 26
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 279),
            saveButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func updateSaveButtonState() {
        let enabled = canSave
        saveButton.isEnabled = enabled
        saveButton.alpha = enabled ? 1.0 : 0.6
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func addPhotoTapped() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "拍照", style: .default) { _ in self.checkCamera() })
        sheet.addAction(UIAlertAction(title: "相册选择", style: .default) { _ in self.checkPhotoLibrary() })
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(sheet, animated: true)
    }

    private func checkCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted { self.openCamera() } else { self.showCameraDeniedAlert() }
                }
            }
        default:
            showCameraDeniedAlert()
        }
    }
    private func showCameraDeniedAlert() {
        let alert = UIAlertController(title: "无法访问相机", message: "请在设置中打开相机权限", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    private func checkPhotoLibrary() {
        if #available(iOS 14, *) {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            switch status {
            case .authorized, .limited:
                openPhotoLibrary()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    DispatchQueue.main.async {
                        if status == .authorized || status == .limited {
                            self.openPhotoLibrary()
                        } else {
                            self.showPhotoDeniedAlert()
                        }
                    }
                }
            default:
                showPhotoDeniedAlert()
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                openPhotoLibrary()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    DispatchQueue.main.async {
                        if status == .authorized {
                            self.openPhotoLibrary()
                        } else {
                            self.showPhotoDeniedAlert()
                        }
                    }
                }
            default:
                showPhotoDeniedAlert()
            }
        }
    }
    private func showPhotoDeniedAlert() {
        let alert = UIAlertController(title: "无法访问相册", message: "请在设置中打开相册权限", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }
    private func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let img = info[.originalImage] as? UIImage {
            avatarImage = img
            avatarImageView.image = img
            addPhotoButton.isHidden = true
            updateSaveButtonState()
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    // MARK: - UITextFieldDelegate
    @objc private func textFieldChanged() {
        // 只在没有高亮（联想/拼音未上屏）时做截断
        if let textField = nameTextField,
           let text = textField.text,
           let markedRange = textField.markedTextRange,
           let _ = textField.position(from: markedRange.start, offset: 0) {
            // 有高亮，不截断
            updateCount?()
            updateSaveButtonState()
            return
        }
        if let text = nameTextField.text, text.count > 10 {
            nameTextField.text = String(text.prefix(10))
        }
        updateCount?()
        updateSaveButtonState()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // MARK: - 保存
    @objc private func saveTapped() {
        // 保存逻辑，头像和昵称都填写后才可用
        guard let img = avatarImage, let imgData = img.jpegData(compressionQuality: 0.8),
              let name = nameTextField.text, !name.isEmpty else { return }
        let profile = UserProfile(nickname: name, avatarData: imgData)
        UserDefaults.standard.userProfile = profile
        NotificationCenter.default.post(name: .userProfileDidChange, object: nil)
        navigationController?.popViewController(animated: true)
    }
} 
