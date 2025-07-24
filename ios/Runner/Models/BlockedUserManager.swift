import Foundation

// 拉黑用户数据模型
struct BlockedUser: Codable {
    let id: Int
    let userName: String
    let userPic: String
    let petName: String
    let petCategory: String
    let petAge: String
    let petPic: String
    let desc: String
    let blockDate: Date
    
    init(from pet: PetsCodable) {
        self.id = pet.id
        self.userName = pet.userName
        self.userPic = pet.userPic
        self.petName = pet.petName
        self.petCategory = pet.petCategory
        self.petAge = pet.petAge
        self.petPic = pet.petPic
        self.desc = pet.desc
        self.blockDate = Date()
    }
}

// 拉黑用户管理类
class BlockedUserManager {
    static let shared = BlockedUserManager()
    private let userDefaultsKey = "blocked_users"
    
    private init() {}
    
    // 获取所有拉黑用户
    var blockedUsers: [BlockedUser] {
        get {
            if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
               let users = try? JSONDecoder().decode([BlockedUser].self, from: data) {
                return users
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: userDefaultsKey)
            }
        }
    }
    
    // 添加拉黑用户
    func blockUser(_ pet: PetsCodable) {
        let blockedUser = BlockedUser(from: pet)
        var users = blockedUsers
        // 检查是否已经拉黑
        if !users.contains(where: { $0.id == pet.id }) {
            users.append(blockedUser)
            blockedUsers = users
            // 发送通知
            NotificationCenter.default.post(name: .userBlocked, object: pet.id)
        }
    }
    
    // 解除拉黑
    func unblockUser(withId id: Int) {
        var users = blockedUsers
        users.removeAll { $0.id == id }
        blockedUsers = users
        // 发送通知
        NotificationCenter.default.post(name: .userUnblocked, object: id)
    }
    
    // 检查用户是否被拉黑
    func isUserBlocked(id: Int) -> Bool {
        return blockedUsers.contains { $0.id == id }
    }
    
    // 获取拉黑用户ID列表
    var blockedUserIds: [Int] {
        return blockedUsers.map { $0.id }
    }
}

// 通知名称扩展
extension Notification.Name {
    static let userBlocked = Notification.Name("userBlocked")
    static let userUnblocked = Notification.Name("userUnblocked")
} 