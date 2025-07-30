import UIKit

class PublicWelfareViewController: UIViewController {
    
    // MARK: - UI Components
    private var tableView: UITableView!
    private var headerView: UIView!
    
    // MARK: - Data
    private var welfareArticles: [WelfareArticle] = []
    private var welfareFunctions: [WelfareFunction] = []
    
    // MARK: - Data Models
    struct WelfareArticle {
        let id: String
        let title: String
        let subtitle: String
        let imageName: String
        let category: ArticleCategory
        let readTime: String
        let isHot: Bool
        
        enum ArticleCategory: String, CaseIterable {
            case companion = "陪伴犬"
            case guide = "导盲犬"
            case police = "警犬"
            case rescue = "搜救犬"
            
            var color: String {
                switch self {
                case .companion: return "#4CAF50"
                case .guide: return "#2196F3"
                case .police: return "#FF5722"
                case .rescue: return "#FF9800"
                }
            }
        }
    }
    
    struct WelfareFunction {
        let id: String
        let title: String
        let subtitle: String
        let iconName: String
        let backgroundColor: String
        let type: FunctionType
        
        enum FunctionType {
            case education
            case news
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupData()
        setupHeaderView()
        setupTableView()
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
        // 初始化公益文章数据
        welfareArticles = [
            WelfareArticle(
                id: "1",
                title: "陪伴犬：孤独老人的温暖守护者",
                subtitle: "了解陪伴犬如何为独居老人带来精神慰藉和生活帮助",
                imageName: "peibangq",
                category: .companion,
                readTime: "5分钟",
                isHot: true
            ),
            WelfareArticle(
                id: "2",
                title: "导盲犬：视障人士的明亮双眼",
                subtitle: "探索导盲犬训练过程和工作原理，感受它们为视障人士带来的自由",
                imageName: "daomangq",
                category: .guide,
                readTime: "8分钟",
                isHot: true
            ),
            WelfareArticle(
                id: "3",
                title: "警犬：忠诚的执法伙伴",
                subtitle: "揭秘警犬在维护社会治安中的重要作用和训练方法",
                imageName: "jingquan",
                category: .police,
                readTime: "6分钟",
                isHot: false
            ),
            WelfareArticle(
                id: "4",
                title: "搜救犬：灾难中的生命守护者",
                subtitle: "见证搜救犬在地震、山难等紧急情况下的英勇表现",
                imageName: "soujiuq",
                category: .rescue,
                readTime: "9分钟",
                isHot: true
            )
        ]
        
        // 初始化公益功能数据
        welfareFunctions = [
            WelfareFunction(
                id: "1",
                title: "公益教育",
                subtitle: "普及动物保护知识",
                iconName: "icon_education",
                backgroundColor: "#FF9800",
                type: .education
            ),
            WelfareFunction(
                id: "2",
                title: "公益资讯",
                subtitle: "了解最新公益动态",
                iconName: "icon_news",
                backgroundColor: "#607D8B",
                type: .news
            )
        ]
    }
    
    private func setupHeaderView() {
        headerView = UIView()
        headerView.backgroundColor = .clear
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "公益专区"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // 副标题
        let subtitleLabel = UILabel()
        subtitleLabel.text = "关爱动物，传递温暖"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = UIColor(hex: "#666666")
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: UIApplication.statusBarHeight + 20),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: UIApplication.statusBarHeight + 80)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WelfareFunctionCell.self, forCellReuseIdentifier: "WelfareFunctionCell")
        tableView.register(WelfareArticleCell.self, forCellReuseIdentifier: "WelfareArticleCell")
        tableView.register(WelfareSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "WelfareSectionHeaderView")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.tableHeaderView = headerView
    }
}

// MARK: - UITableViewDataSource
extension PublicWelfareViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1 // 功能区（使用CollectionView）
        case 1: return welfareArticles.count // 文章列表
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WelfareFunctionCell", for: indexPath) as! WelfareFunctionCell
            cell.configure(with: welfareFunctions)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WelfareArticleCell", for: indexPath) as! WelfareArticleCell
            let article = welfareArticles[indexPath.row]
            cell.configure(with: article)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension PublicWelfareViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 200 // 功能区高度
        case 1: return 120 // 文章单元格高度
        default: return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WelfareSectionHeaderView") as! WelfareSectionHeaderView
        headerView.configure(title: section == 0 ? "公益功能" : "公益文章")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let article = welfareArticles[indexPath.row]
            // 这里可以跳转到文章详情页
            showArticleDetail(article)
        }
    }
    
    private func showArticleDetail(_ article: WelfareArticle) {
        let vc = WelfareArticleDetailViewController(article: article)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - WelfareFunctionCellDelegate
extension PublicWelfareViewController: WelfareFunctionCellDelegate {
    func welfareFunctionCell(_ cell: WelfareFunctionCell, didSelectFunction function: PublicWelfareViewController.WelfareFunction) {
        switch function.type {
        case .education:
            let vc = WelfareEducationViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .news:
            let vc = WelfareNewsViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - WelfareFunctionCell
class WelfareFunctionCell: UITableViewCell {
    private var collectionView: UICollectionView!
    private var functions: [PublicWelfareViewController.WelfareFunction] = []
    weak var delegate: WelfareFunctionCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 160)
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WelfareFunctionItemCell.self, forCellWithReuseIdentifier: "WelfareFunctionItemCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with functions: [PublicWelfareViewController.WelfareFunction]) {
        self.functions = functions
        collectionView.reloadData()
    }
}

extension WelfareFunctionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return functions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelfareFunctionItemCell", for: indexPath) as! WelfareFunctionItemCell
        let function = functions[indexPath.item]
        cell.configure(with: function)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let function = functions[indexPath.item]
        delegate?.welfareFunctionCell(self, didSelectFunction: function)
    }
}

protocol WelfareFunctionCellDelegate: AnyObject {
    func welfareFunctionCell(_ cell: WelfareFunctionCell, didSelectFunction function: PublicWelfareViewController.WelfareFunction)
}

// MARK: - WelfareFunctionItemCell
class WelfareFunctionItemCell: UICollectionViewCell {
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
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 11)
        subtitleLabel.textColor = UIColor(hex: "#666666")
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4)
        ])
    }
    
    func configure(with function: PublicWelfareViewController.WelfareFunction) {
        titleLabel.text = function.title
        subtitleLabel.text = function.subtitle
        
        // 使用系统图标作为占位符
        let iconName = getIconName(for: function.type)
        iconImageView.image = UIImage(systemName: iconName)?.withTintColor(UIColor(hex: function.backgroundColor), renderingMode: .alwaysOriginal)
        
        containerView.backgroundColor = UIColor(hex: function.backgroundColor).withAlphaComponent(0.1)
    }
    
    private func getIconName(for type: PublicWelfareViewController.WelfareFunction.FunctionType) -> String {
        switch type {
        case .education: return "book.fill"
        case .news: return "newspaper.fill"
        }
    }
}

// MARK: - WelfareArticleCell
class WelfareArticleCell: UITableViewCell {
    private let containerView = UIView()
    private let bgImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let readTimeLabel = UILabel()
    
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
        containerView.layer.shadowOpacity = 0.06
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
        bgImageView.layer.cornerRadius = 8
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bgImageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = UIColor(hex: "#666666")
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)
        
        categoryLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        categoryLabel.textColor = .white
        categoryLabel.textAlignment = .center
        categoryLabel.layer.cornerRadius = 8
        categoryLabel.layer.masksToBounds = true
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(categoryLabel)
        
        readTimeLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        readTimeLabel.textColor = UIColor(hex: "#999999")
        readTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(readTimeLabel)
            
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            bgImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            bgImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            bgImageView.widthAnchor.constraint(equalToConstant: 80),
            bgImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: bgImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            categoryLabel.heightAnchor.constraint(equalToConstant: 16),
            categoryLabel.widthAnchor.constraint(equalToConstant: 50),
            
            readTimeLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 8),
            readTimeLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
            
        ])
    }
    
    func configure(with article: PublicWelfareViewController.WelfareArticle) {
        titleLabel.text = article.title
        subtitleLabel.text = article.subtitle
        categoryLabel.text = article.category.rawValue
        categoryLabel.backgroundColor = UIColor(hex: article.category.color)
        readTimeLabel.text = article.readTime
        
        // 使用占位图片
        bgImageView.image = UIImage(named: article.imageName)
    }
}

// MARK: - WelfareSectionHeaderView
class WelfareSectionHeaderView: UITableViewHeaderFooterView {
    private let titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
} 
