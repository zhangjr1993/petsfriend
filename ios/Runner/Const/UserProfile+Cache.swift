import UIKit

struct UserProfile: Codable {
    var nickname: String
    var avatarData: Data?
}

extension UserDefaults {
    var userProfile: UserProfile? {
        get {
            if let data = data(forKey: "user_profile"),
               let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
                return profile
            }
            return nil
        }
        set {
            if let newValue = newValue,
               let data = try? JSONEncoder().encode(newValue) {
                set(data, forKey: "user_profile")
            }
        }
    }
}

extension Notification.Name {
    static let userProfileDidChange = Notification.Name("userProfileDidChange")
} 