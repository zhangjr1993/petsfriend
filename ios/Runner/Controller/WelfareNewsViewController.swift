import UIKit

class WelfareNewsViewController: UIViewController {
    
    // MARK: - UI Components
    private var tableView: UITableView!
    
    // MARK: - Data
    private var newsItems: [NewsItem] = []
    
    // MARK: - Data Models
    struct NewsItem {
        let id: String
        let title: String
        let subtitle: String
        let content: String
        let imageName: String
        let publishDate: String
        let category: NewsCategory
        let isImportant: Bool
        
        enum NewsCategory: String, CaseIterable {
            case policy = "政策动态"
            case rescue = "救助故事"
            case event = "公益活动"
            case science = "科学研究"
            case awareness = "公众教育"
            
            var color: String {
                switch self {
                case .policy: return "#2196F3"
                case .rescue: return "#4CAF50"
                case .event: return "#FF9800"
                case .science: return "#9C27B0"
                case .awareness: return "#607D8B"
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
        
        title = "公益资讯"
        
        // 隐藏系统返回按钮，使用自定义返回按钮
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(backTapped))
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupData() {
        newsItems = [
            NewsItem(
                id: "1",
                title: "新版《动物防疫法》正式实施",
                subtitle: "加强动物疫病防控，保障公共卫生安全",
                content: """
                2021年5月1日，新修订的《中华人民共和国动物防疫法》正式实施。新法在多个方面进行了重要改进：
                
                主要变化：
                • 强化了动物疫病防控责任
                • 完善了动物防疫制度
                • 加强了动物检疫管理
                • 规范了动物诊疗活动
                • 明确了法律责任
                
                对宠物主人的影响：
                • 宠物需要定期接种疫苗
                • 携带宠物出行需要相关证明
                • 宠物诊疗需要选择有资质的机构
                • 发现宠物异常要及时报告
                
                新法的实施标志着我国动物防疫工作进入新阶段，为保障公共卫生安全和动物健康提供了法律保障。
                
                作为宠物主人，我们应该：
                • 了解相关法律法规
                • 积极配合防疫工作
                • 承担起宠物防疫责任
                • 为构建健康的人宠环境贡献力量
                """,
                imageName: "news_policy",
                publishDate: "2024-01-15",
                category: .policy,
                isImportant: true
            ),
            NewsItem(
                id: "2",
                title: "流浪猫救助站成功救助500只流浪猫",
                subtitle: "爱心志愿者团队为流浪动物提供温暖家园",
                content: """
                近日，某市流浪猫救助站传来好消息，该站成功救助了第500只流浪猫，为这些无家可归的小生命提供了温暖的家园。
                
                救助站的故事：
                • 成立于2020年，由爱心志愿者自发组织
                • 目前有30名固定志愿者
                • 已为500只流浪猫提供救助
                • 成功为300只猫找到新家庭
                
                救助流程：
                • 发现流浪猫后进行健康检查
                • 提供医疗救治和护理
                • 进行绝育手术控制数量
                • 寻找合适的领养家庭
                • 定期回访确保适应良好
                
                志愿者的心声：
                "每一只猫都有自己的故事，我们希望通过努力，让更多流浪猫找到温暖的家。虽然工作很辛苦，但看到它们健康快乐的样子，一切都值得。"
                
                社会影响：
                • 提高了公众对流浪动物的关注
                • 推广了科学救助理念
                • 建立了完善的救助体系
                • 为其他地区提供了参考模式
                
                未来计划：
                • 扩大救助站规模
                • 增加志愿者培训
                • 建立更多合作网络
                • 推广TNR项目
                """,
                imageName: "news_rescue",
                publishDate: "2024-01-12",
                category: .rescue,
                isImportant: false
            ),
            NewsItem(
                id: "3",
                title: "全国动物保护宣传周启动",
                subtitle: "倡导文明养宠，共建和谐社区",
                content: """
                2024年全国动物保护宣传周正式启动，本次活动以"文明养宠，和谐社区"为主题，在全国各地开展系列宣传活动。
                
                活动内容：
                • 文明养宠知识讲座
                • 宠物健康义诊服务
                • 流浪动物救助展示
                • 动物保护法律咨询
                • 宠物友好社区建设
                
                活动亮点：
                • 邀请专家进行专业指导
                • 组织志愿者参与服务
                • 展示先进救助设备
                • 分享成功救助案例
                • 推广科学养宠理念
                
                参与方式：
                • 线上观看直播讲座
                • 线下参与现场活动
                • 分享养宠经验
                • 支持救助工作
                • 传播保护理念
                
                预期效果：
                • 提高公众保护意识
                • 改善社区养宠环境
                • 减少流浪动物数量
                • 促进人宠和谐相处
                • 推动相关立法完善
                
                让我们一起行动起来，为动物保护事业贡献力量！
                """,
                imageName: "news_event",
                publishDate: "2024-01-10",
                category: .event,
                isImportant: true
            ),
            NewsItem(
                id: "4",
                title: "研究发现：宠物陪伴有助于心理健康",
                subtitle: "科学证实宠物对人类心理健康的积极影响",
                content: """
                最新科学研究表明，宠物陪伴对人类心理健康具有显著的积极影响，这一发现为动物辅助治疗提供了科学依据。
                
                研究背景：
                • 由多所知名大学联合开展
                • 涉及1000多个家庭样本
                • 持续跟踪研究3年
                • 采用多种评估方法
                
                主要发现：
                • 宠物陪伴能降低压力激素水平
                • 有助于缓解焦虑和抑郁症状
                • 提高生活满意度和幸福感
                • 增强社交能力和同理心
                • 改善睡眠质量
                
                作用机制：
                • 抚摸宠物能释放催产素
                • 陪伴减少孤独感
                • 照顾宠物增加责任感
                • 互动促进运动锻炼
                • 情感支持提供安慰
                
                应用前景：
                • 医院引入治疗犬
                • 学校开展动物教育
                • 养老院推广陪伴宠物
                • 心理咨询结合动物辅助
                • 社区建设宠物友好环境
                
                专家建议：
                • 根据个人情况选择合适的宠物
                • 确保能够承担照顾责任
                • 定期进行健康检查
                • 建立良好的互动关系
                • 尊重宠物的自然习性
                
                这一研究为推广宠物陪伴和动物辅助治疗提供了重要支持。
                """,
                imageName: "news_science",
                publishDate: "2024-01-08",
                category: .science,
                isImportant: false
            ),
            NewsItem(
                id: "5",
                title: "儿童动物保护教育课程正式启动",
                subtitle: "从小培养爱护动物的意识",
                content: """
                为了从小培养儿童爱护动物的意识，某市教育部门正式启动了儿童动物保护教育课程，将在全市小学推广实施。
                
                课程设置：
                • 动物基础知识介绍
                • 动物福利概念普及
                • 宠物饲养责任教育
                • 野生动物保护知识
                • 动物救助技能培训
                
                教学特色：
                • 采用互动式教学方法
                • 结合多媒体教学资源
                • 邀请专家进行指导
                • 组织实地参观活动
                • 开展主题实践活动
                
                课程目标：
                • 培养爱护动物的意识
                • 了解动物保护的重要性
                • 学会科学对待动物
                • 承担保护动物的责任
                • 传播动物保护理念
                
                实施计划：
                • 先在试点学校开展
                • 逐步推广到全市
                • 培训专业教师队伍
                • 开发配套教材资源
                • 建立评估反馈机制
                
                社会反响：
                • 家长普遍支持认可
                • 学生参与积极性高
                • 专家给予高度评价
                • 媒体广泛关注报道
                • 其他地区表示借鉴
                
                未来展望：
                • 扩大课程覆盖范围
                • 完善教学内容体系
                • 建立长期跟踪机制
                • 推广成功经验模式
                • 推动相关立法支持
                
                儿童是未来的希望，从小培养他们的动物保护意识，将为构建和谐的人宠环境奠定坚实基础。
                """,
                imageName: "news_education",
                publishDate: "2024-01-05",
                category: .awareness,
                isImportant: true
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
        tableView.register(NewsItemCell.self, forCellReuseIdentifier: "NewsItemCell")
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
extension WelfareNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell", for: indexPath) as! NewsItemCell
        let newsItem = newsItems[indexPath.row]
        cell.configure(with: newsItem)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension WelfareNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newsItem = newsItems[indexPath.row]
        let vc = NewsItemDetailViewController(newsItem: newsItem)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - NewsItemCell
class NewsItemCell: UITableViewCell {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let dateLabel = UILabel()
    private let importantLabel = UILabel()
    
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
        
        dateLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        dateLabel.textColor = UIColor(hex: "#999999")
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dateLabel)
        
        importantLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        importantLabel.textColor = .white
        importantLabel.backgroundColor = UIColor(hex: "#FF5722")
        importantLabel.text = "重要"
        importantLabel.textAlignment = .center
        importantLabel.layer.cornerRadius = 6
        importantLabel.layer.masksToBounds = true
        importantLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(importantLabel)
        
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
            categoryLabel.widthAnchor.constraint(equalToConstant: 60),
            
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            dateLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
            
            importantLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            importantLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            importantLabel.heightAnchor.constraint(equalToConstant: 16),
            importantLabel.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with newsItem: WelfareNewsViewController.NewsItem) {
        titleLabel.text = newsItem.title
        subtitleLabel.text = newsItem.subtitle
        categoryLabel.text = newsItem.category.rawValue
        categoryLabel.backgroundColor = UIColor(hex: newsItem.category.color)
        dateLabel.text = newsItem.publishDate
        importantLabel.isHidden = !newsItem.isImportant
    }
}

// MARK: - NewsItemDetailViewController
class NewsItemDetailViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var titleLabel: UILabel!
    private var contentLabel: UILabel!
    private var dateLabel: UILabel!
    private var categoryLabel: UILabel!
    private var newsItem: WelfareNewsViewController.NewsItem
    
    init(newsItem: WelfareNewsViewController.NewsItem) {
        self.newsItem = newsItem
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
        
        title = "资讯详情"
        
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
        
        categoryLabel = UILabel()
        categoryLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        categoryLabel.textColor = .white
        categoryLabel.textAlignment = .center
        categoryLabel.layer.cornerRadius = 8
        categoryLabel.layer.masksToBounds = true
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)
        
        dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dateLabel.textColor = UIColor(hex: "#999999")
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        
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
            
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            categoryLabel.heightAnchor.constraint(equalToConstant: 20),
            categoryLabel.widthAnchor.constraint(equalToConstant: 80),
            
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureContent() {
        titleLabel.text = newsItem.title
        categoryLabel.text = newsItem.category.rawValue
        categoryLabel.backgroundColor = UIColor(hex: newsItem.category.color)
        dateLabel.text = newsItem.publishDate
        contentLabel.text = newsItem.content
    }
} 
