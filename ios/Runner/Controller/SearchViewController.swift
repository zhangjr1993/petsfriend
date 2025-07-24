import UIKit

class SearchViewController: UIViewController {
    // MARK: - UI
    private var tableView: UITableView!
    private var headerView: UIView!
    private var searchContainer: UIView!
    private var searchIcon: UIImageView!
    private var searchTextField: UITextField!
    private var topBarView: UIView!
    private var backButton: UIButton!
    private var titleLabel: UILabel!
    private var emptyView: UIView!
    private var emptyImageView: UIImageView!
    private var emptyLabel: UILabel!

    // MARK: - Data
    private var allPets: [PetsCodable] = []
    private var resultPets: [PetsCodable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        allPets = AppRunManager.shared.petsList
        // 过滤掉被拉黑的用户
        let blockedIds = BlockedUserManager.shared.blockedUserIds
        allPets = allPets.filter { !blockedIds.contains($0.id) }
        setupGradientBackground()
        setupTopBar()
        setupSearchContainer()
        setupTableView()
        setupEmptyView()
        updateResultPets("")
        
        // 监听拉黑状态变化
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserBlocked), name: .userBlocked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserUnblocked), name: .userUnblocked, object: nil)
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

    private func setupTopBar() {
        topBarView = UIView()
        topBarView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBarView)
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 44 + UIApplication.statusBarHeight)
        ])
        // 返回按钮
        backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back_black"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        topBarView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: topBarView.topAnchor, constant: UIApplication.statusBarHeight + 6),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        // 标题
        titleLabel = UILabel()
        titleLabel.text = "搜索"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topBarView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: topBarView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
    }

    private func setupSearchContainer() {
        searchContainer = UIView()
        searchContainer.backgroundColor = .white
        searchContainer.layer.cornerRadius = 14
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchContainer)
        NSLayoutConstraint.activate([
            searchContainer.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 16),
            searchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchContainer.heightAnchor.constraint(equalToConstant: 48)
        ])
        // 搜索icon
        searchIcon = UIImageView()
        searchIcon.image = UIImage(named: "icon_search")
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchAction))
        searchIcon.addGestureRecognizer(tap)
        searchContainer.addSubview(searchIcon)
        NSLayoutConstraint.activate([
            searchIcon.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -12),
            searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 32),
            searchIcon.heightAnchor.constraint(equalToConstant: 32)
        ])
        // 搜索输入框
        searchTextField = UITextField()
        searchTextField.placeholder = "搜索宠物或主人"
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchTextField.textColor = UIColor(hex: "#111111")
        searchTextField.returnKeyType = .done
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.delegate = self
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 16),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: searchIcon.leadingAnchor, constant: -8),
            searchTextField.heightAnchor.constraint(equalTo: searchContainer.heightAnchor)
        ])
    }

    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PetInfoTableViewCell.self, forCellReuseIdentifier: PetInfoTableViewCell.description())
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupEmptyView() {
        emptyView = UIView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 60),
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.widthAnchor.constraint(equalToConstant: 200),
            emptyView.heightAnchor.constraint(equalToConstant: 200)
        ])
        emptyImageView = UIImageView()
        emptyImageView.image = UIImage(named: "bg_empty")
        emptyImageView.contentMode = .scaleAspectFit
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.addSubview(emptyImageView)
        NSLayoutConstraint.activate([
            emptyImageView.topAnchor.constraint(equalTo: emptyView.topAnchor),
            emptyImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 120),
            emptyImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        emptyLabel = UILabel()
        emptyLabel.text = "没有找到小宠呢~"
        emptyLabel.font = UIFont.systemFont(ofSize: 14)
        emptyLabel.textColor = UIColor(hex: "#666666")
        emptyLabel.textAlignment = .center
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyView.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 12),
            emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
        ])
        emptyView.isHidden = true
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func searchAction() {
        searchTextField.resignFirstResponder()
        updateResultPets(searchTextField.text ?? "")
    }

    private func updateResultPets(_ keyword: String) {
        let kw = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        if kw.isEmpty {
            resultPets = []
        } else {
            resultPets = allPets.filter { $0.userName.contains(kw) || $0.petName.contains(kw) }
        }
        tableView.reloadData()
        emptyView.isHidden = !resultPets.isEmpty || kw.isEmpty
    }
    
    @objc private func handleUserBlocked(_ notification: Notification) {
        // 重新加载数据并更新搜索结果
        allPets = AppRunManager.shared.petsList
        let blockedIds = BlockedUserManager.shared.blockedUserIds
        allPets = allPets.filter { !blockedIds.contains($0.id) }
        updateResultPets(searchTextField.text ?? "")
    }
    
    @objc private func handleUserUnblocked(_ notification: Notification) {
        // 重新加载数据并更新搜索结果
        allPets = AppRunManager.shared.petsList
        let blockedIds = BlockedUserManager.shared.blockedUserIds
        allPets = allPets.filter { !blockedIds.contains($0.id) }
        updateResultPets(searchTextField.text ?? "")
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultPets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PetInfoTableViewCell.description(), for: indexPath) as! PetInfoTableViewCell
        cell.configure(with: resultPets[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112+16
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pet = resultPets[indexPath.row]
        let petDetailVC = PetDetailViewController(pet: pet)
        navigationController?.pushViewController(petDetailVC, animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchAction()
        return true
    }
} 
