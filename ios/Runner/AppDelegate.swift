import Flutter
import StoreKit
import SDWebImageWebPCoder
import SDWebImage
import UIKit
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      // 设置自定义TabBarController为根视图控制器
      setupAppData()
      setupIQ()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
          if #available(iOS 14, *) {
              ATTrackingManager.requestTrackingAuthorization { status in
                  // Handle tracking authorization status
              }
          }
      }
      
      if let window = self.window {
          if UserDefaults.standard.bool(forKey: "hasLogin") {
              let tabBarController = CustomTabBarController()
              window.rootViewController = tabBarController
          } else {
              let loginVC = LoginViewController()
              window.rootViewController = CustomNavigationController(rootViewController: loginVC)
          }
          window.makeKeyAndVisible()
      }
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    

}

extension AppDelegate {
    private func setupSDWebCoder() {
        let webPCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(webPCoder)
    }
    
    private func setupAppData() {
        AppRunManager.shared.initData()
        
        // 初始化IAPManager
        SKPaymentQueue.default().add(IAPManager.shared)
        
        // 请求产品信息
        IAPManager.shared.requestProducts()
    }
    
    
    private func setupIQ() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
}
