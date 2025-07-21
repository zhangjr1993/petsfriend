import UIKit

class UserAgreementViewController: UIViewController {
    private var topBarView: UIView!
    private var backButton: UIButton!
    private var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGradientBackground()
        setupTopBar()
        setupContent()
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(hex: "#FFFBF4").cgColor,
            UIColor(hex: "#FCF8FF").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupTopBar() {
        topBarView = UIView()
        topBarView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBarView)
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 44 + UIApplication.statusBarHeight)
        ])
        // 返回按钮
        backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back_black"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        topBarView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: topBarView.topAnchor, constant: UIApplication.statusBarHeight + 6),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        // 标题
        titleLabel = UILabel()
        titleLabel.text = "用户协议"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topBarView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: topBarView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
    }
    
    private func setupContent() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            label.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        // 内容分段
        let sections: [(title: String, body: String)] = [
            ("1. 服务说明", "\"缘会\"是一个宠物爱好者交流平台，用户可分享宠物动态、私聊交流、索要图片及视频通话互动。"),
            ("2. 用户责任", "禁止发布违法、暴力、骚扰或侵权内容（包括宠物图片/视频）。\n私聊及视频互动需遵守公序良俗，不得用于商业推销或欺诈。\n您对发布的内容独立承担责任。"),
            ("3. 内容权限", "您保留所发布内容的所有权，但授予本应用全球性、非独家的使用许可，以便展示和推广服务。"),
            ("4. 服务终止", "我们有权因违规行为终止您的账户，并保留删除违规内容的权利。"),
            ("5. 免责声明", "用户间私聊、视频互动及线下行为需自行承担风险，本平台不负责监督或担责。\n服务按\"现状\"提供，不保证永久可用或无故障。")
        ]
        let attr = NSMutableAttributedString()
        for (idx, section) in sections.enumerated() {
            // 标题样式
            let titleParagraph = NSMutableParagraphStyle()
            titleParagraph.paragraphSpacing = 4
            titleParagraph.paragraphSpacingBefore = idx == 0 ? 0 : 16
            let titleAttr = NSAttributedString(
                string: section.title + "\n",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 20, weight: .bold),
                    .foregroundColor: UIColor(hex: "#222222"),
                    .paragraphStyle: titleParagraph
                ]
            )
            // 正文样式
            let bodyParagraph = NSMutableParagraphStyle()
            bodyParagraph.lineSpacing = 6
            bodyParagraph.paragraphSpacing = idx == sections.count-1 ? 0 : 12
            let bodyAttr = NSAttributedString(
                string: section.body + (idx == sections.count-1 ? "" : "\n"),
                attributes: [
                    .font: UIFont.systemFont(ofSize: 17),
                    .foregroundColor: UIColor(hex: "#333333"),
                    .paragraphStyle: bodyParagraph
                ]
            )
            attr.append(titleAttr)
            attr.append(bodyAttr)
        }
        label.attributedText = attr
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
} 
