import UIKit

class WelfareArticleDetailViewController: UIViewController {
    
    // MARK: - UI Components
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var contentLabel: UILabel!
    private var categoryLabel: UILabel!
    private var readTimeLabel: UILabel!
    private var hotLabel: UILabel!
    
    // MARK: - Data
    private var article: PublicWelfareViewController.WelfareArticle
    
    // MARK: - Article Content
    private let articleContents: [String: String] = [
        "1": """
        陪伴犬，顾名思义，就是专门陪伴人类的犬类。它们不仅仅是宠物，更是孤独老人的温暖守护者，为独居老人带来精神慰藉和生活帮助。
        
        陪伴犬的特殊价值：
        
        1. 精神慰藉
        陪伴犬能够为独居老人提供情感支持，减少孤独感和抑郁情绪。它们的存在让老人感受到被需要和被爱的感觉，这种情感联系对心理健康非常重要。
        
        2. 生活陪伴
        陪伴犬会跟随老人一起生活，成为他们日常生活中不可或缺的伙伴。无论是散步、看电视还是休息，都有它们的陪伴，让生活不再孤单。
        
        3. 健康促进
        照顾陪伴犬需要一定的体力活动，如遛狗、喂食等，这些活动能够促进老人的身体运动，保持身体健康。同时，与狗狗的互动也能降低血压，减少心脏病风险。
        
        4. 社交桥梁
        陪伴犬能够成为老人与他人交流的桥梁。遛狗时遇到其他狗主人，可以自然地展开交流，扩大社交圈子，增加社会参与度。
        
        陪伴犬的选择标准：
        
        • 性格温顺：选择性格温和、不具攻击性的犬种
        • 体型适中：适合老人照顾的体型，既不会太小容易受伤，也不会太大难以控制
        • 健康良好：确保狗狗身体健康，定期进行体检和疫苗接种
        • 训练有素：经过基本训练的狗狗更容易与老人相处
        
        常见的陪伴犬品种：
        
        • 金毛寻回犬：性格温和，对老人和孩子都很友好
        • 拉布拉多：聪明听话，容易训练
        • 比熊犬：体型小巧，不掉毛，适合室内饲养
        • 贵宾犬：智商高，不掉毛，适合过敏体质的人
        
        陪伴犬的照顾要点：
        
        • 定期体检：确保狗狗身体健康
        • 适当运动：根据狗狗的年龄和健康状况安排运动量
        • 营养均衡：提供适合的狗粮和营养补充
        • 情感关怀：给予足够的关注和爱护
        
        陪伴犬的意义：
        
        陪伴犬不仅仅是宠物，更是老人的精神支柱和生活伙伴。它们用无条件的爱和忠诚，为孤独的老人带来温暖和希望。在老龄化社会日益严重的今天，陪伴犬的作用越来越重要。
        
        我们应该：
        • 尊重和关爱陪伴犬
        • 支持陪伴犬项目的发展
        • 为需要陪伴的老人提供帮助
        • 推广科学养犬理念
        
        让我们共同努力，让更多的老人能够享受到陪伴犬带来的温暖和快乐。
        """,
        
        "2": """
        导盲犬，是经过专业训练的工作犬，专门为视障人士提供导航服务。它们不仅是视障人士的明亮双眼，更是他们生活中不可或缺的伙伴和助手。
        
        导盲犬的历史：
        
        导盲犬的历史可以追溯到第一次世界大战期间。当时，德国医生格哈德·斯特雷利茨博士开始训练牧羊犬来帮助在战争中失明的士兵。这一理念很快传播到其他国家，并发展成为今天的导盲犬服务。
        
        导盲犬的训练过程：
        
        1. 幼犬期（0-12个月）
        导盲犬从出生开始就接受特殊照顾。在幼犬期，它们被寄养在志愿者家庭中，学习基本的社交技能和家庭生活规范。
        
        2. 基础训练期（12-18个月）
        这个阶段，导盲犬开始接受专业训练，学习基本的服从指令，如坐下、等待、跟随等。同时，它们还要学会在各种环境中保持冷静和专注。
        
        3. 专业训练期（18-24个月）
        这是最重要的训练阶段，导盲犬需要掌握：
        • 直线行走：在无障碍的路面上保持直线行走
        • 障碍物识别：识别并避开各种障碍物
        • 台阶识别：识别台阶的上下方向
        • 交通信号：理解交通信号和车辆声音
        • 目的地导航：记住常用路线
        
        4. 配对训练期（2-4周）
        导盲犬与视障人士进行配对训练，学习如何配合主人的行走习惯和需求。这个阶段需要双方建立信任和默契。
        
        导盲犬的工作技能：
        
        • 智能导航：能够记住常用路线，带领主人到达目的地
        • 障碍识别：识别并避开路上的障碍物，如台阶、坑洼、车辆等
        • 交通判断：根据声音和气味判断交通状况，确保安全过马路
        • 环境适应：适应各种环境，如商场、公交、地铁等
        • 紧急避险：在危险情况下能够保护主人安全
        
        导盲犬的品种选择：
        
        常见的导盲犬品种包括：
        • 拉布拉多寻回犬：性格温和，学习能力强
        • 金毛寻回犬：友善忠诚，工作热情高
        • 德国牧羊犬：聪明勇敢，工作能力强
        • 黄金猎犬：温顺听话，适合家庭生活
        
        导盲犬与主人的关系：
        
        导盲犬与视障人士之间建立的是深厚的信任关系。它们不仅是工作伙伴，更是生活中的朋友和家人。这种关系建立在相互理解和尊重的基础上。
        
        导盲犬的福利保障：
        
        • 健康保障：定期体检，及时治疗疾病
        • 生活保障：提供舒适的生活环境和营养饮食
        • 工作保障：合理安排工作时间，避免过度疲劳
        • 退休保障：工作期满后享受退休生活
        
        社会对导盲犬的支持：
        
        • 法律保障：许多国家都有保护导盲犬的法律法规
        • 社会接纳：公共场所对导盲犬开放，提供便利服务
        • 公众教育：提高公众对导盲犬的认知和理解
        • 志愿服务：志愿者参与导盲犬训练和照顾工作
        
        导盲犬的意义：
        
        导盲犬为视障人士带来了自由和独立。它们不仅帮助视障人士安全出行，更重要的是让他们重新获得生活的信心和勇气。导盲犬的存在，让视障人士能够像正常人一样生活和工作。
        
        我们应该：
        • 尊重导盲犬的工作
        • 为导盲犬和视障人士提供便利
        • 支持导盲犬训练项目
        • 提高公众的认知和理解
        
        让我们共同努力，为视障人士创造更加无障碍的生活环境。
        """,
        
        "3": """
        警犬，是经过专业训练的工作犬，专门协助执法人员执行各种任务。它们是忠诚的执法伙伴，在维护社会治安、保护人民安全方面发挥着重要作用。
        
        警犬的历史发展：
        
        警犬的使用历史可以追溯到古代。在古罗马时期，就有使用犬类进行巡逻和守卫的记录。现代警犬制度起源于19世纪末的比利时，当时开始系统性地训练犬类用于警务工作。
        
        警犬的主要类型：
        
        1. 追踪犬
        追踪犬具有敏锐的嗅觉，能够追踪犯罪嫌疑人的气味轨迹。它们常用于：
        • 追踪逃犯
        • 寻找失踪人员
        • 追踪犯罪现场遗留的气味
        
        2. 搜爆犬
        搜爆犬经过特殊训练，能够识别各种爆炸物的气味。它们主要用于：
        • 安全检查
        • 爆炸物检测
        • 反恐行动
        
        3. 缉毒犬
        缉毒犬专门训练识别毒品的气味，用于：
        • 毒品查缉
        • 边境检查
        • 机场安检
        
        4. 护卫犬
        护卫犬具有保护能力，用于：
        • 保护执法人员
        • 控制暴力场面
        • 维护现场秩序
        
        警犬的训练过程：
        
        1. 幼犬选拔
        警犬的选拔从幼犬开始，主要考察：
        • 品种血统：选择适合的犬种
        • 性格特征：勇敢、忠诚、聪明
        • 身体条件：健康、强壮、耐力好
        
        2. 基础训练
        基础训练包括：
        • 服从训练：学习基本指令
        • 体能训练：提高身体素质和耐力
        • 社交训练：适应各种环境和人群
        
        3. 专业训练
        根据不同的工作类型进行专业训练：
        • 追踪训练：提高嗅觉敏感度
        • 搜索训练：学习搜索技巧
        • 攻击训练：掌握控制技能
        
        4. 实战训练
        在模拟环境中进行实战训练，提高应对各种情况的能力。
        
        警犬的工作技能：
        
        • 嗅觉追踪：利用敏锐的嗅觉追踪目标
        • 物品搜索：在复杂环境中搜索特定物品
        • 人员控制：协助执法人员控制暴力人员
        • 现场保护：保护犯罪现场和证据
        • 公众安全：维护公共秩序和安全
        
        警犬的品种选择：
        
        常见的警犬品种包括：
        • 德国牧羊犬：全能型警犬，适应性强
        • 比利时牧羊犬：聪明敏捷，工作热情高
        • 罗威纳犬：强壮勇敢，保护能力强
        • 杜宾犬：聪明忠诚，训练效果好
        
        警犬与训导员的关系：
        
        警犬与训导员之间建立的是深厚的信任和默契关系。他们不仅是工作伙伴，更是生活中的朋友。这种关系需要长期的培养和维护。
        
        警犬的福利保障：
        
        • 健康管理：定期体检，及时治疗
        • 生活保障：提供良好的生活条件
        • 工作保障：合理安排工作时间
        • 退休保障：工作期满后妥善安置
        
        警犬的社会价值：
        
        • 维护治安：协助警方维护社会治安
        • 保护安全：保护人民生命财产安全
        • 提高效率：提高执法工作效率
        • 威慑犯罪：对犯罪分子起到威慑作用
        
        警犬面临的挑战：
        
        • 训练成本高：警犬训练需要大量时间和资源
        • 工作压力大：警犬工作环境复杂，压力较大
        • 公众认知：部分公众对警犬存在误解
        • 技术发展：新技术可能替代部分警犬工作
        
        未来发展方向：
        
        • 技术融合：结合新技术提高工作效率
        • 品种优化：培育更适合的警犬品种
        • 训练改进：采用更科学的训练方法
        • 公众教育：提高公众对警犬的认知
        
        我们应该：
        • 尊重警犬的工作
        • 支持警犬训练项目
        • 提高公众认知
        • 为警犬提供保障
        
        警犬是人类最忠诚的朋友和伙伴，它们用生命和忠诚为维护社会安全贡献力量。让我们共同珍惜和爱护这些特殊的英雄。
        """,
        
        "4": """
        搜救犬，是经过专业训练的工作犬，专门用于在灾难和紧急情况下寻找失踪人员。它们是灾难中的生命守护者，在无数次救援行动中拯救了无数生命。
        
        搜救犬的历史：
        
        搜救犬的历史可以追溯到古代。在战争中，犬类就被用于寻找伤员。现代搜救犬制度起源于20世纪初的瑞士，当时开始系统性地训练犬类用于山地救援。
        
        搜救犬的主要类型：
        
        1. 山地搜救犬
        专门用于山地和野外搜救，能够：
        • 在复杂地形中搜索
        • 适应恶劣天气条件
        • 长时间持续工作
        
        2. 废墟搜救犬
        专门用于地震、爆炸等灾难后的废墟搜救，能够：
        • 在废墟中搜索幸存者
        • 识别生命迹象
        • 协助救援人员定位
        
        3. 水域搜救犬
        专门用于水上搜救，能够：
        • 在水面搜索落水者
        • 协助水上救援
        • 寻找水下目标
        
        4. 雪崩搜救犬
        专门用于雪崩搜救，能够：
        • 在雪地中搜索被埋人员
        • 适应极寒环境
        • 快速定位目标
        
        搜救犬的训练过程：
        
        1. 幼犬选拔
        搜救犬的选拔标准：
        • 品种血统：选择适合的犬种
        • 性格特征：勇敢、坚韧、专注
        • 身体条件：健康、强壮、耐力好
        • 嗅觉能力：嗅觉敏锐，追踪能力强
        
        2. 基础训练
        基础训练包括：
        • 服从训练：学习基本指令
        • 体能训练：提高身体素质和耐力
        • 环境适应：适应各种恶劣环境
        
        3. 专业训练
        专业训练包括：
        • 气味追踪：提高嗅觉敏感度
        • 搜索技巧：学习各种搜索方法
        • 救援技能：掌握救援相关技能
        
        4. 实战训练
        在模拟灾难环境中进行实战训练，提高应对各种情况的能力。
        
        搜救犬的工作技能：
        
        • 气味追踪：利用敏锐的嗅觉追踪目标
        • 区域搜索：在指定区域内系统搜索
        • 生命探测：识别生命迹象
        • 信号传递：向训导员传递发现信息
        • 救援协助：协助救援人员开展救援
        
        搜救犬的品种选择：
        
        常见的搜救犬品种包括：
        • 德国牧羊犬：全能型搜救犬，适应性强
        • 拉布拉多寻回犬：性格温和，工作热情高
        • 金毛寻回犬：友善忠诚，耐力好
        • 圣伯纳犬：体型大，适合雪地救援
        
        搜救犬的工作环境：
        
        搜救犬需要在各种恶劣环境中工作：
        • 地震废墟：危险复杂的环境
        • 山地野外：地形复杂，天气多变
        • 水域环境：水流湍急，能见度低
        • 雪地环境：极寒天气，积雪深厚
        
        搜救犬的装备：
        
        搜救犬需要配备专业装备：
        • 搜救背心：保护身体，携带装备
        • 照明设备：在黑暗环境中工作
        • 通讯设备：与训导员保持联系
        • 防护装备：保护脚掌和身体
        
        搜救犬的贡献：
        
        搜救犬在无数次救援行动中做出了巨大贡献：
        • 2008年汶川地震：搜救犬协助救援人员找到大量幸存者
        • 2010年玉树地震：搜救犬在恶劣环境中坚持工作
        • 2013年雅安地震：搜救犬快速响应，及时救援
        • 各种山地救援：搜救犬成功救助无数遇险人员
        
        搜救犬面临的挑战：
        
        • 工作环境恶劣：需要在极端环境中工作
        • 工作压力大：救援任务紧急，压力较大
        • 训练成本高：需要大量时间和资源投入
        • 技术发展：新技术可能影响搜救犬的作用
        
        搜救犬的福利保障：
        
        • 健康管理：定期体检，及时治疗
        • 生活保障：提供良好的生活条件
        • 工作保障：合理安排工作时间
        • 退休保障：工作期满后妥善安置
        
        社会对搜救犬的支持：
        
        • 法律保障：保护搜救犬的法律法规
        • 社会认可：公众对搜救犬的认可和尊重
        • 技术支持：为搜救犬提供技术支持
        • 志愿服务：志愿者参与搜救犬训练和照顾
        
        搜救犬的意义：
        
        搜救犬是人类最忠诚的朋友和伙伴，它们在灾难中挺身而出，用生命和忠诚守护着人类的生命安全。它们的存在，让无数人在绝望中看到了希望。
        
        我们应该：
        • 尊重搜救犬的工作
        • 支持搜救犬训练项目
        • 为搜救犬提供保障
        • 提高公众认知
        
        让我们共同珍惜和爱护这些特殊的英雄，它们用生命和忠诚为人类的安全贡献力量。
        """
    ]
    
    // MARK: - Lifecycle
    init(article: PublicWelfareViewController.WelfareArticle) {
        self.article = article
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
        
        title = "文章详情"
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(backTapped))
        
        // 添加举报按钮
        let reportButton = UIBarButtonItem(image: UIImage(systemName: "exclamationmark.triangle"), style: .plain, target: self, action: #selector(reportButtonTapped))
        navigationItem.rightBarButtonItem = reportButton
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func reportButtonTapped() {
        let reportVC = ReportViewController()
        reportVC.modalPresentationStyle = .overFullScreen
        reportVC.onReportSuccess = { [weak self] in
            self?.view.makeToast("举报成功，感谢你的宝贵意见")
        }
        present(reportVC, animated: true, completion: nil)
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
        
        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = UIColor(hex: "#666666")
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        categoryLabel = UILabel()
        categoryLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        categoryLabel.textColor = .white
        categoryLabel.textAlignment = .center
        categoryLabel.layer.cornerRadius = 8
        categoryLabel.layer.masksToBounds = true
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)
        
        readTimeLabel = UILabel()
        readTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        readTimeLabel.textColor = UIColor(hex: "#999999")
        readTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(readTimeLabel)
        
        hotLabel = UILabel()
        hotLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        hotLabel.textColor = .white
        hotLabel.backgroundColor = UIColor(hex: "#FF5722")
        hotLabel.text = "热门"
        hotLabel.textAlignment = .center
        hotLabel.layer.cornerRadius = 6
        hotLabel.layer.masksToBounds = true
        hotLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hotLabel)
        
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
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            categoryLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            categoryLabel.heightAnchor.constraint(equalToConstant: 20),
            categoryLabel.widthAnchor.constraint(equalToConstant: 60),
            
            readTimeLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 12),
            readTimeLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
            
            hotLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            hotLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
            hotLabel.heightAnchor.constraint(equalToConstant: 16),
            hotLabel.widthAnchor.constraint(equalToConstant: 32),
            
            contentLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureContent() {
        titleLabel.text = article.title
        subtitleLabel.text = article.subtitle
        categoryLabel.text = article.category.rawValue
        categoryLabel.backgroundColor = UIColor(hex: article.category.color)
        readTimeLabel.text = article.readTime
        hotLabel.isHidden = !article.isHot
        
        // 获取文章内容
        let content = articleContents[article.id] ?? "文章内容正在加载中..."
        contentLabel.text = content
    }
} 