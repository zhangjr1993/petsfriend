import UIKit

// MARK: - HomeViewController
class HomeViewController: UIViewController {
    
    // MARK: - UI Components
    private var tableView: UITableView!
    private var headerView: UIView!
    
    // MARK: - Data
    private var petsArray: [PetsCodable] = []
    private var allPets: [PetsCodable] = []
    private var isDogSelected = false
    private var isCatSelected = false
    private var dogButton: UIButton!
    private var catButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupTableView()
        setupHeaderView()
        loadPetData()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserProfile), name: .userProfileDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func refreshUserProfile() {
        setupHeaderView()
    }
    
    // MARK: - Data Loading
    private func loadPetData() {
        allPets = Array(AppRunManager.shared.petsList)
        petsArray = allPets.shuffled()
        tableView.reloadData()
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
        
        // 保存渐变层引用以便在视图大小变化时更新
        gradientLayer.name = "gradientBackground"
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 更新渐变背景的frame
        if let gradientLayer = view.layer.sublayers?.first(where: { $0.name == "gradientBackground" }) as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupHeaderView() {
        headerView = UIView()
        headerView.backgroundColor = .clear
        
        // 用户头像
        let userAvatar = UIImageView()
        userAvatar.backgroundColor = .systemGray5
        userAvatar.layer.cornerRadius = 14
        userAvatar.clipsToBounds = true
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.image = UIImage(named: "icon_head")
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        
        if let data = UserDefaults.standard.userProfile?.avatarData, let img = UIImage(data: data) {
            userAvatar.image = img
        }
        // 用户昵称
        let userNickname = UILabel()
        userNickname.text = UserDefaults.standard.userProfile?.nickname ?? "Hello 月亮姐姐"
        userNickname.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        userNickname.textColor = .defaultTextColor
        userNickname.translatesAutoresizingMaskIntoConstraints = false
        
        // 宣传文本
        let promotionText = UILabel()
        promotionText.text = "来看看更多好朋友"
        promotionText.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        promotionText.textColor = .descriptionTextColor
        promotionText.translatesAutoresizingMaskIntoConstraints = false
        
        // 搜索框容器
        let searchContainer = UIView()
        searchContainer.backgroundColor = .white
        searchContainer.layer.cornerRadius = 14
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchContainerTapped))
        searchContainer.addGestureRecognizer(tapGesture)
        searchContainer.isUserInteractionEnabled = true
        
        // 搜索提示文本
        let searchPlaceholder = UILabel()
        searchPlaceholder.text = "搜索"
        searchPlaceholder.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        searchPlaceholder.textColor = .descriptionTextColor
        searchPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        
        // 搜索图标
        let searchIcon = UIImageView()
        searchIcon.image = UIImage(named: "icon_search")
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // Dog按钮
        dogButton = UIButton()
        dogButton.setBackgroundImage(UIImage(named: "icon_dog_pre"), for: .normal)
        dogButton.setBackgroundImage(UIImage(named: "icon_dog"), for: .selected)
        dogButton.addTarget(self, action: #selector(dogButtonTapped), for: .touchUpInside)
        dogButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Cat按钮
        catButton = UIButton()
        catButton.setBackgroundImage(UIImage(named: "icon_cat_pre"), for: .normal)
        catButton.setBackgroundImage(UIImage(named: "icon_cat"), for: .selected)
        catButton.addTarget(self, action: #selector(catButtonTapped), for: .touchUpInside)
        catButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 推荐标题
        let recommendTitle = UILabel()
        recommendTitle.text = "推荐"
        recommendTitle.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        recommendTitle.textColor = .defaultTextColor
        recommendTitle.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加到headerView
        headerView.addSubview(userAvatar)
        headerView.addSubview(userNickname)
        headerView.addSubview(promotionText)
        headerView.addSubview(searchContainer)
        searchContainer.addSubview(searchPlaceholder)
        searchContainer.addSubview(searchIcon)
        headerView.addSubview(dogButton)
        headerView.addSubview(catButton)
        headerView.addSubview(recommendTitle)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 用户头像
            userAvatar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            userAvatar.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            userAvatar.widthAnchor.constraint(equalToConstant: 48),
            userAvatar.heightAnchor.constraint(equalToConstant: 48),
            
            // 用户昵称
            userNickname.leadingAnchor.constraint(equalTo: userAvatar.leadingAnchor),
            userNickname.topAnchor.constraint(equalTo: userAvatar.bottomAnchor, constant: 16),
            
            // 宣传文本
            promotionText.leadingAnchor.constraint(equalTo: userAvatar.leadingAnchor),
            promotionText.topAnchor.constraint(equalTo: userNickname.bottomAnchor, constant: 6),
            promotionText.heightAnchor.constraint(equalToConstant: 16),
            
            // 搜索框容器
            searchContainer.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            searchContainer.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            searchContainer.topAnchor.constraint(equalTo: promotionText.bottomAnchor, constant: 21),
            searchContainer.heightAnchor.constraint(equalToConstant: 48),
            
            // 搜索提示文本
            searchPlaceholder.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 16),
            searchPlaceholder.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            
            // 搜索图标
            searchIcon.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -12),
            searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 32),
            searchIcon.heightAnchor.constraint(equalToConstant: 32),
            
            // Dog按钮
            dogButton.leadingAnchor.constraint(equalTo: userAvatar.leadingAnchor),
            dogButton.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 16),
            dogButton.widthAnchor.constraint(equalToConstant: 85),
            dogButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Cat按钮
            catButton.leadingAnchor.constraint(equalTo: dogButton.trailingAnchor, constant: 16),
            catButton.topAnchor.constraint(equalTo: dogButton.topAnchor),
            catButton.widthAnchor.constraint(equalToConstant: 85),
            catButton.heightAnchor.constraint(equalToConstant: 40),
            
            // 推荐标题
            recommendTitle.leadingAnchor.constraint(equalTo: userAvatar.leadingAnchor),
            recommendTitle.topAnchor.constraint(equalTo: dogButton.bottomAnchor, constant: 16),
            recommendTitle.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 290)
    }
    
    // MARK: - Actions
    @objc private func dogButtonTapped() {
        if isDogSelected {
            // 已选中，再点取消
            isDogSelected = false
        } else {
            isDogSelected = true
            isCatSelected = false
        }
        updateFilterUIAndData()
    }
    
    @objc private func catButtonTapped() {
        if isCatSelected {
            // 已选中，再点取消
            isCatSelected = false
        } else {
            isCatSelected = true
            isDogSelected = false
        }
        updateFilterUIAndData()
    }
    
    @objc private func searchContainerTapped() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }

    private func updateFilterUIAndData() {
        dogButton.isSelected = isDogSelected
        catButton.isSelected = isCatSelected
        if isDogSelected {
            petsArray = allPets.filter { $0.petSex == "狗" }
        } else if isCatSelected {
            petsArray = allPets.filter { $0.petSex == "猫" }
        } else {
            petsArray = allPets
        }
        let section = IndexSet(integer: 0)
        tableView.reloadSections(section, with: .fade)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PetInfoTableViewCell.description(), for: indexPath) as! PetInfoTableViewCell
        cell.configure(with: petsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112+16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pet = petsArray[indexPath.row]
        let petDetailVC = PetDetailViewController(pet: pet)
        navigationController?.pushViewController(petDetailVC, animated: true)
    }
}
