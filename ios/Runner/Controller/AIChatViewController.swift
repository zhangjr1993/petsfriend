import UIKit

class AIChatViewController: UIViewController {
    
    // MARK: - UI Components
    private var tableView: UITableView!
    private var chatInputView: UIView!
    private var textField: UITextField!
    private var sendButton: UIButton!
    private var quickQuestionsView: UIView!
    private var quickQuestionsCollectionView: UICollectionView!
    
    // MARK: - Data
    private var messages: [ChatMessage] = []
    private var quickQuestions: [AIQuickQuestion] = []
    private var isWaitingForResponse = false
    private var isFirstAIChat: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: "hasUsedAIChat")
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: "hasUsedAIChat")
        }
    }
    
    // MARK: - Chat Message
    struct ChatMessage {
        let id: String
        let content: String
        let isUser: Bool
        let timestamp: Date
        let isLoading: Bool
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupNavigationBar()
        setupTopBar()
        setupData()
        setupQuickQuestionsView()
        setupTableView()
        setupInputView()
        addWelcomeMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        titleLab.text = "AI智能问答"
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
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setupData() {
        quickQuestions = PetServiceData.shared.getAIQuickQuestions()
    }
    
    private func setupQuickQuestionsView() {
        quickQuestionsView = UIView()
        quickQuestionsView.backgroundColor = .white
        quickQuestionsView.layer.cornerRadius = 16
        quickQuestionsView.layer.shadowColor = UIColor.black.cgColor
        quickQuestionsView.layer.shadowOpacity = 0.1
        quickQuestionsView.layer.shadowOffset = CGSize(width: 0, height: 2)
        quickQuestionsView.layer.shadowRadius = 4
        quickQuestionsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(quickQuestionsView)
        
        let titleLabel = UILabel()
        titleLabel.text = "快捷问题"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        quickQuestionsView.addSubview(titleLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 40)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        quickQuestionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        quickQuestionsCollectionView.backgroundColor = .clear
        quickQuestionsCollectionView.delegate = self
        quickQuestionsCollectionView.dataSource = self
        quickQuestionsCollectionView.contentInsetAdjustmentBehavior = .never
        quickQuestionsCollectionView.register(QuickQuestionCell.self, forCellWithReuseIdentifier: "QuickQuestionCell")
        quickQuestionsCollectionView.showsHorizontalScrollIndicator = false
        quickQuestionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        quickQuestionsView.addSubview(quickQuestionsCollectionView)
        
        NSLayoutConstraint.activate([
            quickQuestionsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 54 + UIApplication.statusBarHeight),
            quickQuestionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            quickQuestionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            quickQuestionsView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: quickQuestionsView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: quickQuestionsView.leadingAnchor, constant: 16),
            
            quickQuestionsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            quickQuestionsCollectionView.leadingAnchor.constraint(equalTo: quickQuestionsView.leadingAnchor),
            quickQuestionsCollectionView.trailingAnchor.constraint(equalTo: quickQuestionsView.trailingAnchor),
            quickQuestionsCollectionView.bottomAnchor.constraint(equalTo: quickQuestionsView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserMessageCell.self, forCellReuseIdentifier: "UserMessageCell")
        tableView.register(AIMessageCell.self, forCellReuseIdentifier: "AIMessageCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: quickQuestionsView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
    }
    
    private func setupInputView() {
        chatInputView = UIView()
        chatInputView.backgroundColor = .white
        chatInputView.layer.cornerRadius = 20
        chatInputView.layer.shadowColor = UIColor.black.cgColor
        chatInputView.layer.shadowOpacity = 0.1
        chatInputView.layer.shadowOffset = CGSize(width: 0, height: 2)
        chatInputView.layer.shadowRadius = 4
        chatInputView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chatInputView)
        
        textField = UITextField()
        textField.placeholder = "输入您的问题..."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        chatInputView.addSubview(textField)
        
        sendButton = UIButton(type: .custom)
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = UIColor(hex: "#4874F5")
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        chatInputView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            chatInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chatInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chatInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            chatInputView.heightAnchor.constraint(equalToConstant: 50),
            
            textField.leadingAnchor.constraint(equalTo: chatInputView.leadingAnchor, constant: 16),
            textField.centerYAnchor.constraint(equalTo: chatInputView.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            
            sendButton.trailingAnchor.constraint(equalTo: chatInputView.trailingAnchor, constant: -12),
            sendButton.centerYAnchor.constraint(equalTo: chatInputView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func addWelcomeMessage() {
        let welcomeMessage = ChatMessage(
            id: UUID().uuidString,
            content: "您好！我是您的宠物健康顾问，可以为您解答关于宠物饲养、健康、训练等方面的问题。请问有什么可以帮助您的吗？",
            isUser: false,
            timestamp: Date(),
            isLoading: false
        )
        messages.append(welcomeMessage)
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func sendTapped() {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
        
        // 检查是否是第一次AI聊天
        if isFirstAIChat {
            isFirstAIChat = false // 这会自动保存到UserDefaults
            proceedWithAIChat(text: text)
        } else {
            // 非第一次AI聊天，检查用户状态
            let userInfo = UserManager.shared.userInfo
            if userInfo.isVip {
                // 会员用户免费使用
                proceedWithAIChat(text: text)
            } else if userInfo.diamondBalance >= 5 {
                // 非会员用户需要消耗钻石
                showDiamondConsumptionAlert { [weak self] in
                    self?.proceedWithAIChat(text: text)
                }
            } else {
                showInsufficientDiamondsAlert()
            }
        }
    }
    
    private func proceedWithAIChat(text: String) {
        // 添加用户消息
        let userMessage = ChatMessage(
            id: UUID().uuidString,
            content: text,
            isUser: true,
            timestamp: Date(),
            isLoading: false
        )
        messages.append(userMessage)
        
        // 添加AI加载消息
        let loadingMessage = ChatMessage(
            id: UUID().uuidString,
            content: "",
            isUser: false,
            timestamp: Date(),
            isLoading: true
        )
        messages.append(loadingMessage)
        
        textField.text = ""
        tableView.reloadData()
        scrollToBottom()
        
        // 调用AI咨询接口
        isWaitingForResponse = true
        ZhipuAIService.shared.consultQuestion(question: text) { [weak self] response, error in
            DispatchQueue.main.async {
                self?.isWaitingForResponse = false
                
                // 移除加载消息
                self?.messages.removeLast()
                
                // 添加AI回复
                let aiMessage = ChatMessage(
                    id: UUID().uuidString,
                    content: response ?? (error ?? "抱歉，我现在无法回答您的问题，请稍后再试。"),
                    isUser: false,
                    timestamp: Date(),
                    isLoading: false
                )
                self?.messages.append(aiMessage)
                self?.tableView.reloadData()
                self?.scrollToBottom()
            }
        }
    }
    
    private func showDiamondConsumptionAlert(completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "钻石消耗提醒",
            message: "AI智能问答需要消耗5钻石/条，是否继续？",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "继续", style: .default) { _ in
            // 扣除钻石
            UserManager.shared.consumeDiamonds(5)
            completion()
        })
        
        present(alert, animated: true)
    }
    
    private func showInsufficientDiamondsAlert() {
        let alert = UIAlertController(
            title: "钻石不足",
            message: "您的钻石余额不足，需要5钻石才能进行AI智能问答。是否前往充值？",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "去充值", style: .default) { [weak self] _ in
            self?.showRechargeOptions()
        })
        
        present(alert, animated: true)
    }
    
    private func showRechargeOptions() {
        let vc = VIPCenterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func scrollToBottom() {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension AIChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.isUser {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserMessageCell", for: indexPath) as! UserMessageCell
            cell.configure(with: message)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AIMessageCell", for: indexPath) as! AIMessageCell
            cell.configure(with: message)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension AIChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UICollectionViewDataSource
extension AIChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quickQuestions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickQuestionCell", for: indexPath) as! QuickQuestionCell
        let question = quickQuestions[indexPath.item]
        cell.configure(with: question)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AIChatViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let question = quickQuestions[indexPath.item]
        textField.text = question.question
        
        // 检查是否是第一次AI聊天
        if isFirstAIChat {
            isFirstAIChat = false // 这会自动保存到UserDefaults
            proceedWithAIChat(text: question.question)
        } else {
            // 非第一次AI聊天，检查用户状态
            let userInfo = UserManager.shared.userInfo
            if userInfo.isVip {
                // 会员用户免费使用
                proceedWithAIChat(text: question.question)
            } else if userInfo.diamondBalance >= 5 {
                // 非会员用户需要消耗钻石
                showDiamondConsumptionAlert { [weak self] in
                    self?.proceedWithAIChat(text: question.question)
                }
            } else {
                showInsufficientDiamondsAlert()
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension AIChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped()
        return true
    }
}

// MARK: - QuickQuestionCell
class QuickQuestionCell: UICollectionViewCell {
    private let containerView = UIView()
    private let questionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        containerView.backgroundColor = UIColor(hex: "#F5F5F5")
        containerView.layer.cornerRadius = 20
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        questionLabel.font = UIFont.systemFont(ofSize: 14)
        questionLabel.textColor = UIColor(hex: "#333333")
        questionLabel.numberOfLines = 2
        questionLabel.textAlignment = .center
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            questionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            questionLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with question: AIQuickQuestion) {
        questionLabel.text = question.question
    }
}

// MARK: - UserMessageCell
class UserMessageCell: UITableViewCell {
    private let containerView = UIView()
    private let messageLabel = UILabel()
    
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
        
        containerView.backgroundColor = UIColor(hex: "#4874F5")
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with message: AIChatViewController.ChatMessage) {
        messageLabel.text = message.content
    }
}

// MARK: - AIMessageCell
class AIMessageCell: UITableViewCell {
    private let containerView = UIView()
    private let messageLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
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
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = UIColor(hex: "#333333")
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)
        
        activityIndicator.color = UIColor(hex: "#4874F5")
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func configure(with message: AIChatViewController.ChatMessage) {
        if message.isLoading {
            messageLabel.isHidden = true
            activityIndicator.startAnimating()
        } else {
            messageLabel.isHidden = false
            activityIndicator.stopAnimating()
            messageLabel.text = message.content
        }
    }
} 
