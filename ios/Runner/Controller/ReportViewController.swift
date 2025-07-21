import UIKit

class ReportViewController: UIViewController {
    // 举报理由
    private let reasons = [
        "色情低俗", "虐待暴力", "欺骗诈骗", "辱骂污秽", "侵犯隐私", "抄袭或侵犯版权", "其他"
    ]
    private var selectedIndex: Int? = nil
    var onReportSuccess: (() -> Void)?
    
    // UI
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let tableView = UITableView()
    private let submitButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        // 容器
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 450)
        ])
        // 标题
        titleLabel.text = "请选择举报原因"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        // 关闭按钮
        closeButton.setTitle("✕", for: .normal)
        closeButton.setTitleColor(.gray, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ReasonCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 7*44)
        ])
        // 提交按钮
        submitButton.setTitle("提交", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = UIColor.systemGray4
        submitButton.layer.cornerRadius = 8
        submitButton.isEnabled = false
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(submitButton)
        NSLayoutConstraint.activate([
            submitButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            submitButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            submitButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func submitTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onReportSuccess?()
        }
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonCell", for: indexPath)
        cell.textLabel?.text = reasons[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.selectionStyle = .none
        cell.accessoryType = (selectedIndex == indexPath.row) ? .checkmark : .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        submitButton.isEnabled = true
        submitButton.backgroundColor = UIColor.systemBlue
        tableView.reloadData()
    }
} 
