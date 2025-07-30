import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        // 设置TabBar外观
        tabBar.backgroundColor = .white
        tabBar.tintColor = .customBlue
        tabBar.unselectedItemTintColor = .descriptionTextColor
        
        // 移除TabBar顶部线条
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        // 设置TabBar样式
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = .clear
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupViewControllers() {
        // 创建4个导航控制器
        let homeVC = HomeViewController()
        let homeNav = CustomNavigationController(rootViewController: homeVC)
        
        let welfareVC = PublicWelfareViewController()
        let welfareNav = CustomNavigationController(rootViewController: welfareVC)
        
        let serviceVC = PetServiceViewController()
        let serviceNav = CustomNavigationController(rootViewController: serviceVC)
        
        let meVC = MeViewController()
        let meNav = CustomNavigationController(rootViewController: meVC)
        
        // 设置TabBar项目
        homeNav.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "btn_tab_home_pre")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "btn_tab_home_nor")?.withRenderingMode(.alwaysOriginal)
        )
        
        welfareNav.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "btn_tab_chat_pre")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "btn_tab_chat_nor")?.withRenderingMode(.alwaysOriginal)
        )
        
        serviceNav.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "btn_tab_add_pre")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "btn_tab_add_nor")?.withRenderingMode(.alwaysOriginal)
        )
        
        meNav.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "btn_tab_me_pre")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "btn_tab_me_nor")?.withRenderingMode(.alwaysOriginal)
        )
        
        // 设置viewControllers
        viewControllers = [homeNav, welfareNav, serviceNav, meNav]
    }
} 
