import UIKit

class PetEncyclopediaViewController: UIViewController {
    
    // MARK: - UI Components
    private var tableView: UITableView!
    private var searchBar: UISearchBar!
    private var segmentedControl: UISegmentedControl!
    
    // MARK: - Data
    private var allArticles: [PetEncyclopedia] = []
    private var filteredArticles: [PetEncyclopedia] = []
    private var currentCategory: PetEncyclopedia.PetCategory = .general
    private var isSearching = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupNavigationBar()
        setupData()
        setupSearchBar()
        setupSegmentedControl()
        setupTableView()
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
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupData() {
        allArticles = PetServiceData.shared.getPetEncyclopediaData()
        filteredArticles = allArticles
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "搜索宠物知识..."
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupSegmentedControl() {
        let categories = PetEncyclopedia.PetCategory.allCases
        let titles = categories.map { $0.displayName }
        
        segmentedControl = UISegmentedControl(items: titles)
        segmentedControl.selectedSegmentIndex = 2 // 默认选择"通用"
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 15),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EncyclopediaCell.self, forCellReuseIdentifier: "EncyclopediaCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func segmentChanged() {
        let categories = PetEncyclopedia.PetCategory.allCases
        currentCategory = categories[segmentedControl.selectedSegmentIndex]
        filterArticles()
    }
    
    private func filterArticles() {
        if isSearching {
            // 如果正在搜索，保持搜索结果
            return
        }
        
        if currentCategory == .general {
            filteredArticles = allArticles
        } else {
            filteredArticles = allArticles.filter { $0.category == currentCategory }
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension PetEncyclopediaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EncyclopediaCell", for: indexPath) as! EncyclopediaCell
        let article = filteredArticles[indexPath.row]
        cell.configure(with: article)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PetEncyclopediaViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = filteredArticles[indexPath.row]
        let vc = EncyclopediaDetailViewController()
        vc.article = article
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension PetEncyclopediaViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filterArticles()
        } else {
            isSearching = true
            filteredArticles = PetServiceData.shared.searchEncyclopedia(searchText)
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - EncyclopediaCell
class EncyclopediaCell: UITableViewCell {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let difficultyLabel = UILabel()
    private let readTimeLabel = UILabel()
    private let bookmarkButton = UIButton()
    
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
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor(hex: "#666666")
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contentLabel)
        
        difficultyLabel.font = UIFont.systemFont(ofSize: 12)
        difficultyLabel.textColor = .white
        difficultyLabel.backgroundColor = UIColor(hex: "#4874F5")
        difficultyLabel.layer.cornerRadius = 8
        difficultyLabel.layer.masksToBounds = true
        difficultyLabel.textAlignment = .center
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(difficultyLabel)
        
        readTimeLabel.font = UIFont.systemFont(ofSize: 12)
        readTimeLabel.textColor = UIColor(hex: "#999999")
        readTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(readTimeLabel)
        
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        bookmarkButton.tintColor = UIColor(hex: "#F3AF4B")
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bookmarkButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: bookmarkButton.leadingAnchor, constant: -8),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            difficultyLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            difficultyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            difficultyLabel.widthAnchor.constraint(equalToConstant: 40),
            difficultyLabel.heightAnchor.constraint(equalToConstant: 20),
            
            readTimeLabel.centerYAnchor.constraint(equalTo: difficultyLabel.centerYAnchor),
            readTimeLabel.leadingAnchor.constraint(equalTo: difficultyLabel.trailingAnchor, constant: 12),
            
            bookmarkButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            bookmarkButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 24),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 24),
            
            // 关键约束：让 containerView 的底部约束到 difficultyLabel 的底部，contentView 的底部约束到 containerView
            containerView.bottomAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8)
        ])
    }
    
    func configure(with article: PetEncyclopedia) {
        titleLabel.text = article.title
        contentLabel.text = article.content
        difficultyLabel.text = article.difficulty.displayName
        readTimeLabel.text = "\(article.readTime)分钟"
        bookmarkButton.isSelected = article.isBookmarked
    }
}

// MARK: - EncyclopediaDetailViewController
class EncyclopediaDetailViewController: UIViewController {
    var article: PetEncyclopedia?
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var titleLabel: UILabel!
    private var contentLabel: UILabel!
    private var bookmarkButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupNavigationBar()
        setupUI()
        configureContent()
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
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor(hex: "#111111")
        
        title = "文章详情"
        
        bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(bookmarkTapped))
        bookmarkButton.tintColor = UIColor(hex: "#F3AF4B")
        navigationItem.rightBarButtonItem = bookmarkButton
    }
    
    private func setupUI() {
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = UIColor(hex: "#333333")
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureContent() {
        guard let article = article else { return }
        
        titleLabel.text = article.title
        contentLabel.text = article.content
        bookmarkButton.image = article.isBookmarked ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
    }
    
    @objc private func bookmarkTapped() {
        // 这里可以实现收藏功能
        bookmarkButton.image = bookmarkButton.image == UIImage(systemName: "bookmark") ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
    }
} 
