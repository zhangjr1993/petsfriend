import UIKit

class PrivacyAgreementViewController: UIViewController {
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
        titleLabel.text = "隐私协议"
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
            ("1. 信息收集", "我们会收集您在使用服务时主动提供的信息及因使用服务产生的信息，包括设备信息、日志信息等。"),
            ("2. 信息用途", "我们收集的信息将用于提供、维护、改进服务，保障安全，向您推送相关内容等。"),
            ("3. 信息共享", "未经您同意，我们不会与第三方共享您的个人信息，法律法规另有规定的除外。"),
            ("4. 信息安全", "我们采取多种安全措施保护您的信息，防止数据丢失、滥用或被篡改。"),
            ("5. 权益说明", "您有权访问、更正、删除您的个人信息，并可撤回授权。具体方式请参见应用内相关指引。")
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