import Foundation

// MARK: - 本地数据服务
class PetServiceData {
    static let shared = PetServiceData()
    
    private init() {}
    
    // MARK: - 宠物百科数据
    func getPetEncyclopediaData() -> [PetEncyclopedia] {
        return [
            PetEncyclopedia(
                id: "1",
                title: "新手养狗必读指南",
                category: .dog,
                content: """
                养狗是一项需要认真对待的责任，以下是新手养狗的基本要点：
                
                1. 选择合适的狗狗
                - 考虑家庭环境和生活方式
                - 了解不同品种的特点和需求
                - 选择适合的年龄和性格
                
                2. 准备必需品
                - 狗粮和食具
                - 舒适的狗窝
                - 牵引绳和项圈
                - 玩具和清洁用品
                
                3. 建立日常routine
                - 定时喂食和遛狗
                - 训练基本指令
                - 定期体检和疫苗接种
                
                4. 注意事项
                - 保持耐心和爱心
                - 及时处理健康问题
                - 建立良好的行为习惯
                """,
                imageName: "dog_guide",
                tags: ["新手", "养狗", "基础"],
                difficulty: .beginner,
                readTime: 8,
                isBookmarked: false
            ),
            
            PetEncyclopedia(
                id: "2",
                title: "猫咪行为解读大全",
                category: .cat,
                content: """
                猫咪的行为往往让主人困惑，这里为您详细解读：
                
                1. 尾巴语言
                - 竖起尾巴：表示友好和信任
                - 尾巴摆动：可能表示不安或准备攻击
                - 尾巴蓬松：表示害怕或愤怒
                
                2. 声音表达
                - 呼噜声：表示满足和放松
                - 喵喵叫：可能有需求或想引起注意
                - 嘶嘶声：表示威胁或警告
                
                3. 身体语言
                - 露肚子：表示信任，但不一定想被摸
                - 眨眼：表示友好和放松
                - 耳朵后贴：表示害怕或愤怒
                
                4. 常见行为
                - 磨爪：标记领地和保持爪子锋利
                - 舔毛：清洁和放松
                - 夜间活动：天性使然
                """,
                imageName: "cat_behavior",
                tags: ["行为", "猫咪", "解读"],
                difficulty: .intermediate,
                readTime: 12,
                isBookmarked: false
            ),
            
            PetEncyclopedia(
                id: "3",
                title: "宠物营养搭配科学",
                category: .general,
                content: """
                科学的营养搭配是宠物健康的基础：
                
                1. 基本营养素
                - 蛋白质：构建肌肉和组织
                - 脂肪：提供能量和必需脂肪酸
                - 碳水化合物：主要能量来源
                - 维生素和矿物质：维持生理功能
                
                2. 不同阶段的营养需求
                - 幼年期：高蛋白、高能量
                - 成年期：均衡营养
                - 老年期：易消化、低脂肪
                
                3. 特殊需求
                - 怀孕期：增加营养摄入
                - 疾病期：根据病情调整
                - 运动量大的宠物：增加能量
                
                4. 注意事项
                - 避免人类食物
                - 控制食量
                - 保持清洁的饮用水
                """,
                imageName: "pet_nutrition",
                tags: ["营养", "健康", "科学"],
                difficulty: .intermediate,
                readTime: 15,
                isBookmarked: false
            ),
            
            PetEncyclopedia(
                id: "4",
                title: "狗狗训练技巧进阶",
                category: .dog,
                content: """
                进阶训练技巧让您的狗狗更加优秀：
                
                1. 基础指令巩固
                - 坐、站、躺的精确控制
                - 召回训练的强化
                - 随行训练的完善
                
                2. 高级技能训练
                - 障碍物训练
                - 搜索训练
                - 护卫训练
                
                3. 训练方法
                - 正向强化法
                - 点击器训练
                - 目标训练法
                
                4. 常见问题解决
                - 注意力不集中
                - 训练进度停滞
                - 行为反复
                """,
                imageName: "dog_training",
                tags: ["训练", "技巧", "进阶"],
                difficulty: .advanced,
                readTime: 20,
                isBookmarked: false
            ),
            
            PetEncyclopedia(
                id: "5",
                title: "猫咪健康护理手册",
                category: .cat,
                content: """
                全面的猫咪健康护理指南：
                
                1. 日常护理
                - 梳毛和清洁
                - 指甲修剪
                - 耳朵和眼睛清洁
                - 牙齿护理
                
                2. 健康监测
                - 体重管理
                - 食欲观察
                - 精神状态评估
                - 排泄物检查
                
                3. 预防保健
                - 定期疫苗接种
                - 驱虫处理
                - 体检安排
                - 绝育手术
                
                4. 紧急情况处理
                - 识别紧急症状
                - 基本急救知识
                - 联系兽医的时机
                """,
                imageName: "cat_health",
                tags: ["健康", "护理", "手册"],
                difficulty: .intermediate,
                readTime: 18,
                isBookmarked: false
            )
        ]
    }
    
    // MARK: - 健康指南数据
    func getPetHealthGuideData() -> [PetHealthGuide] {
        return [
            PetHealthGuide(
                id: "1",
                title: "狗狗呕吐的常见原因及处理",
                category: .disease,
                symptoms: ["呕吐", "食欲不振", "精神萎靡", "腹部不适"],
                causes: ["饮食不当", "肠胃炎", "寄生虫感染", "中毒"],
                treatments: ["禁食12-24小时", "少量多次喂水", "清淡饮食", "及时就医"],
                prevention: ["规律饮食", "避免垃圾食品", "定期驱虫", "保持环境清洁"],
                emergencyLevel: .medium,
                imageName: "dog_vomit"
            ),
            
            PetHealthGuide(
                id: "2",
                title: "猫咪拉肚子的紧急处理",
                category: .emergency,
                symptoms: ["腹泻", "食欲下降", "脱水", "精神不振"],
                causes: ["食物过敏", "病毒感染", "寄生虫", "应激反应"],
                treatments: ["补充水分", "调整饮食", "使用益生菌", "就医检查"],
                prevention: ["优质猫粮", "定期驱虫", "减少应激", "保持卫生"],
                emergencyLevel: .high,
                imageName: "cat_diarrhea"
            ),
            
            PetHealthGuide(
                id: "3",
                title: "宠物皮肤病的识别与治疗",
                category: .disease,
                symptoms: ["瘙痒", "脱毛", "红肿", "皮屑"],
                causes: ["过敏", "真菌感染", "寄生虫", "内分泌失调"],
                treatments: ["局部用药", "口服药物", "药浴", "环境消毒"],
                prevention: ["定期清洁", "营养均衡", "避免过敏源", "定期体检"],
                emergencyLevel: .low,
                imageName: "pet_skin"
            ),
            
            PetHealthGuide(
                id: "4",
                title: "宠物中暑的急救措施",
                category: .emergency,
                symptoms: ["呼吸急促", "体温升高", "精神萎靡", "呕吐"],
                causes: ["高温环境", "运动过度", "通风不良", "缺水"],
                treatments: ["移至阴凉处", "降温处理", "补充水分", "立即就医"],
                prevention: ["避免高温外出", "充足饮水", "通风环境", "适度运动"],
                emergencyLevel: .critical,
                imageName: "pet_heatstroke"
            ),
            
            PetHealthGuide(
                id: "5",
                title: "宠物营养缺乏的预防",
                category: .nutrition,
                symptoms: ["毛发干枯", "体重下降", "精神不振", "免疫力低下"],
                causes: ["饮食单一", "消化吸收不良", "疾病影响", "年龄因素"],
                treatments: ["调整饮食", "补充营养", "治疗原发病", "定期检查"],
                prevention: ["均衡营养", "优质食物", "定期体检", "适量运动"],
                emergencyLevel: .low,
                imageName: "pet_nutrition"
            )
        ]
    }
    
    // MARK: - AI快捷问题数据
    func getAIQuickQuestions() -> [AIQuickQuestion] {
        return [
            AIQuickQuestion(id: "1", question: "我的狗狗总是乱叫怎么办？", category: .behavior, isPopular: true),
            AIQuickQuestion(id: "2", question: "猫咪不吃东西是什么原因？", category: .health, isPopular: true),
            AIQuickQuestion(id: "3", question: "如何训练狗狗上厕所？", category: .training, isPopular: false),
            AIQuickQuestion(id: "4", question: "宠物疫苗需要多久打一次？", category: .health, isPopular: true),
            AIQuickQuestion(id: "5", question: "狗狗拉肚子应该吃什么药？", category: .health, isPopular: false),
            AIQuickQuestion(id: "6", question: "猫咪为什么总是抓沙发？", category: .behavior, isPopular: true),
            AIQuickQuestion(id: "7", question: "如何给宠物洗澡？", category: .care, isPopular: false),
            AIQuickQuestion(id: "8", question: "宠物挑食怎么办？", category: .nutrition, isPopular: true),
            AIQuickQuestion(id: "9", question: "狗狗护食怎么纠正？", category: .training, isPopular: false),
            AIQuickQuestion(id: "10", question: "猫咪发情期怎么处理？", category: .care, isPopular: true)
        ]
    }
    
    // MARK: - 获取分类数据
    func getEncyclopediaByCategory(_ category: PetEncyclopedia.PetCategory) -> [PetEncyclopedia] {
        return getPetEncyclopediaData().filter { $0.category == category }
    }
    
    func getHealthGuideByCategory(_ category: PetHealthGuide.HealthCategory) -> [PetHealthGuide] {
        return getPetHealthGuideData().filter { $0.category == category }
    }
    
    func getQuestionsByCategory(_ category: AIQuickQuestion.QuestionCategory) -> [AIQuickQuestion] {
        return getAIQuickQuestions().filter { $0.category == category }
    }
    
    // MARK: - 搜索功能
    func searchEncyclopedia(_ keyword: String) -> [PetEncyclopedia] {
        let data = getPetEncyclopediaData()
        return data.filter { 
            $0.title.contains(keyword) || 
            $0.content.contains(keyword) || 
            $0.tags.contains { $0.contains(keyword) }
        }
    }
    
    func searchHealthGuide(_ keyword: String) -> [PetHealthGuide] {
        let data = getPetHealthGuideData()
        return data.filter { 
            $0.title.contains(keyword) || 
            $0.symptoms.contains { $0.contains(keyword) } ||
            $0.causes.contains { $0.contains(keyword) }
        }
    }
} 