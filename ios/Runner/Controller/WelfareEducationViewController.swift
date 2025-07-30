import UIKit

class WelfareEducationViewController: UIViewController {
    
    // MARK: - UI Components
    private var tableView: UITableView!
    
    // MARK: - Data
    private var educationTopics: [EducationTopic] = []
    
    // MARK: - Data Models
    struct EducationTopic {
        let id: String
        let title: String
        let subtitle: String
        let content: String
        let imageName: String
        let category: TopicCategory
        
        enum TopicCategory: String, CaseIterable {
            case basic = "基础知识"
            case health = "健康护理"
            case behavior = "行为训练"
            case rescue = "救助知识"
            case law = "法律法规"
            
            var color: String {
                switch self {
                case .basic: return "#4CAF50"
                case .health: return "#2196F3"
                case .behavior: return "#FF9800"
                case .rescue: return "#F44336"
                case .law: return "#9C27B0"
                }
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupNavigationBar()
        setupData()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor(hex: "#111111")
        
        title = "公益教育"
        
        // 隐藏系统返回按钮，使用自定义返回按钮
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(backTapped))
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupData() {
        educationTopics = [
            EducationTopic(
                id: "1",
                title: "动物福利的基本概念",
                subtitle: "了解什么是动物福利，为什么它很重要",
                content: """
                动物福利是指动物在生存环境中能够保持身体和心理健康的状态。良好的动物福利包括：
                
                • 生理福利：提供充足的食物、清洁的水源和适当的住所
                • 环境福利：提供舒适的生活环境，避免极端天气
                • 行为福利：允许动物表达自然行为
                • 心理福利：减少恐惧和痛苦，提供积极的情感体验
                • 社交福利：对于群居动物，提供社交互动的机会
                
                作为宠物主人，我们有责任确保我们的宠物享有良好的福利。这不仅是对动物的尊重，也是我们作为负责任主人的体现。
                """,
                imageName: "education_basic",
                category: .basic
            ),
            EducationTopic(
                id: "2",
                title: "宠物健康护理指南",
                subtitle: "日常护理和健康检查要点",
                content: """
                定期的健康护理是确保宠物健康的关键：
                
                日常护理：
                • 定期梳理毛发，保持清洁
                • 检查耳朵、眼睛和牙齿
                • 保持适当的运动量
                • 提供均衡的营养饮食
                
                健康检查：
                • 每年至少进行一次全面体检
                • 按时接种疫苗
                • 定期驱虫
                • 注意异常行为变化
                
                紧急情况识别：
                • 食欲不振或拒绝进食
                • 异常的精神状态
                • 呼吸困难
                • 持续呕吐或腹泻
                
                如果发现任何异常，请及时咨询兽医。
                """,
                imageName: "education_health",
                category: .health
            ),
            EducationTopic(
                id: "3",
                title: "宠物行为训练基础",
                subtitle: "科学训练方法，建立良好关系",
                content: """
                科学的训练方法能够帮助宠物建立良好的行为习惯：
                
                训练原则：
                • 使用正向强化，奖励好的行为
                • 保持一致性，避免混淆
                • 耐心和温和，避免惩罚
                • 适度的训练时间，避免过度疲劳
                
                基础训练项目：
                • 基本指令：坐下、等待、过来
                • 社交训练：与其他动物和人类友好相处
                • 环境适应：适应各种环境变化
                • 行为纠正：解决不良行为问题
                
                训练技巧：
                • 选择合适的训练时机
                • 使用适当的奖励方式
                • 逐步提高训练难度
                • 保持训练的趣味性
                
                记住，训练是一个持续的过程，需要主人的耐心和坚持。
                """,
                imageName: "education_behavior",
                category: .behavior
            ),
            EducationTopic(
                id: "4",
                title: "流浪动物救助指南",
                subtitle: "如何安全有效地帮助流浪动物",
                content: """
                遇到流浪动物时，我们可以这样帮助它们：
                
                安全第一：
                • 保持安全距离，避免直接接触
                • 观察动物状态，判断是否需要帮助
                • 如果动物受伤或生病，联系专业救助机构
                
                临时救助：
                • 提供食物和水（注意食物安全）
                • 提供临时庇护所
                • 保持环境清洁
                • 避免过度干预
                
                长期帮助：
                • 联系当地动物保护组织
                • 参与TNR（捕捉-绝育-放归）项目
                • 支持流浪动物救助站
                • 推广领养代替购买理念
                
                注意事项：
                • 不要随意投喂不适合的食物
                • 避免在公共场所大量投喂
                • 尊重动物的自然习性
                • 遵守当地相关法规
                """,
                imageName: "education_rescue",
                category: .rescue
            ),
            EducationTopic(
                id: "5",
                title: "动物保护法律法规",
                subtitle: "了解相关法律，保护动物权益",
                content: """
                了解动物保护相关法律法规，维护动物权益：
                
                主要法律条款：
                • 《动物防疫法》：规范动物防疫管理
                • 《野生动物保护法》：保护野生动物
                • 各地宠物管理条例：规范宠物饲养
                
                宠物主人责任：
                • 依法办理宠物登记
                • 按时接种疫苗
                • 文明养宠，不扰民
                • 承担宠物造成的损害责任
                
                动物福利保护：
                • 禁止虐待动物
                • 禁止遗弃宠物
                • 规范动物运输和交易
                • 保护工作动物权益
                
                举报和维权：
                • 发现虐待动物行为及时举报
                • 通过合法途径维护动物权益
                • 支持动物保护立法
                • 参与相关公益活动
                
                作为负责任的公民，我们应该了解并遵守相关法律法规，为动物保护贡献力量。
                """,
                imageName: "education_law",
                category: .law
            )
        ]
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
        tableView.register(EducationTopicCell.self, forCellReuseIdentifier: "EducationTopicCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension WelfareEducationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return educationTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EducationTopicCell", for: indexPath) as! EducationTopicCell
        let topic = educationTopics[indexPath.row]
        cell.configure(with: topic)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension WelfareEducationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let topic = educationTopics[indexPath.row]
        let vc = EducationTopicDetailViewController(topic: topic)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - EducationTopicCell
class EducationTopicCell: UITableViewCell {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let categoryLabel = UILabel()
    
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
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            categoryLabel.heightAnchor.constraint(equalToConstant: 16),
            categoryLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configure(with topic: WelfareEducationViewController.EducationTopic) {
        titleLabel.text = topic.title
        subtitleLabel.text = topic.subtitle
        categoryLabel.text = topic.category.rawValue
        categoryLabel.backgroundColor = UIColor(hex: topic.category.color)
    }
}

// MARK: - EducationTopicDetailViewController
class EducationTopicDetailViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var titleLabel: UILabel!
    private var contentLabel: UILabel!
    private var topic: WelfareEducationViewController.EducationTopic
    
    init(topic: WelfareEducationViewController.EducationTopic) {
        self.topic = topic
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupNavigationBar()
        setupUI()
        configureContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor(hex: "#111111")
        
        title = topic.title
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(backTapped))
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 8
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        contentLabel.textColor = UIColor(hex: "#333333")
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
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
        titleLabel.text = topic.title
        contentLabel.text = topic.content
    }
} 
