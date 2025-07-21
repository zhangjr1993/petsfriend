import UIKit

class LoginViewController: UIViewController {
    private let loginButton = UIButton(type: .custom)
    private let agreeButton = UIButton(type: .custom)
    private let agreeLabel = UILabel()
    private var isAgreed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupBackground()
        setupLoginButton()
        setupAgreeSection()
    }

    private func setupBackground() {
        let bg = UIImageView(image: UIImage(named: "bg_login_shadow"))
        bg.contentMode = .scaleAspectFill
        bg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bg)
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: view.topAnchor),
            bg.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bg.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupLoginButton() {
        loginButton.setTitle("进入app", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 26
        loginButton.layer.masksToBounds = true
        loginButton.backgroundColor = UIColor(hex: "#F3AF4B")
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
            loginButton.heightAnchor.constraint(equalToConstant: 52),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }

    private func setupAgreeSection() {
        agreeButton.setImage(UIImage(named: "btn_ok_nor"), for: .normal)
        agreeButton.setImage(UIImage(named: "btn_ok_pre"), for: .selected)
        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        agreeButton.addTarget(self, action: #selector(agreeTapped), for: .touchUpInside)
        view.addSubview(agreeButton)
        NSLayoutConstraint.activate([
            agreeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            agreeButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            agreeButton.widthAnchor.constraint(equalToConstant: 20),
            agreeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        agreeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        agreeLabel.textColor = UIColor(hex: "#999999")
        agreeLabel.numberOfLines = 0
        agreeLabel.isUserInteractionEnabled = true
        agreeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(agreeLabel)
        NSLayoutConstraint.activate([
            agreeLabel.leadingAnchor.constraint(equalTo: agreeButton.trailingAnchor, constant: 6),
            agreeLabel.centerYAnchor.constraint(equalTo: agreeButton.centerYAnchor),
            agreeLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -44)
        ])
        setAgreeLabelText()
        let tap = UITapGestureRecognizer(target: self, action: #selector(agreeLabelTapped(_:)))
        agreeLabel.addGestureRecognizer(tap)
    }

    private func setAgreeLabelText() {
        let text = "我已阅读并同意《用户协议》和《隐私授权协议》"
        let attr = NSMutableAttributedString(string: text)
        let full = NSRange(location: 0, length: text.count)
        attr.addAttribute(.foregroundColor, value: UIColor(hex: "#999999"), range: full)
        let userRange = (text as NSString).range(of: "《用户协议》")
        let privacyRange = (text as NSString).range(of: "《隐私授权协议》")
        attr.addAttribute(.foregroundColor, value: UIColor(hex: "#F3AF4B"), range: userRange)
        attr.addAttribute(.foregroundColor, value: UIColor(hex: "#F3AF4B"), range: privacyRange)
        agreeLabel.attributedText = attr
    }

    @objc private func agreeTapped() {
        isAgreed.toggle()
        agreeButton.isSelected = isAgreed
    }

    @objc private func loginTapped() {
        if !isAgreed {
            shake(view: agreeLabel)
            return
        }
        // 登录成功，标记已登录并进入主界面
        UserDefaults.standard.set(true, forKey: "hasLogin")
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.rootViewController = CustomTabBarController()
    }

    private func shake(view: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.4
        animation.values = [-8, 8, -6, 6, -4, 4, 0]
        view.layer.add(animation, forKey: "shake")
    }

    @objc private func agreeLabelTapped(_ gesture: UITapGestureRecognizer) {
        let text = agreeLabel.text ?? ""
        let userRange = (text as NSString).range(of: "《用户协议》")
        let privacyRange = (text as NSString).range(of: "《隐私授权协议》")
        let tapLocation = gesture.location(in: agreeLabel)
        if let userRect = boundingRect(for: userRange, in: agreeLabel), userRect.contains(tapLocation) {
            // 跳转用户协议
            let vc = UserAgreementViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if let privacyRect = boundingRect(for: privacyRange, in: agreeLabel), privacyRect.contains(tapLocation) {
            // 跳转隐私协议
            let vc = PrivacyAgreementViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func boundingRect(for range: NSRange, in label: UILabel) -> CGRect? {
        guard let attr = label.attributedText else { return nil }
        let textStorage = NSTextStorage(attributedString: attr)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        var glyphRange = NSRange()
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
        return layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
    }
} 
