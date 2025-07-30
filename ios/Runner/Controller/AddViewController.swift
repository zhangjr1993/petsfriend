import UIKit
import YPImagePicker

class AddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    private var tableView: UITableView!
    // 头像和猫狗
    private var petImageButton: UIButton!
    private var dogButton: UIButton!
    private var catButton: UIButton!
    private var saveButton: UIButton!
    // 名字、年龄、性格、相册
    private var nameField: UITextField!
    private var ageField: UITextField!
    private var descTextView: UITextView!
    private var descCountLabel: UILabel!
    private var albumCollectionView: UICollectionView!
    // 数据
    private var petType: String? // "狗" or "猫"
    private var petImage: UIImage?
    private var albumImages: [UIImage] = []
    private let maxAlbumCount = 9
    // 新增：数据变量
    private var nameText: String = ""
    private var ageText: String = ""
    private var descText: String = ""
    // 新增：footerView属性用于tableView
    private var footerView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupTopBar()
        setupTableView()
        setupSaveButton()
        updateSaveButtonState() // 初始化按钮状态
    }
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
        titleLab.text = "发布宠物相册"
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
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag
        // 新增footerView
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 92))
        footerView.backgroundColor = .clear
        tableView.tableFooterView = footerView
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44 + UIApplication.statusBarHeight),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(PetNameCell.self, forCellReuseIdentifier: "PetNameCell")
        tableView.register(PetAgeCell.self, forCellReuseIdentifier: "PetAgeCell")
        tableView.register(PetDescCell.self, forCellReuseIdentifier: "PetDescCell")
        tableView.register(PetAlbumCell.self, forCellReuseIdentifier: "PetAlbumCell")
    }
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 4 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PetNameCell", for: indexPath) as! PetNameCell
            cell.configure(text: nameText, delegate: self)
            cell.textField.addTarget(self, action: #selector(nameFieldChanged(_:)), for: .editingChanged)
            // 限制长度10
            cell.textField.addTarget(self, action: #selector(limitTextFieldLength(_:)), for: .editingChanged)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PetAgeCell", for: indexPath) as! PetAgeCell
            cell.configure(text: ageText, delegate: self)
            cell.textField.addTarget(self, action: #selector(ageFieldChanged(_:)), for: .editingChanged)
            // 限制长度10
            cell.textField.addTarget(self, action: #selector(limitTextFieldLength(_:)), for: .editingChanged)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PetDescCell", for: indexPath) as! PetDescCell
            cell.configure(text: descText, count: descText.count, delegate: self)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PetAlbumCell", for: indexPath) as! PetAlbumCell
            cell.configure(images: albumImages, maxCount: maxAlbumCount, delegate: self)
            // 新增：设置删除回调
            cell.onDeleteImage = { [weak self] index in
                self?.albumImages.remove(at: index)
                self?.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
                self?.updateSaveButtonState()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 1: return 97
        case 2: return 222
        case 3: return (UIApplication.viewWidth-80)+72
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .clear
        // 头像
        petImageButton = UIButton(type: .custom)
        petImageButton.setBackgroundImage(petImage ?? UIImage(named: "btn_edit_photo_add"), for: .normal)
        petImageButton.translatesAutoresizingMaskIntoConstraints = false
        petImageButton.layer.cornerRadius = 53
        petImageButton.layer.masksToBounds = true
        petImageButton.addTarget(self, action: #selector(petImageTapped), for: .touchUpInside)
        header.addSubview(petImageButton)
        NSLayoutConstraint.activate([
            petImageButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 32),
            petImageButton.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            petImageButton.widthAnchor.constraint(equalToConstant: 106),
            petImageButton.heightAnchor.constraint(equalToConstant: 106)
        ])
        // 猫狗按钮
        dogButton = makePetTypeButton(title: " Dog", normalImage: "icon_dog_pre", selectedImage: "icon_dog", selectedColor: "#4874F5")
        dogButton.addTarget(self, action: #selector(dogTapped), for: .touchUpInside)
        header.addSubview(dogButton)
        catButton = makePetTypeButton(title: " Cat", normalImage: "icon_cat_pre", selectedImage: "icon_cat", selectedColor: "#F3AF4B")
        catButton.addTarget(self, action: #selector(catTapped), for: .touchUpInside)
        header.addSubview(catButton)
        NSLayoutConstraint.activate([
            dogButton.topAnchor.constraint(equalTo: petImageButton.bottomAnchor, constant: 18),
            dogButton.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: -50),
            dogButton.widthAnchor.constraint(equalToConstant: 80),
            dogButton.heightAnchor.constraint(equalToConstant: 36),
            catButton.topAnchor.constraint(equalTo: petImageButton.bottomAnchor, constant: 18),
            catButton.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 50),
            catButton.widthAnchor.constraint(equalToConstant: 80),
            catButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 180 }
    // MARK: - Actions
    @objc private func petImageTapped() {
        var config = YPImagePickerConfiguration()
        config.screens = [.photo, .library]
        config.library.maxNumberOfItems = 1
        config.library.mediaType = .photo
        config.library.onlySquare = true
        config.showsPhotoFilters = false
        config.startOnScreen = .library
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [weak self] items, _ in
            for item in items {
                switch item {
                case .photo(let photo):
                    self?.petImage = photo.image
                    self?.petImageButton.setBackgroundImage(photo.image, for: .normal)
                default: break
                }
            }
            self?.updateSaveButtonState()
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true)
    }
    @objc private func dogTapped() {
        petType = petType == "狗" ? nil : "狗"
        dogButton.isSelected = petType == "狗"
        catButton.isSelected = false
        updateSaveButtonState()
    }
    @objc private func catTapped() {
        petType = petType == "猫" ? nil : "猫"
        catButton.isSelected = petType == "猫"
        dogButton.isSelected = false
        updateSaveButtonState()
    }
    // MARK: - 数据联动
    @objc private func nameFieldChanged(_ sender: UITextField) {
        nameText = sender.text ?? ""
        updateSaveButtonState()
    }
    @objc private func ageFieldChanged(_ sender: UITextField) {
        ageText = sender.text ?? ""
        updateSaveButtonState()
    }
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        descText = textView.text ?? ""
        updateSaveButtonState()
        // 让 cell 自己刷新 placeholder 和 countLabel
        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? PetDescCell {
            cell.updatePlaceholderAndCount()
        }
    }
    // MARK: - 图片选择
    func presentImagePickerForAlbum() {
        var config = YPImagePickerConfiguration()
        config.screens = [.photo, .library]
        config.library.maxNumberOfItems = maxAlbumCount - albumImages.count
        config.library.mediaType = .photo
        config.library.defaultMultipleSelection = true
        config.showsPhotoFilters = false
        config.startOnScreen = .library
        config.library.preselectedItems
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [weak self] items, _ in
            let images = items.compactMap { item -> UIImage? in
                if case let .photo(photo) = item {
                    return photo.image
                }
                return nil
            }
            self?.albumImages.append(contentsOf: images)
            self?.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
            self?.updateSaveButtonState()
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true)
    }
    // MARK: - 工具
    private func makePetTypeButton(title: String, normalImage: String, selectedImage: String, selectedColor: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: normalImage), for: .normal)
        btn.setImage(UIImage(named: selectedImage), for: .selected)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor(hex: selectedColor), for: .selected)
        btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        btn.layer.cornerRadius = 18
        btn.layer.masksToBounds = true
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
   
    private func setupSaveButton() {
        saveButton = UIButton(type: .custom)
        saveButton.isEnabled = false
        saveButton.setTitle("保存", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = UIColor(hex: "#F3AF4B")
        saveButton.layer.cornerRadius = 26
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        // 添加测试按钮（开发阶段使用，生产环境可移除）
        #if DEBUG
        let testButton = UIButton(type: .custom)
        testButton.setTitle("测试API", for: .normal)
        testButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        testButton.setTitleColor(.white, for: .normal)
        testButton.backgroundColor = UIColor(hex: "#4874F5")
        testButton.layer.cornerRadius = 20
        testButton.translatesAutoresizingMaskIntoConstraints = false
        testButton.addTarget(self, action: #selector(testAPITapped), for: .touchUpInside)
        view.addSubview(testButton)
        #endif
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 279),
            saveButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func updateSaveButtonState() {
        // 检查所有条件
        let hasImage = petImage != nil
        let hasType = petType == "狗" || petType == "猫"
        let nameValid = !nameText.isEmpty
        let ageValid = !ageText.isEmpty
        let descValid = !descText.isEmpty
        let hasAlbum = albumImages.count > 0
        let enabled = hasImage && hasType && nameValid && ageValid && descValid && hasAlbum
        saveButton.isEnabled = enabled
        saveButton.backgroundColor = UIColor(hex: "#F3AF4B").withAlphaComponent(enabled ? 1.0 : 0.6)
    }
    
    @objc func saveTapped() {
        guard let petImage = petImage,
              let avatarData = petImage.jpegData(compressionQuality: 0.8),
              let type = petType,
              !nameText.isEmpty,
              !ageText.isEmpty,
              !descText.isEmpty,
              albumImages.count > 0 else { return }

        // 显示HUD
        let hud = HUDView()
        hud.show(in: view)
        hud.updateMessage("内容审核中...")
        
        // 调用智普AI进行内容审核
        ZhipuAIService.shared.checkContent(name: nameText, age: ageText, description: descText) { [weak self] isPassed, errorMessage in
            DispatchQueue.main.async {
                hud.hide()
                
                if isPassed {
                    // 审核通过，继续保存流程
                    self?.savePetData(avatarData: avatarData, type: type)
                } else {
                    // 审核不通过，显示错误提示
                    let alert = UIAlertController(title: "内容审核未通过", message: errorMessage ?? "内容包含不当信息", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    private func savePetData(avatarData: Data, type: String) {
        let albumDatas = albumImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
        let newPet = PetProfile(
            name: nameText,
            type: type,
            age: ageText,
            desc: descText,
            avatarData: avatarData,
            albumDatas: albumDatas
        )

        // 取出已存的宠物数组
        var pets: [PetProfile] = []
        if let data = UserDefaults.standard.data(forKey: "pet_profiles"),
           let arr = try? JSONDecoder().decode([PetProfile].self, from: data) {
            pets = arr
        }
        pets.insert(newPet, at: 0) // 新增数据插入最前
        if let data = try? JSONEncoder().encode(pets) {
            UserDefaults.standard.set(data, forKey: "pet_profiles")
        }

        // 清空内容
        petImageButton.setBackgroundImage(UIImage(named: "btn_edit_photo_add"), for: .normal)
        petType = nil
        nameText = ""
        ageText = ""
        descText = ""
        albumImages = []
        tableView.reloadData()
        updateSaveButtonState()
        
        // 弹出成功toast
        let alert = UIAlertController(title: nil, message: "保存成功", preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    // 限制输入框长度10
    @objc private func limitTextFieldLength(_ sender: UITextField) {
        if let text = sender.text, text.count > 10 {
            sender.text = String(text.prefix(10))
        }
    }
   
}

// MARK: - PetNameCell
class PetNameCell: UITableViewCell {
    let titleLabel = UILabel()
    let bgView = UIView()
    let textField = UITextField()
    weak var delegate: UITextFieldDelegate? {
        didSet { textField.delegate = delegate }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        titleLabel.text = "名字"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
        ])
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 14
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.06
        bgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bgView.layer.shadowRadius = 8
        bgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            bgView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            bgView.heightAnchor.constraint(equalToConstant: 45),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        textField.placeholder = "添加宠物名字"
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = UIColor(hex: "#111111")
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -12),
            textField.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: bgView.heightAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func configure(text: String, delegate: UITextFieldDelegate?) {
        textField.text = text
        self.delegate = delegate
    }
}
// MARK: - PetAgeCell
class PetAgeCell: UITableViewCell {
    let titleLabel = UILabel()
    let bgView = UIView()
    let textField = UITextField()
    weak var delegate: UITextFieldDelegate? {
        didSet { textField.delegate = delegate }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        titleLabel.text = "年龄"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 14
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.06
        bgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bgView.layer.shadowRadius = 8
        bgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            bgView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            bgView.heightAnchor.constraint(equalToConstant: 45),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        textField.placeholder = "添加宠物年龄"
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = UIColor(hex: "#111111")
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -12),
            textField.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: bgView.heightAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func configure(text: String, delegate: UITextFieldDelegate?) {
        textField.text = text
        self.delegate = delegate
    }
}
// MARK: - PetDescCell
class PetDescCell: UITableViewCell, UITextViewDelegate {
    let titleLabel = UILabel()
    let bgView = UIView()
    let textView = UITextView()
    let placeholderLabel = UILabel()
    let countLabel = UILabel()
    weak var delegate: UITextViewDelegate? {
        didSet { textView.delegate = delegate }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        titleLabel.text = "分享性格"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 14
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.06
        bgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bgView.layer.shadowRadius = 8
        bgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            bgView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            bgView.heightAnchor.constraint(equalToConstant: 170),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = UIColor(hex: "#111111")
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -12),
            textView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 8),
            textView.heightAnchor.constraint(equalToConstant: 120)
        ])
        placeholderLabel.text = "分享宠物的性格和喜好吧"
        placeholderLabel.font = .systemFont(ofSize: 15)
        placeholderLabel.textColor = UIColor(hex: "#999999")
        placeholderLabel.isUserInteractionEnabled = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 4),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 6)
        ])
        countLabel.font = .systemFont(ofSize: 13)
        countLabel.textColor = UIColor(hex: "#999999")
        countLabel.text = "0/1000"
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(countLabel)
        NSLayoutConstraint.activate([
            countLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -12),
            countLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -8)
        ])
        textView.delegate = self
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func configure(text: String, count: Int, delegate: UITextViewDelegate?) {
        textView.text = text
        self.delegate = delegate
        updatePlaceholderAndCount()
    }
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderAndCount()
        delegate?.textViewDidChange?(textView)
    }
    // 新增：单独方法，供外部和内部调用
    func updatePlaceholderAndCount() {
        let text = textView.text ?? ""
        countLabel.text = "\(text.count)/1000"
        placeholderLabel.isHidden = !text.isEmpty
    }
}
// MARK: - PetAlbumCell
class PetAlbumCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    let titleLabel = UILabel()
    var collectionView: UICollectionView!
    var images: [UIImage] = []
    var maxCount: Int = 9
    weak var parent: AddViewController?
    // 新增：删除图片回调
    var onDeleteImage: ((Int) -> Void)?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        titleLabel.text = "创建相册(最多9张)"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIApplication.viewWidth-84)/3, height: (UIApplication.viewWidth-84)/3)
        layout.minimumLineSpacing = 9.9999
        layout.minimumInteritemSpacing = 9.9999
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PetAlbumImageCell.self, forCellWithReuseIdentifier: "PetAlbumImageCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalToConstant: (UIApplication.viewWidth-80)+20),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func configure(images: [UIImage], maxCount: Int, delegate: AddViewController) {
        self.images = images
        self.maxCount = maxCount
        self.parent = delegate
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count < maxCount ? images.count + 1 : maxCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetAlbumImageCell", for: indexPath) as! PetAlbumImageCell
        if indexPath.item == 0 && images.count < maxCount {
            cell.configureAdd()
        } else {
            let img = images[images.count < maxCount ? indexPath.item - 1 : indexPath.item]
            cell.configureImage(img)
            // 新增：显示删除按钮
            cell.showDeleteButton = true
            cell.onDelete = { [weak self] in
                guard let self = self else { return }
                let imgIndex = self.images.count < self.maxCount ? indexPath.item - 1 : indexPath.item
                self.onDeleteImage?(imgIndex)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 && images.count < maxCount {
            parent?.presentImagePickerForAlbum()
        } else {
            // 可实现图片预览或删除
        }
    }
}
class PetAlbumImageCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let addIcon = UIImageView()
    // 新增：删除按钮
    private let deleteButton = UIButton(type: .custom)
    // 新增：回调
    var onDelete: (() -> Void)?
    // 新增：控制删除按钮显示
    var showDeleteButton: Bool = false {
        didSet { deleteButton.isHidden = !showDeleteButton }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addIcon.image = UIImage(named: "btn_photo_add")
        addIcon.contentMode = .center
        addIcon.translatesAutoresizingMaskIntoConstraints = false
        // 新增：删除按钮
        deleteButton.setImage(UIImage(named: "btn_album_delete"), for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.isHidden = true
        contentView.addSubview(imageView)
        contentView.addSubview(addIcon)
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            addIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addIcon.widthAnchor.constraint(equalToConstant: 32),
            addIcon.heightAnchor.constraint(equalToConstant: 32),
            // 删除按钮右上角
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func configureAdd() {
        imageView.isHidden = true
        addIcon.isHidden = false
        showDeleteButton = false
    }
    func configureImage(_ img: UIImage) {
        imageView.image = img
        imageView.isHidden = false
        addIcon.isHidden = true
        showDeleteButton = true
    }
    @objc private func deleteTapped() {
        onDelete?()
    }
}




