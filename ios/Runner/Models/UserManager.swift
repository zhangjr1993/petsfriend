import Foundation
import Security

class UserManager {
    static let shared = UserManager()
    
    // MARK: - User Info Model
    struct UserInfo: Codable {
        let uid: String
        var avatar: String
        var nickname: String
        var isVip: Bool
        var diamondBalance: Int
        
        init(uid: String, avatar: String, nickname: String, isVip: Bool = false, diamondBalance: Int = 0) {
            self.uid = uid
            self.avatar = avatar
            self.nickname = nickname
            self.isVip = isVip
            self.diamondBalance = diamondBalance
        }
    }
    
    // MARK: - Properties
    private let keychainService = "com.huanyou.petsfriend.userinfo"
    private let keychainAccount = "userInfo"
    
    private var _userInfo: UserInfo?
    
    var userInfo: UserInfo {
        get {
            if _userInfo == nil {
                _userInfo = loadUserInfoFromKeychain()
            }
            return _userInfo ?? createDefaultUser()
        }
        set {
            _userInfo = newValue
            saveUserInfoToKeychain(newValue)
        }
    }
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Public Methods
    func updateUserInfo(avatar: String? = nil, nickname: String? = nil, isVip: Bool? = nil, diamondBalance: Int? = nil) {
        var updatedInfo = userInfo
        
        if let avatar = avatar {
            updatedInfo.avatar = avatar
        }
        if let nickname = nickname {
            updatedInfo.nickname = nickname
        }
        if let isVip = isVip {
            updatedInfo.isVip = isVip
        }
        if let diamondBalance = diamondBalance {
            updatedInfo.diamondBalance = diamondBalance
        }
        
        userInfo = updatedInfo
    }
    
    func addDiamonds(_ amount: Int) {
        updateUserInfo(diamondBalance: userInfo.diamondBalance + amount)
    }
    
    func consumeDiamonds(_ amount: Int) -> Bool {
        if userInfo.diamondBalance >= amount {
            updateUserInfo(diamondBalance: userInfo.diamondBalance - amount)
            return true
        }
        return false
    }
    
    func setVipStatus(_ isVip: Bool) {
        updateUserInfo(isVip: isVip)
    }
    
    // MARK: - Private Methods
    private func createDefaultUser() -> UserInfo {
        let uid = UUID().uuidString
        let nicknames = ["小宠物", "爱宠达人", "萌宠守护者", "宠物专家", "爱心主人", "毛孩子家长", "宠物医生", "动物保护者", "萌宠控", "宠物爱好者"]
        let randomNickname = nicknames.randomElement() ?? "宠物朋友"
        
        let defaultUser = UserInfo(
            uid: uid,
            avatar: "icon_head",
            nickname: randomNickname,
            isVip: false,
            diamondBalance: 0
        )
        
        userInfo = defaultUser
        return defaultUser
    }
    
    private func saveUserInfoToKeychain(_ userInfo: UserInfo) {
        guard let data = try? JSONEncoder().encode(userInfo) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecValueData as String: data
        ]
        
        // 先删除已存在的数据
        SecItemDelete(query as CFDictionary)
        
        // 保存新数据
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Failed to save user info to keychain: \(status)")
        }
    }
    
    private func loadUserInfoFromKeychain() -> UserInfo? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data) else {
            return nil
        }
        
        return userInfo
    }
} 