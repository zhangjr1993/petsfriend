import UIKit

extension UIApplication {
    /// 顶部状态栏高度（包括刘海/动态岛等）
    static var statusBarHeight: CGFloat {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first
        return window?.safeAreaInsets.top ?? 20
    }
    
    static var viewWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static var viewHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }

    /// 底部安全区高度（如iPhone X系列的Home Indicator区域）
    static var bottomSafeAreaHeight: CGFloat {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first
        return window?.safeAreaInsets.bottom ?? 0
    }
} 
