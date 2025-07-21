import Foundation

struct PetProfile: Codable {
    var name: String
    var type: String // "狗" or "猫"
    var age: String
    var desc: String
    var avatarData: Data
    var albumDatas: [Data]
} 