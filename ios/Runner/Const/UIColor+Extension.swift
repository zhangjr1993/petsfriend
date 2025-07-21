import UIKit

extension UIColor {
    
    /// 默认字体颜色
    static let defaultTextColor = UIColor(hex: "#111111")
    
    /// 描述字体颜色
    static let descriptionTextColor = UIColor(hex: "#666666")
    
    /// 自定义蓝色
    static let customBlue = UIColor(hex: "#4874F5")
    
    /// 自定义橙色
    static let customOrange = UIColor(hex: "#FD9B00")
    
    /// 浅蓝色背景
    static let lightBlueBackground = UIColor(hex: "#E0E7FD")
    
    /// 浅橙色背景
    static let lightOrangeBackground = UIColor(hex: "#FDF0DB")
    
    /// 使用十六进制字符串初始化颜色
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            alpha: Double(a) / 255
        )
    }
} 