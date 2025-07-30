import UIKit

class PetHealthRecordViewController: UIViewController {
    
    // MARK: - UI Components
    private var tableView: UITableView!
    private var addButton: UIButton!
    
    // MARK: - Data
    private var healthRecords: [PetHealthRecord] = []
    
    // MARK: - Callbacks
    typealias HealthRecordCallback = (PetHealthRecord) -> Void
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupNavigationBar()
        setupTopBar()
        setupTableView()
        setupAddButton()
        loadHealthRecords()
    }
   
    // MARK: - Setup Methods
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
        let topBar = UIView()
        topBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBar)
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 44 + UIApplication.statusBarHeight)
        ])
        // 返回按钮
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "back_black"), for: .normal)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        topBar.addSubview(backBtn)
        NSLayoutConstraint.activate([
            backBtn.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 8),
            backBtn.topAnchor.constraint(equalTo: topBar.topAnchor, constant: UIApplication.statusBarHeight + 6),
            backBtn.widthAnchor.constraint(equalToConstant: 32),
            backBtn.heightAnchor.constraint(equalToConstant: 32)
        ])
        // 标题
        let titleLab = UILabel()
        titleLab.text = "健康档案"
        titleLab.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLab.textColor = UIColor(hex: "#111111")
        titleLab.textAlignment = .center
        titleLab.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(titleLab)
        NSLayoutConstraint.activate([
            titleLab.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            titleLab.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor)
        ])
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: 10, left: 0, bottom: 0, right: 10)
        tableView.register(HealthRecordCell.self, forCellReuseIdentifier: "HealthRecordCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44 + UIApplication.statusBarHeight),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
    }
    
    private func setupAddButton() {
        addButton = UIButton(type: .custom)
        addButton.setTitle("添加健康档案", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = UIColor(hex: "#9C27B0")
        addButton.layer.cornerRadius = 25
        addButton.addTarget(self, action: #selector(addHealthRecordTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func loadHealthRecords() {
        print("开始从UserDefaults加载健康档案数据")
        if let data = UserDefaults.standard.data(forKey: "pet_health_records") {
            do {
                let records = try JSONDecoder().decode([PetHealthRecord].self, from: data)
                healthRecords = records
                print("健康档案加载成功，记录数: \(records.count)")
            } catch {
                print("健康档案加载失败：解码错误 - \(error)")
                healthRecords = []
            }
        } else {
            print("UserDefaults中没有找到健康档案数据")
            healthRecords = []
        }
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func addHealthRecordTapped() {
        let addVC = PetHealthRecordDetailViewController(mode: .add)
        addVC.onSave = { [weak self] record in
            self?.addHealthRecord(record)
        }
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    private func addHealthRecord(_ record: PetHealthRecord) {
        print("添加健康档案: \(record.petName)")
        healthRecords.append(record)
        saveHealthRecords()
        tableView.reloadData()
        print("健康档案添加完成，当前记录数: \(healthRecords.count)")
    }
    
    private func saveHealthRecords() {
        print("开始保存健康档案到UserDefaults")
        do {
            let data = try JSONEncoder().encode(healthRecords)
            UserDefaults.standard.set(data, forKey: "pet_health_records")
            UserDefaults.standard.synchronize() // 强制同步到磁盘
            print("健康档案保存成功，记录数: \(healthRecords.count)")
        } catch {
            print("健康档案保存失败：编码错误 - \(error)")
        }
    }
    
    // MARK: - 缓存管理
    func clearAllHealthRecords() {
        print("清除所有健康档案缓存")
        healthRecords.removeAll()
        UserDefaults.standard.removeObject(forKey: "pet_health_records")
        UserDefaults.standard.synchronize()
        tableView.reloadData()
        print("健康档案缓存已清除")
    }
    
    func getHealthRecordsCount() -> Int {
        return healthRecords.count
    }
    
    func exportHealthRecords() -> String? {
        do {
            let data = try JSONEncoder().encode(healthRecords)
            return String(data: data, encoding: .utf8)
        } catch {
            print("导出健康档案失败：\(error)")
            return nil
        }
    }
}

// MARK: - UITableViewDataSource
extension PetHealthRecordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthRecordCell", for: indexPath) as! HealthRecordCell
        let record = healthRecords[indexPath.row]
        cell.configure(with: record)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PetHealthRecordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let record = healthRecords[indexPath.row]
        let vc = PetHealthRecordDetailViewController(mode: .detail, record: record)
        vc.onSave = { [weak self] updatedRecord in
            self?.updateHealthRecord(updatedRecord)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateHealthRecord(_ record: PetHealthRecord) {
        print("更新健康档案: \(record.petName)")
        if let index = healthRecords.firstIndex(where: { $0.id == record.id }) {
            print("找到记录索引: \(index)")
            healthRecords[index] = record
            saveHealthRecords()
            tableView.reloadData()
            print("健康档案更新完成，当前记录数: \(healthRecords.count)")
        } else {
            print("未找到要更新的记录，ID: \(record.id)")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            healthRecords.remove(at: indexPath.row)
            saveHealthRecords()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}



// MARK: - HealthRecordCell
class HealthRecordCell: UITableViewCell {
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let typeLabel = UILabel()
    private let weightLabel = UILabel()
    private let vaccinationLabel = UILabel()
    private let medicalHistoryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textColor = UIColor(hex: "#111111")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)
        
        typeLabel.font = UIFont.systemFont(ofSize: 14)
        typeLabel.textColor = UIColor(hex: "#666666")
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(typeLabel)
        
        weightLabel.font = UIFont.systemFont(ofSize: 14)
        weightLabel.textColor = UIColor(hex: "#666666")
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(weightLabel)
        
        vaccinationLabel.font = UIFont.systemFont(ofSize: 14)
        vaccinationLabel.textColor = UIColor(hex: "#666666")
        vaccinationLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(vaccinationLabel)
        
        medicalHistoryLabel.font = UIFont.systemFont(ofSize: 14)
        medicalHistoryLabel.textColor = UIColor(hex: "#666666")
        medicalHistoryLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(medicalHistoryLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            typeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            weightLabel.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor),
            weightLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 20),
            
            vaccinationLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8),
            vaccinationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            medicalHistoryLabel.topAnchor.constraint(equalTo: vaccinationLabel.bottomAnchor, constant: 4),
            medicalHistoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            medicalHistoryLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with record: PetHealthRecord) {
        nameLabel.text = record.petName
        typeLabel.text = "类型: \(record.petType)"
        
        if let weight = record.weight {
            weightLabel.text = "体重: \(weight)kg"
        } else {
            weightLabel.text = "体重: 未记录"
        }
        
        vaccinationLabel.text = "疫苗接种: \(record.vaccinations.count)项"
        medicalHistoryLabel.text = "过敏史: \(record.allergies.count)项"
    }
}



 
