import UIKit
import Toast_Swift
import PhotosUI
import YPImagePicker

class ChatViewController: UIViewController {
    // MARK: - 消息模型
    enum MessageType {
        case text(String)
        case image(UIImage, localPath: String?)
    }
    struct Message {
        let msgId: String
        let type: MessageType
        let isMe: Bool
        let avatar: UIImage?
        let timestamp: Int64
    }
    // MARK: - 新增属性
    private let chatId: String
    // MARK: - UI
    private var titleText: String!
    private var tableView: UITableView!
    private var inputContainer: UIView!
    private var textView: UITextView!
    private var addButton: UIButton!
    private var inputContainerBottom: NSLayoutConstraint!
    private var textViewHeight: NSLayoutConstraint!
    
    // MARK: - Data
    private var messages: [Message] = []
    private let myAvatar = UIImage(named: "icon_head")
    private let otherAvatar = UIImage(named: "icon_me_about")
    
    // MARK: - 初始化
    init(chatId: Int, title: String) {
        self.chatId = "\(chatId)"
        self.titleText = title
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGradientBackground()
        setupTopBar()
        setupTableView()
        setupInputContainer()
        registerKeyboardNotifications()
        loadMessagesFromDB()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    // MARK: - TopBar
    private func setupTopBar() {
        let topBar = UIView()
        topBar.backgroundColor = .white
        topBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBar)
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 60+UIApplication.statusBarHeight)
        ])
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back_black"), for: .normal)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: topBar.topAnchor, constant: UIApplication.statusBarHeight + 8),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
    }
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    // MARK: - TableView
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .interactive
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TextMessageCell.self, forCellReuseIdentifier: "TextMessageCell")
        tableView.register(ImageMessageCell.self, forCellReuseIdentifier: "ImageMessageCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60+UIApplication.statusBarHeight),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    // MARK: - InputContainer
    private func setupInputContainer() {
        inputContainer = UIView()
        inputContainer.backgroundColor = .white
        inputContainer.layer.shadowColor = UIColor.black.cgColor
        inputContainer.layer.shadowOpacity = 0.06
        inputContainer.layer.shadowOffset = CGSize(width: 0, height: -2)
        inputContainer.layer.shadowRadius = 8
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputContainer)
        inputContainerBottom = inputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainerBottom
        ])
        // 输入框
        textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor(hex: "#111111")
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 12
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 54)
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.text = ""
        textView.returnKeyType = .done // 设置为done
        textView.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(textView)
        textViewHeight = textView.heightAnchor.constraint(equalToConstant: 42)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -12),
            textViewHeight,
            textView.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -8)
        ])
        // 占位符
        let placeholder = UILabel()
        placeholder.text = "聊一聊吧"
        placeholder.textColor = UIColor(hex: "#999999")
        placeholder.font = UIFont.systemFont(ofSize: 16)
        placeholder.isUserInteractionEnabled = false
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(placeholder)
        NSLayoutConstraint.activate([
            placeholder.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 18),
            placeholder.centerYAnchor.constraint(equalTo: textView.centerYAnchor)
        ])
        placeholder.tag = 1001
        // 添加按钮（改为图片btn_chat_add）
        addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(named: "btn_chat_add"), for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
        inputContainer.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -12),
            addButton.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -10),
            addButton.widthAnchor.constraint(equalToConstant: 24),
            addButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        // 移除发送按钮
        // TableView底部约束
        tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor).isActive = true
    }
    // MARK: - 键盘监听
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25
            inputContainerBottom.constant = -frame.height + view.safeAreaInsets.bottom
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25
        inputContainerBottom.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    // MARK: - 消息持久化
    private func loadMessagesFromDB() {
        let dbRecords = ChatMessageDBManager.shared.fetchMessages(for: chatId, limit: 100)
        messages = dbRecords.map { rec in
            if rec.type == "text" {
                return Message(msgId: rec.msgId, type: .text(rec.content), isMe: rec.isMe, avatar: rec.isMe ? myAvatar : otherAvatar, timestamp: rec.timestamp)
            } else if rec.type == "image" {
                var image: UIImage? = nil
                if FileManager.default.fileExists(atPath: rec.content) {
                    image = UIImage(contentsOfFile: rec.content)
                }
                if image == nil {
                    image = UIImage(named: "bg_empty")
                }
                return Message(msgId: rec.msgId, type: .image(image!, localPath: rec.content), isMe: rec.isMe, avatar: rec.isMe ? myAvatar : otherAvatar, timestamp: rec.timestamp)
            } else {
                return Message(msgId: rec.msgId, type: .text("[未知消息]"), isMe: rec.isMe, avatar: rec.isMe ? myAvatar : otherAvatar, timestamp: rec.timestamp)
            }
        }
        tableView.reloadData()
        scrollToBottom()
    }
    private func saveMessageToDB(_ msg: Message) {
        let typeStr: String
        let contentStr: String
        switch msg.type {
        case .text(let text):
            typeStr = "text"
            contentStr = text
        case .image(_, let localPath):
            typeStr = "image"
            contentStr = localPath ?? ""
        }
        let rec = ChatMessageRecord(
            msgId: msg.msgId,
            chatId: chatId,
            isMe: msg.isMe,
            type: typeStr,
            content: contentStr,
            timestamp: msg.timestamp
        )
        ChatMessageDBManager.shared.insertMessage(rec)
    }
    // MARK: - 发送消息
    @objc private func sendTapped() {
        guard let text = textView.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let msg = Message(
            msgId: UUID().uuidString,
            type: .text(text),
            isMe: true,
            avatar: myAvatar,
            timestamp: Int64(Date().timeIntervalSince1970)
        )
        messages.append(msg)
        saveMessageToDB(msg)
        textView.text = ""
        textViewDidChange(textView)
        tableView.reloadData()
        scrollToBottom()
    }
    // MARK: - 添加图片
    @objc private func addImageTapped() {
        var config = YPImagePickerConfiguration()
        config.screens = [.photo, .library]
        config.library.maxNumberOfItems = 1
        config.library.mediaType = .photo
        config.showsPhotoFilters = false
        config.startOnScreen = .library
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [weak self] items, _ in
            if let item = items.first, case let .photo(photo) = item {
                let image = photo.image
                let localPath = self?.saveImageToLocal(image)
                let msg = Message(
                    msgId: UUID().uuidString,
                    type: .image(image, localPath: localPath),
                    isMe: true,
                    avatar: self?.myAvatar,
                    timestamp: Int64(Date().timeIntervalSince1970)
                )
                self?.messages.append(msg)
                self?.saveMessageToDB(msg)
                self?.tableView.reloadData()
                self?.scrollToBottom()
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true)
    }
    // MARK: - 图片本地存储
    private func saveImageToLocal(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.85) else { return nil }
        let fileName = "chatimg_\(UUID().uuidString).jpg"
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = (dir as NSString).appendingPathComponent(fileName)
        do {
            try data.write(to: URL(fileURLWithPath: path), options: .atomic)
            return path
        } catch {
            print("图片保存失败: ", error)
            return nil
        }
    }
    // MARK: - 滚动到底部
    private func scrollToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(row: messages.count-1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = messages[indexPath.row]
        switch msg.type {
        case .text(let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextMessageCell", for: indexPath) as! TextMessageCell
            cell.configure(text: text, isMe: msg.isMe, avatar: msg.avatar)
            return cell
        case .image(let image, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageMessageCell", for: indexPath) as! ImageMessageCell
            cell.configure(image: image, isMe: msg.isMe, avatar: msg.avatar)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let msg = messages[indexPath.row]
        switch msg.type {
        case .text(let text):
            let maxWidth = view.frame.width * 0.6
            let size = (text as NSString).boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: UIFont.systemFont(ofSize: 16)], context: nil)
            return max(60, size.height + 32)
        case .image(let image, _):
            let maxWidth = view.frame.width * 0.5
            let imgSize = image.size
            var showHeight = maxWidth
            if imgSize.width > 0 && imgSize.height > 0 {
                if imgSize.width > imgSize.height {
                    showHeight = maxWidth * imgSize.height / imgSize.width
                } else {
                    showHeight = maxWidth
                }
            }
            return showHeight + 16 // 上下padding
        }
    }
    // MARK: - 图片预览
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msg = messages[indexPath.row]
        switch msg.type {
        case .image(_, let localPath):
            // 只用本地路径重新加载图片，保证预览大图时图片一定存在
            let imagePaths = messages.compactMap { m -> String? in
                if case .image(_, let path) = m.type, FileManager.default.fileExists(atPath: path ?? "") { return path } else { return nil }
            }
            let images = imagePaths.compactMap { UIImage(contentsOfFile: $0) }
            let imageIndex = imagePaths.firstIndex(of: localPath ?? "") ?? 0
            let preview = PhotoPreviewController(images: images, startIndex: imageIndex)
            preview.modalPresentationStyle = .fullScreen
            present(preview, animated: true)
        default:
            break
        }
    }
}

// MARK: - UITextViewDelegate
extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let minHeight: CGFloat = 42
        let maxHeight: CGFloat = 142
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: maxHeight))
        let newHeight = min(max(size.height, minHeight), maxHeight)
        textViewHeight.constant = newHeight
        // 占位符显示
        if let placeholder = inputContainer.viewWithTag(1001) as? UILabel {
            placeholder.isHidden = !textView.text.isEmpty
        }
    }
    // 禁止换行，按下return发送或收起键盘
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if let content = textView.text, !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                sendTapped()
            } else {
                textView.resignFirstResponder()
            }
            return false // 不插入换行
        }
        return true
    }
}

// MARK: - 文本消息Cell
class TextMessageCell: UITableViewCell {
    private let avatarView = UIImageView()
    private let bubbleView = UIView()
    private let messageLabel = UILabel()
    private var bubbleLeading: NSLayoutConstraint!
    private var bubbleTrailing: NSLayoutConstraint!
    private var avatarLeading: NSLayoutConstraint!
    private var avatarTrailing: NSLayoutConstraint!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        avatarView.layer.cornerRadius = 20
        avatarView.clipsToBounds = true
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarView)
        bubbleView.layer.cornerRadius = 10
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(messageLabel)
        avatarLeading = avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        avatarTrailing = avatarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        bubbleLeading = bubbleView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8)
        bubbleTrailing = bubbleView.trailingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: -8)
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 40),
            avatarView.heightAnchor.constraint(equalToConstant: 40),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func configure(text: String, isMe: Bool, avatar: UIImage?) {
        messageLabel.text = text
        avatarView.image = avatar
        if isMe {
            // 右侧
            avatarLeading.isActive = false
            avatarTrailing.isActive = true
            bubbleLeading.isActive = false
            bubbleTrailing.isActive = true
            bubbleView.backgroundColor = UIColor(hex: "#E0E7FD")
            messageLabel.textColor = UIColor(hex: "#111111")
        } else {
            // 左侧
            avatarLeading.isActive = true
            avatarTrailing.isActive = false
            bubbleLeading.isActive = true
            bubbleTrailing.isActive = false
            bubbleView.backgroundColor = .white
            messageLabel.textColor = UIColor(hex: "#111111")
        }
    }
}
// MARK: - 图片消息Cell
class ImageMessageCell: UITableViewCell {
    private let avatarView = UIImageView()
    private let bubbleView = UIView()
    private let messageImageView = UIImageView()
    private var bubbleLeading: NSLayoutConstraint!
    private var bubbleTrailing: NSLayoutConstraint!
    private var avatarLeading: NSLayoutConstraint!
    private var avatarTrailing: NSLayoutConstraint!
    private var imageWidth: NSLayoutConstraint!
    private var imageHeight: NSLayoutConstraint!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        avatarView.layer.cornerRadius = 20
        avatarView.clipsToBounds = true
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarView)
        bubbleView.layer.cornerRadius = 10
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)
        messageImageView.contentMode = .scaleAspectFill
        messageImageView.clipsToBounds = true
        messageImageView.layer.cornerRadius = 10
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(messageImageView)
        avatarLeading = avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        avatarTrailing = avatarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        bubbleLeading = bubbleView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8)
        bubbleTrailing = bubbleView.trailingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: -8)
        imageWidth = messageImageView.widthAnchor.constraint(equalToConstant: 80)
        imageHeight = messageImageView.heightAnchor.constraint(equalToConstant: 80)
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 40),
            avatarView.heightAnchor.constraint(equalToConstant: 40),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            messageImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
            messageImageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8),
            messageImageView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8),
            imageWidth,
            imageHeight
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func configure(image: UIImage, isMe: Bool, avatar: UIImage?) {
        messageImageView.image = image
        avatarView.image = avatar
        // 计算图片等比缩放后的宽高
        let maxWidth = UIScreen.main.bounds.width * 0.5
        let imgSize = image.size
        var showWidth = maxWidth
        var showHeight = maxWidth
        if imgSize.width > 0 && imgSize.height > 0 {
            if imgSize.width > imgSize.height {
                showWidth = maxWidth
                showHeight = maxWidth * imgSize.height / imgSize.width
            } else {
                showHeight = maxWidth
                showWidth = maxWidth * imgSize.width / imgSize.height
            }
        }
        imageWidth.constant = showWidth
        imageHeight.constant = showHeight
        if isMe {
            // 右侧
            avatarLeading.isActive = false
            avatarTrailing.isActive = true
            bubbleLeading.isActive = false
            bubbleTrailing.isActive = true
            bubbleView.backgroundColor = UIColor(hex: "#E0E7FD")
        } else {
            // 左侧
            avatarLeading.isActive = true
            avatarTrailing.isActive = false
            bubbleLeading.isActive = true
            bubbleTrailing.isActive = false
            bubbleView.backgroundColor = .white
        }
    }
} 
