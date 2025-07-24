import UIKit

class BlockedListViewController: UIViewController {
    
    // MARK: - UI Components
    private var tableView: UITableView!
    private var emptyView: UIView!
    private var emptyImageView: UIImageView!
    private var emptyLabel: UILabel!
    
    // MARK: - Data
    private var blockedUsers: [BlockedUser] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
        loadBlockedUsers()
        setupNotifications()
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
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .white
        title = "拉黑列表"
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        setupTableView()
        setupEmptyView()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BlockedUserCell.self, forCellReuseIdentifier: "BlockedUserCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEmptyView() {
        emptyView = UIView()
        emptyView.backgroundColor = .clear
        emptyView.isHidden = true
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyImageView = UIImageView()
        emptyImageView.image = UIImage(named: "bg_empty")
        emptyImageView.contentMode = .scaleAspectFit
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyLabel = UILabel()
        emptyLabel.text = "暂无拉黑用户"
        emptyLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emptyLabel.textColor = .descriptionTextColor
        emptyLabel.textAlignment = .center
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.addSubview(emptyImageView)
        emptyView.addSubview(emptyLabel)
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyImageView.topAnchor.constraint(equalTo: emptyView.topAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 120),
            emptyImageView.heightAnchor.constraint(equalToConstant: 120),
            
            emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 16),
            emptyLabel.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor)
        ])
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserBlocked), name: .userBlocked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserUnblocked), name: .userUnblocked, object: nil)
    }
    
    // MARK: - Data Loading
    private func loadBlockedUsers() {
        blockedUsers = BlockedUserManager.shared.blockedUsers
        updateUI()
    }
    
    private func updateUI() {
        tableView.reloadData()
        emptyView.isHidden = !blockedUsers.isEmpty
    }
    
    // MARK: - Notification Handlers
    @objc private func handleUserBlocked(_ notification: Notification) {
        loadBlockedUsers()
    }
    
    @objc private func handleUserUnblocked(_ notification: Notification) {
        loadBlockedUsers()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension BlockedListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockedUserCell", for: indexPath) as! BlockedUserCell
        let blockedUser = blockedUsers[indexPath.row]
        cell.configure(with: blockedUser)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - BlockedUserCellDelegate
extension BlockedListViewController: BlockedUserCellDelegate {
    func blockedUserCell(_ cell: BlockedUserCell, didTapUnblock user: BlockedUser) {
        let alert = UIAlertController(title: "解除拉黑", message: "确定要解除拉黑 \(user.userName) 吗？", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "确定", style: .destructive) { [weak self] _ in
            BlockedUserManager.shared.unblockUser(withId: user.id)
            self?.view.makeToast("已解除拉黑")
        })
        
        present(alert, animated: true)
    }
}

// MARK: - BlockedUserCell
class BlockedUserCell: UITableViewCell {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let userAvatarImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let petInfoLabel = UILabel()
    private let unblockButton = UIButton()
    
    // MARK: - Data
    private var blockedUser: BlockedUser?
    weak var delegate: BlockedUserCellDelegate?
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // 容器视图
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 用户头像
        userAvatarImageView.backgroundColor = .systemGray5
        userAvatarImageView.layer.cornerRadius = 20
        userAvatarImageView.clipsToBounds = true
        userAvatarImageView.contentMode = .scaleAspectFill
        userAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 用户名称
        userNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        userNameLabel.textColor = .defaultTextColor
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 宠物信息
        petInfoLabel.font = UIFont.systemFont(ofSize: 14)
        petInfoLabel.textColor = .descriptionTextColor
        petInfoLabel.numberOfLines = 2
        petInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 解除拉黑按钮
        unblockButton.setTitle("解除拉黑", for: .normal)
        unblockButton.setTitleColor(.white, for: .normal)
        unblockButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        unblockButton.backgroundColor = UIColor(hex: "#F3AF4B")
        unblockButton.layer.cornerRadius = 16
        unblockButton.addTarget(self, action: #selector(unblockButtonTapped), for: .touchUpInside)
        unblockButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加到容器
        containerView.addSubview(userAvatarImageView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(petInfoLabel)
        containerView.addSubview(unblockButton)
        contentView.addSubview(containerView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            userAvatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            userAvatarImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            userAvatarImageView.widthAnchor.constraint(equalToConstant: 40),
            userAvatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userAvatarImageView.trailingAnchor, constant: 12),
            userNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: unblockButton.leadingAnchor, constant: -12),
            
            petInfoLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            petInfoLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            petInfoLabel.trailingAnchor.constraint(equalTo: unblockButton.leadingAnchor, constant: -12),
            petInfoLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),
            
            unblockButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            unblockButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            unblockButton.widthAnchor.constraint(equalToConstant: 80),
            unblockButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    // MARK: - Configuration
    func configure(with user: BlockedUser) {
        self.blockedUser = user
        
        userAvatarImageView.setAppImg(user.userPic)
        userNameLabel.text = user.userName
        
        let petInfo = "\(user.petName) · \(user.petCategory) · \(user.petAge)"
        petInfoLabel.text = "\(petInfo)\n\(user.desc)"
    }
    
    // MARK: - Actions
    @objc private func unblockButtonTapped() {
        guard let user = blockedUser else { return }
        delegate?.blockedUserCell(self, didTapUnblock: user)
    }
}

// MARK: - BlockedUserCellDelegate
protocol BlockedUserCellDelegate: AnyObject {
    func blockedUserCell(_ cell: BlockedUserCell, didTapUnblock user: BlockedUser)
} 
