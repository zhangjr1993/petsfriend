import UIKit
import ObjectiveC

class PetHealthGuideViewController: UIViewController {
    
    // MARK: - UI Components
    private var tableView: UITableView!
    private var searchBar: UISearchBar!
    private var segmentedControl: UISegmentedControl!
    
    // MARK: - Data
    private var allGuides: [PetHealthGuide] = []
    private var filteredGuides: [PetHealthGuide] = []
    private var currentCategory: PetHealthGuide.HealthCategory = .disease
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
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor(hex: "#111111")
        
        title = "健康指南"
        
        // 隐藏系统返回按钮，使用自定义返回按钮
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(backTapped))
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupData() {
        allGuides = PetServiceData.shared.getPetHealthGuideData()
        filteredGuides = allGuides
        
        print("PetHealthGuideViewController: loaded \(allGuides.count) guides")
        for (index, guide) in allGuides.enumerated() {
            print("PetHealthGuideViewController: guide \(index): \(guide.title) - symptoms: \(guide.symptoms.count)")
        }
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "搜索健康问题..."
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
        let categories = PetHealthGuide.HealthCategory.allCases
        let titles = categories.map { $0.displayName }
        
        segmentedControl = UISegmentedControl(items: titles)
        segmentedControl.selectedSegmentIndex = 2 // 默认选择"疾病预防"
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
        tableView.register(HealthGuideCell.self, forCellReuseIdentifier: "HealthGuideCell")
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
        let categories = PetHealthGuide.HealthCategory.allCases
        currentCategory = categories[segmentedControl.selectedSegmentIndex]
        filterGuides()
    }
    
    private func filterGuides() {
        if isSearching {
            return
        }
        
        filteredGuides = allGuides.filter { $0.category == currentCategory }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension PetHealthGuideViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGuides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthGuideCell", for: indexPath) as! HealthGuideCell
        let guide = filteredGuides[indexPath.row]
        cell.configure(with: guide)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PetHealthGuideViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let guide = filteredGuides[indexPath.row]
        print("PetHealthGuideViewController: selected guide: \(guide.title)")
        print("PetHealthGuideViewController: guide symptoms: \(guide.symptoms)")
        print("PetHealthGuideViewController: guide causes: \(guide.causes)")
        print("PetHealthGuideViewController: guide treatments: \(guide.treatments)")
        print("PetHealthGuideViewController: guide prevention: \(guide.prevention)")
        
        let vc = HealthGuideDetailViewController()
        vc.guide = guide
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension PetHealthGuideViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filterGuides()
        } else {
            isSearching = true
            filteredGuides = PetServiceData.shared.searchHealthGuide(searchText)
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - HealthGuideCell
class HealthGuideCell: UITableViewCell {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let emergencyLevelLabel = UILabel()
    private let symptomsLabel = UILabel()
    
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
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        categoryLabel.font = UIFont.systemFont(ofSize: 12)
        categoryLabel.textColor = UIColor(hex: "#666666")
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(categoryLabel)
        
        emergencyLevelLabel.font = UIFont.systemFont(ofSize: 12)
        emergencyLevelLabel.textColor = .white
        emergencyLevelLabel.layer.cornerRadius = 8
        emergencyLevelLabel.layer.masksToBounds = true
        emergencyLevelLabel.textAlignment = .center
        emergencyLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(emergencyLevelLabel)
        
        symptomsLabel.font = UIFont.systemFont(ofSize: 14)
        symptomsLabel.textColor = UIColor(hex: "#666666")
        symptomsLabel.numberOfLines = 2
        symptomsLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(symptomsLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            emergencyLevelLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
            emergencyLevelLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            emergencyLevelLabel.widthAnchor.constraint(equalToConstant: 50),
            emergencyLevelLabel.heightAnchor.constraint(equalToConstant: 20),
            
            symptomsLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            symptomsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            symptomsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            symptomsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with guide: PetHealthGuide) {
        titleLabel.text = guide.title
        categoryLabel.text = guide.category.displayName
        emergencyLevelLabel.text = guide.emergencyLevel.displayName
        emergencyLevelLabel.backgroundColor = UIColor(hex: guide.emergencyLevel.color)
        symptomsLabel.text = "症状: " + guide.symptoms.joined(separator: "、")
    }
}

// MARK: - HealthGuideDetailViewController
class HealthGuideDetailViewController: UIViewController {
    var guide: PetHealthGuide?
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var titleLabel: UILabel!
    private var emergencyLevelLabel: UILabel!
    private var symptomsLabel: UILabel!
    private var causesLabel: UILabel!
    private var treatmentsLabel: UILabel!
    private var preventionLabel: UILabel!
    
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
        
        title = "健康指南详情"
        
        // 隐藏系统返回按钮，使用自定义返回按钮
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(backTapped))
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
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
        
        // 创建各个信息区域
        let emergencyLevelView = createInfoView(title: "紧急程度")
        let symptomsView = createInfoView(title: "症状表现")
        let causesView = createInfoView(title: "可能原因")
        let treatmentsView = createInfoView(title: "治疗方法")
        let preventionView = createInfoView(title: "预防措施")
        
        // 获取contentLabel引用
        emergencyLevelLabel = emergencyLevelView.subviews.last as? UILabel
        symptomsLabel = symptomsView.subviews.last as? UILabel
        causesLabel = causesView.subviews.last as? UILabel
        treatmentsLabel = treatmentsView.subviews.last as? UILabel
        preventionLabel = preventionView.subviews.last as? UILabel
        
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
            
            emergencyLevelView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            emergencyLevelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emergencyLevelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            symptomsView.topAnchor.constraint(equalTo: emergencyLevelView.bottomAnchor, constant: 16),
            symptomsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            symptomsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            causesView.topAnchor.constraint(equalTo: symptomsView.bottomAnchor, constant: 16),
            causesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            causesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            treatmentsView.topAnchor.constraint(equalTo: causesView.bottomAnchor, constant: 16),
            treatmentsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            treatmentsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            preventionView.topAnchor.constraint(equalTo: treatmentsView.bottomAnchor, constant: 16),
            preventionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            preventionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            preventionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createInfoView(title: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor(hex: "#333333")
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            contentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        // 保存contentLabel的引用以便后续设置内容
        objc_setAssociatedObject(containerView, "contentLabel", contentLabel, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return containerView
    }
    
    private func configureContent() {
        guard let guide = guide else { return }
        
        titleLabel.text = guide.title
        
        // 设置紧急程度
        emergencyLevelLabel?.text = guide.emergencyLevel.displayName
        emergencyLevelLabel?.textColor = UIColor(hex: guide.emergencyLevel.color)
        
        // 设置症状
        let symptomsText = guide.symptoms.map { "• \($0)" }.joined(separator: "\n")
        symptomsLabel?.text = symptomsText
        
        // 设置原因
        let causesText = guide.causes.map { "• \($0)" }.joined(separator: "\n")
        causesLabel?.text = causesText
        
        // 设置治疗
        let treatmentsText = guide.treatments.map { "• \($0)" }.joined(separator: "\n")
        treatmentsLabel?.text = treatmentsText
        
        // 设置预防
        let preventionText = guide.prevention.map { "• \($0)" }.joined(separator: "\n")
        preventionLabel?.text = preventionText
    }
} 
