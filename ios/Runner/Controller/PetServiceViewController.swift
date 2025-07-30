import UIKit

class PetServiceViewController: UIViewController {
    
    // MARK: - UI Components
    private var collectionView: UICollectionView!
    private var searchBar: UISearchBar!
    
    // MARK: - Data
    private var serviceCategories: [ServiceCategory] = []
    private var filteredCategories: [ServiceCategory] = []
    private var isSearching = false
    
    // MARK: - Service Category
    struct ServiceCategory {
        let id: String
        let title: String
        let subtitle: String
        let iconName: String
        let backgroundColor: String
        let type: CategoryType
        
        enum CategoryType {
            case encyclopedia
            case healthGuide
            case aiChat
            case voicePrint
            case healthRecord
            case addPet
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupData()
        setupSearchBar()
        setupCollectionView()
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
    
    private func setupData() {
        serviceCategories = [
            ServiceCategory(
                id: "1",
                title: "宠物百科",
                subtitle: "专业养宠知识库",
                iconName: "icon_encyclopedia",
                backgroundColor: "#4874F5",
                type: .encyclopedia
            ),
            ServiceCategory(
                id: "2",
                title: "健康指南",
                subtitle: "疾病预防与治疗",
                iconName: "icon_health",
                backgroundColor: "#F44336",
                type: .healthGuide
            ),
            ServiceCategory(
                id: "3",
                title: "AI智能问答",
                subtitle: "一对一专业咨询",
                iconName: "icon_ai_chat",
                backgroundColor: "#4CAF50",
                type: .aiChat
            ),
            ServiceCategory(
                id: "4",
                title: "声纹识别",
                subtitle: "宠物声音档案",
                iconName: "icon_voice",
                backgroundColor: "#FF9800",
                type: .voicePrint
            ),
            ServiceCategory(
                id: "5",
                title: "健康档案",
                subtitle: "宠物医疗记录",
                iconName: "icon_medical",
                backgroundColor: "#9C27B0",
                type: .healthRecord
            ),
            ServiceCategory(
                id: "6",
                title: "发布动态",
                subtitle: "分享宠物生活",
                iconName: "icon_add_pet",
                backgroundColor: "#F3AF4B",
                type: .addPet
            )
        ]
        filteredCategories = serviceCategories
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "搜索宠物服务..."
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
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let itemWidth = (UIScreen.main.bounds.width - 60) / 2
        layout.itemSize = CGSize(width: itemWidth, height: 160)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ServiceCategoryCell.self, forCellWithReuseIdentifier: "ServiceCategoryCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension PetServiceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCategoryCell", for: indexPath) as! ServiceCategoryCell
        let category = filteredCategories[indexPath.item]
        cell.configure(with: category)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PetServiceViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = filteredCategories[indexPath.item]
        
        switch category.type {
        case .encyclopedia:
            let vc = PetEncyclopediaViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case .healthGuide:
            let vc = PetHealthGuideViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case .aiChat:
            let vc = AIChatViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case .voicePrint:
            let vc = PetVoicePrintViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case .healthRecord:
            let vc = PetHealthRecordViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case .addPet:
            let vc = AddViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate
extension PetServiceViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCategories = serviceCategories
            isSearching = false
        } else {
            filteredCategories = serviceCategories.filter { 
                $0.title.contains(searchText) || $0.subtitle.contains(searchText)
            }
            isSearching = true
        }
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - ServiceCategoryCell
class ServiceCategoryCell: UICollectionViewCell {
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = UIColor(hex: "#666666")
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 48),
            iconImageView.heightAnchor.constraint(equalToConstant: 48),
            
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with category: PetServiceViewController.ServiceCategory) {
        titleLabel.text = category.title
        subtitleLabel.text = category.subtitle
        
        // 设置图标（使用系统图标作为占位符）
        let iconName = getIconName(for: category.type)
        iconImageView.image = UIImage(systemName: iconName)?.withTintColor(UIColor(hex: category.backgroundColor), renderingMode: .alwaysOriginal)
        
        // 设置背景色
        containerView.backgroundColor = UIColor(hex: category.backgroundColor).withAlphaComponent(0.1)
    }
    
    private func getIconName(for type: PetServiceViewController.ServiceCategory.CategoryType) -> String {
        switch type {
        case .encyclopedia: return "book.fill"
        case .healthGuide: return "heart.fill"
        case .aiChat: return "message.fill"
        case .voicePrint: return "waveform"
        case .healthRecord: return "doc.text.fill"
        case .addPet: return "plus.circle.fill"
        }
    }
} 