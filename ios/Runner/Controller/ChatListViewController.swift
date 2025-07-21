//
//  ChatListViewController.swift
//  Runner
//
//  Created by Bolo on 2025/7/16.
//

import UIKit

struct ChatSession {
    let chatId: String
    let userName: String
    let userPic: String // 头像URL或本地路径
    let lastMessage: String
    let lastTimestamp: Int64
}

class ChatListViewController: UIViewController {
    private var tableView: UITableView!
    private var sessions: [ChatSession] = []
    private let topBarHeight: CGFloat = 60 + UIApplication.statusBarHeight
    private var emptyView: UIView? // 新增属性
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSessions()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupGradientBackground()
        setupTopBar()
        setupTableView()
        setupEmptyView() // 新增
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
        topBar.backgroundColor = .clear
        topBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBar)
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: topBarHeight)
        ])
        let titleLabel = UILabel()
        titleLabel.text = "消息"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: topBar.bottomAnchor, constant: -14)
        ])
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChatSessionCell.self, forCellReuseIdentifier: "ChatSessionCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: topBarHeight),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEmptyView() {
        let emptyView = UIView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.fromRunnerBundle(imgName: "bg_empty") ?? UIImage(named: "bg_empty")
        imageView.contentMode = .scaleAspectFit

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "还没有联系人哦~"
        label.textColor = UIColor(hex: "#999999")
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center

        emptyView.addSubview(imageView)
        emptyView.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 180),
            imageView.heightAnchor.constraint(equalToConstant: 180),

            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18),
            label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
        ])

        self.emptyView = emptyView
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: tableView.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
        emptyView.isHidden = true
    }
    
    private func loadSessions() {
        // 1. 获取所有消息，分组取每个chatId的最新一条
        let db = ChatMessageDBManager.shared
        var sessionDict: [String: ChatMessageRecord] = [:]
        let allMessages = try? db.db.prepare(db.messages.order(db.timestamp.desc))
        allMessages?.forEach { row in
            let chatId = row[db.chatId]
            if sessionDict[chatId] == nil {
                sessionDict[chatId] = ChatMessageRecord(
                    msgId: row[db.msgId],
                    chatId: chatId,
                    isMe: row[db.isMe],
                    type: row[db.type],
                    content: row[db.content],
                    timestamp: row[db.timestamp]
                )
            }
        }
        // 2. 获取用户信息
        let petsList = AppRunManager.shared.petsList
        sessions = sessionDict.values.compactMap { msg in
            let pet = petsList.first { "\($0.id)" == msg.chatId }
            return ChatSession(
                chatId: msg.chatId,
                userName: pet?.userName ?? "用户\(msg.chatId)",
                userPic: pet?.userPic ?? "",
                lastMessage: msg.type == "text" ? msg.content : "[图片]",
                lastTimestamp: msg.timestamp
            )
        }.sorted { $0.lastTimestamp > $1.lastTimestamp }
        tableView.reloadData()
        emptyView?.isHidden = !sessions.isEmpty // 新增：根据 sessions 是否为空显示/隐藏 emptyView
    }
}

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatSessionCell", for: indexPath) as! ChatSessionCell
        cell.configure(with: sessions[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82 // 72+10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let session = sessions[indexPath.row]
        let chatVC = ChatViewController(chatId: Int(session.chatId) ?? 0, title: session.userName)
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

class ChatSessionCell: UITableViewCell {
    private let container = UIView()
    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let messageLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(container)
        container.backgroundColor = .white
        container.layer.cornerRadius = 14
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.06
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 8
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.heightAnchor.constraint(equalToConstant: 72),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        avatarView.layer.cornerRadius = 10
        avatarView.clipsToBounds = true
        avatarView.contentMode = .scaleAspectFill
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(avatarView)
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            avatarView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 52),
            avatarView.heightAnchor.constraint(equalToConstant: 52)
        ])
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        nameLabel.textColor = UIColor(hex: "#111111")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 14),
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15)
        ])
        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        messageLabel.textColor = UIColor(hex: "#666666")
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func configure(with session: ChatSession) {
        nameLabel.text = session.userName
        messageLabel.text = session.lastMessage
        if let img = UIImage.fromRunnerBundle(imgName: session.userPic) { // 本地图片
            avatarView.image = img
        } else if !session.userPic.isEmpty, let img = UIImage(contentsOfFile: session.userPic) {
            avatarView.image = img
        } else {
            avatarView.image = UIImage(named: "icon_head")
        }
    }
}
