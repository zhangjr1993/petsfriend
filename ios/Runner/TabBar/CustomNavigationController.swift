import UIKit

class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        interactivePopGestureRecognizer?.delegate = self
        // 设置导航代理
        delegate = self
    }
    
    private func setupNavigationBar() {
        // 设置导航栏外观
        navigationBar.backgroundColor = .white
        navigationBar.tintColor = .defaultTextColor
        
        // 设置导航栏标题文字属性
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.defaultTextColor,
            .font: UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
        
        // 设置导航栏样式
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.defaultTextColor,
                .font: UIFont.systemFont(ofSize: 18, weight: .medium)
            ]
            appearance.shadowColor = .clear
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
        
        // 设置返回按钮样式
        navigationBar.backIndicatorImage = UIImage(named: "back_black")
        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back_black")
        
        // 隐藏返回按钮文字
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 隐藏底部TabBar（除了根视图控制器）
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension CustomNavigationController: UINavigationControllerDelegate {
  
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        // 解决iOS 14 popToRootViewController tabbar会隐藏的问题
        if animated {
            self.viewControllers.last?.hidesBottomBarWhenPushed = false
        }
        return super.popToRootViewController(animated: animated)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.hidesBottomBarWhenPushed {
            self.tabBarController?.tabBar.isHidden = true
        }else {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
}

extension CustomNavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if children.count == 1 {
            return false
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return gestureRecognizer is UIScreenEdgePanGestureRecognizer
    }
    
}
