import UIKit

class PetHealthRecordDetailViewController: UIViewController {
    
    // MARK: - 枚举定义
    enum ViewMode {
        case detail    // 详情模式，禁用编辑
        case edit      // 编辑模式，允许编辑
        case add       // 添加模式，允许编辑
    }
    
    // MARK: - 属性
    var viewMode: ViewMode = .detail
    var healthRecord: PetHealthRecord?
    
    // MARK: - Callbacks
    var onSave: ((PetHealthRecord) -> Void)?
    
    // MARK: - UI组件
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    private var nameTextField: UITextField!
    private var typeTextField: UITextField!
    private var birthDateTextField: UITextField!
    private var ageTextField: UITextField!
    private var weightTextField: UITextField!
    private var vaccinationsTextView: UITextView!
    private var allergiesTextView: UITextView!
    private var notesTextView: UITextView!
    private var saveButton: UIButton!
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupNavigationBar()
        setupUI()
        configureContent()
        
        print("ContentView子视图数量: \(stackView.arrangedSubviews.count)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = stackView.frame.size
    }
    
    // MARK: - 初始化方法
    convenience init(mode: ViewMode, record: PetHealthRecord? = nil) {
        self.init()
        self.viewMode = mode
        self.healthRecord = record
    }
    
    // MARK: - 设置方法
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
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor(hex: "#111111")
        
        // 隐藏系统返回按钮，使用自定义返回按钮
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(backTapped))
        
        switch viewMode {
        case .detail:
            title = "健康档案详情"
            let editButton = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(editTapped))
            navigationItem.rightBarButtonItem = editButton
        case .edit:
            title = "编辑健康档案"
        case .add:
            title = "添加健康档案"
        }
    }
    
    private func setupUI() {
        // ScrollView
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // StackView
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // 宠物名字
        let nameContainer = createFieldContainer(title: "宠物名字", inputView: createTextField(placeholder: "请输入宠物名字", maxLength: 10))
        nameTextField = nameContainer.subviews.last as? UITextField
        
        // 宠物类型
        let typeContainer = createFieldContainer(title: "宠物类型", inputView: createTextField(placeholder: "请输入宠物类型（如：猫、狗）"))
        typeTextField = typeContainer.subviews.last as? UITextField
        
        // 宠物生日
        let birthDateContainer = createFieldContainer(title: "宠物生日", inputView: createTextField(placeholder: "请输入宠物生日"))
        birthDateTextField = birthDateContainer.subviews.last as? UITextField
        
        // 宠物年龄
        let ageContainer = createFieldContainer(title: "宠物年龄", inputView: createTextField(placeholder: "请输入宠物年龄"))
        ageTextField = ageContainer.subviews.last as? UITextField
        
        // 宠物体重
        let weightContainer = createFieldContainer(title: "宠物体重(kg)", inputView: createTextField(placeholder: "请输入宠物体重"))
        weightTextField = weightContainer.subviews.last as? UITextField
        
        // 疫苗接种记录
        let vaccinationsContainer = createFieldContainer(title: "疫苗接种记录", inputView: createTextView(placeholder: "请输入疫苗接种记录，用逗号分隔"))
        vaccinationsTextView = vaccinationsContainer.subviews.last as? UITextView
        
        // 过敏史
        let allergiesContainer = createFieldContainer(title: "过敏史", inputView: createTextView(placeholder: "请输入过敏史，用逗号分隔"))
        allergiesTextView = allergiesContainer.subviews.last as? UITextView
        
        // 备注
        let notesContainer = createFieldContainer(title: "备注", inputView: createTextView(placeholder: "请输入备注信息"))
        notesTextView = notesContainer.subviews.last as? UITextView
        
        // 保存按钮（仅在编辑和添加模式显示）
        if viewMode != .detail {
            saveButton = UIButton(type: .custom)
            saveButton.setTitle("保存", for: .normal)
            saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            saveButton.setTitleColor(.white, for: .normal)
            saveButton.backgroundColor = UIColor(hex: "#9C27B0")
            saveButton.layer.cornerRadius = 25
            saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
            saveButton.translatesAutoresizingMaskIntoConstraints = false
            
            // 设置按钮高度
            saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        // 添加到StackView
        [nameContainer, typeContainer, birthDateContainer, ageContainer, weightContainer, vaccinationsContainer, allergiesContainer, notesContainer].forEach { stackView.addArrangedSubview($0) }
        
        if let saveButton = saveButton {
            stackView.addArrangedSubview(saveButton)
        }
        
        // 设置约束
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func createFieldContainer(title: String, inputView: UIView) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)
        
        inputView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(inputView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            inputView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            inputView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            inputView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            inputView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            inputView.heightAnchor.constraint(equalToConstant: inputView is UITextView ? 100 : 44)
        ])
        
        return container
    }
    
    private func configureContent() {
        // 如果有现有记录，填充数据
        if let record = healthRecord {
            nameTextField.text = record.petName
            typeTextField.text = record.petType
            // 生日
            birthDateTextField.text = record.birthDate
           
            // 年龄
            if let age = record.age {
                ageTextField.text = age
            }
            
            // 体重
            if let weight = record.weight {
                weightTextField.text = "\(weight)"
            }
            
            // 疫苗接种记录
            if !record.vaccinations.isEmpty {
                vaccinationsTextView.text = record.vaccinations.joined(separator: "、")
            }
            
            // 过敏史
            if !record.allergies.isEmpty {
                allergiesTextView.text = record.allergies.joined(separator: "、")
            }
            
            // 备注
            notesTextView.text = record.notes
        }
        
        // 根据模式设置编辑权限
        let isEditable = viewMode != .detail
        nameTextField.isEnabled = isEditable
        typeTextField.isEnabled = isEditable
        birthDateTextField.isEnabled = isEditable
        ageTextField.isEnabled = isEditable
        weightTextField.isEnabled = isEditable
        vaccinationsTextView.isEditable = isEditable
        allergiesTextView.isEditable = isEditable
        notesTextView.isEditable = isEditable
        
        // 设置输入框样式
        if !isEditable {
            nameTextField.backgroundColor = UIColor(hex: "#F5F5F5")
            typeTextField.backgroundColor = UIColor(hex: "#F5F5F5")
            birthDateTextField.backgroundColor = UIColor(hex: "#F5F5F5")
            ageTextField.backgroundColor = UIColor(hex: "#F5F5F5")
            weightTextField.backgroundColor = UIColor(hex: "#F5F5F5")
            vaccinationsTextView.backgroundColor = UIColor(hex: "#F5F5F5")
            allergiesTextView.backgroundColor = UIColor(hex: "#F5F5F5")
            notesTextView.backgroundColor = UIColor(hex: "#F5F5F5")
        }
    }
    
    // MARK: - UI创建方法
    private func createTextField(placeholder: String, maxLength: Int? = nil) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor(hex: "#111111")
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: "#E0E0E0").cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        
        if let maxLength = maxLength {
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            textField.tag = maxLength
        }
        
        return textField
    }
    
    private func createTextView(placeholder: String) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor(hex: "#111111")
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(hex: "#E0E0E0").cgColor
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        
        // 添加占位符
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = UIColor(hex: "#999999")
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 12),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 12)
        ])
        
        placeholderLabel.tag = 1001
        textView.delegate = self
        
        return textView
    }
    
    // MARK: - 辅助方法
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // MARK: - 事件处理
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func editTapped() {
        let editVC = PetHealthRecordDetailViewController(mode: .edit, record: healthRecord)
        // 使用block回调，需要同时更新详情页面和列表页面
        editVC.onSave = { [weak self] updatedRecord in
            // 更新详情页面显示
            self?.healthRecord = updatedRecord
            self?.configureContent()
            print("详情页面数据已更新")
            
            // 同时更新列表页面的缓存
            if let listVC = self?.navigationController?.viewControllers.first(where: { $0 is PetHealthRecordViewController }) as? PetHealthRecordViewController {
                listVC.updateHealthRecord(updatedRecord)
            }
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc private func saveTapped() {
        guard let name = nameTextField.text, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let type = typeTextField.text, !type.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(title: "提示", message: "请填写宠物名字和类型")
            return
        }
        
        // 解析生日
        let birthDate = parseBirthDate()
        
        // 解析体重
        let weight = parseWeight()
        
        let record = PetHealthRecord(
            id: healthRecord?.id ?? UUID().uuidString,
            petName: name,
            petType: type,
            birthDate: birthDate,
            age: ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            weight: weight,
            vaccinations: parseVaccinations(),
            allergies: parseAllergies(),
            notes: notesTextView.text ?? ""
        )
        
        print("保存健康档案 - 模式: \(viewMode), 名称: \(name), ID: \(record.id)")
        print("onSave回调是否存在: \(onSave != nil)")
        
        // 调用block回调
        onSave?(record)
                
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let maxLength = textField.tag
        if let text = textField.text, text.count > maxLength {
            textField.text = String(text.prefix(maxLength))
        }
    }
    
    private func parseBirthDate() -> String {
        let text = birthDateTextField.text ?? ""
        return text
    }
    
    private func parseWeight() -> Double? {
        let text = weightTextField.text ?? ""
        if text.isEmpty { return nil }
        
        return Double(text)
    }
    
    private func parseVaccinations() -> [String] {
        let text = vaccinationsTextView.text ?? ""
        if text.isEmpty { return [] }
        
        return text.components(separatedBy: "、").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
    }
    
    private func parseAllergies() -> [String] {
        let text = allergiesTextView.text ?? ""
        if text.isEmpty { return [] }
        
        return text.components(separatedBy: "、").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension PetHealthRecordDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = textView.viewWithTag(1001) as? UILabel {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    }
}

 
