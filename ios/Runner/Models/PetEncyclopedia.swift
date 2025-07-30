import Foundation

// MARK: - 宠物百科数据模型
struct PetEncyclopedia: Codable {
    let id: String
    let title: String
    let category: PetCategory
    let content: String
    let imageName: String
    let tags: [String]
    let difficulty: Difficulty
    let readTime: Int // 阅读时间（分钟）
    let isBookmarked: Bool
    
    enum PetCategory: String, CaseIterable, Codable {
        case dog = "狗狗"
        case cat = "猫咪"
        case general = "通用"
        
        var displayName: String {
            return self.rawValue
        }
    }
    
    enum Difficulty: String, CaseIterable, Codable {
        case beginner = "初级"
        case intermediate = "中级"
        case advanced = "高级"
        
        var displayName: String {
            return self.rawValue
        }
    }
}

// MARK: - 宠物健康指南
struct PetHealthGuide: Codable {
    let id: String
    let title: String
    let category: HealthCategory
    let symptoms: [String]
    let causes: [String]
    let treatments: [String]
    let prevention: [String]
    let emergencyLevel: EmergencyLevel
    let imageName: String
    
    enum HealthCategory: String, CaseIterable, Codable {
        case nutrition = "营养健康"
        case behavior = "行为问题"
        case disease = "疾病预防"
        case emergency = "急救知识"
        case grooming = "美容护理"
        
        var displayName: String {
            return self.rawValue
        }
    }
    
    enum EmergencyLevel: String, CaseIterable, Codable {
        case low = "轻微"
        case medium = "中等"
        case high = "严重"
        case critical = "紧急"
        
        var displayName: String {
            return self.rawValue
        }
        
        var color: String {
            switch self {
            case .low: return "#4CAF50"
            case .medium: return "#FF9800"
            case .high: return "#F44336"
            case .critical: return "#9C27B0"
            }
        }
    }
}

// MARK: - AI问答快捷问题
struct AIQuickQuestion: Codable {
    let id: String
    let question: String
    let category: QuestionCategory
    let isPopular: Bool
    
    enum QuestionCategory: String, CaseIterable, Codable {
        case training = "训练"
        case health = "健康"
        case behavior = "行为"
        case nutrition = "营养"
        case care = "护理"
        
        var displayName: String {
            return self.rawValue
        }
    }
}

// MARK: - 宠物声纹
struct PetVoicePrint: Codable {
    let id: String
    let petName: String
    let petType: String
    let voiceData: Data
    let voiceType: VoiceType
    let recordedDate: Date
    let description: String
    
    enum VoiceType: String, CaseIterable, Codable {
        case bark = "叫声"
        case purr = "呼噜声"
        case whine = "呜咽声"
        case meow = "喵叫声"
        case other = "其他"
        
        var displayName: String {
            return self.rawValue
        }
    }
}



