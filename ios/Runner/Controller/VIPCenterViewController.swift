import UIKit

class VIPCenterViewController: UIViewController {
    
    // MARK: - UI Components
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var diamondBalanceView: UIView!
    private var diamondBalanceLabel: UILabel!
    private var vipStatusView: UIView!
    private var vipStatusLabel: UILabel!
    private var rechargeCollectionView: UICollectionView!
    private var restoreButton: UIButton!
    
    // MARK: - Data
    private var rechargeProducts: [IAPManager.ProductInfo] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupNavigationBar()
        setupUI()
        loadData()
        setupIAPCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserInfo()
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
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor(hex: "#111111")
        
        title = "会员中心"
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(backTapped))
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 钻石余额视图
        setupDiamondBalanceView()
        
        // VIP状态视图
        setupVIPStatusView()
        
        // 充值套餐标题
        let rechargeTitleLabel = UILabel()
        rechargeTitleLabel.text = "充值套餐"
        rechargeTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        rechargeTitleLabel.textColor = UIColor(hex: "#111111")
        rechargeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rechargeTitleLabel)
        
        // 充值套餐集合视图
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        rechargeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        rechargeCollectionView.backgroundColor = .clear
        rechargeCollectionView.delegate = self
        rechargeCollectionView.dataSource = self
        rechargeCollectionView.showsVerticalScrollIndicator = false
        rechargeCollectionView.register(RechargeProductCell.self, forCellWithReuseIdentifier: "RechargeProductCell")
        rechargeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rechargeCollectionView)
        
        // 恢复购买按钮
        restoreButton = UIButton(type: .system)
        restoreButton.setTitle("恢复购买", for: .normal)
        restoreButton.setTitleColor(UIColor(hex: "#007AFF"), for: .normal)
        restoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        restoreButton.backgroundColor = .white
        restoreButton.layer.cornerRadius = 12
        restoreButton.layer.borderWidth = 1
        restoreButton.layer.borderColor = UIColor(hex: "#007AFF").cgColor
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        restoreButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(restoreButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            diamondBalanceView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            diamondBalanceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            diamondBalanceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            diamondBalanceView.heightAnchor.constraint(equalToConstant: 80),
            
            vipStatusView.topAnchor.constraint(equalTo: diamondBalanceView.bottomAnchor, constant: 15),
            vipStatusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            vipStatusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            vipStatusView.heightAnchor.constraint(equalToConstant: 60),
            
            rechargeTitleLabel.topAnchor.constraint(equalTo: vipStatusView.bottomAnchor, constant: 30),
            rechargeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            rechargeCollectionView.topAnchor.constraint(equalTo: rechargeTitleLabel.bottomAnchor, constant: 15),
            rechargeCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            rechargeCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            rechargeCollectionView.heightAnchor.constraint(equalToConstant: 400),
            
            restoreButton.topAnchor.constraint(equalTo: rechargeCollectionView.bottomAnchor, constant: 30),
            restoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            restoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            restoreButton.heightAnchor.constraint(equalToConstant: 50),
            restoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupDiamondBalanceView() {
        diamondBalanceView = UIView()
        diamondBalanceView.backgroundColor = .white
        diamondBalanceView.layer.cornerRadius = 16
        diamondBalanceView.layer.shadowColor = UIColor.black.cgColor
        diamondBalanceView.layer.shadowOpacity = 0.1
        diamondBalanceView.layer.shadowOffset = CGSize(width: 0, height: 4)
        diamondBalanceView.layer.shadowRadius = 8
        diamondBalanceView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(diamondBalanceView)
        
        let diamondIcon = UIImageView()
        diamondIcon.image = UIImage(systemName: "diamond.fill")
        diamondIcon.tintColor = UIColor(hex: "#FFD700")
        diamondIcon.translatesAutoresizingMaskIntoConstraints = false
        diamondBalanceView.addSubview(diamondIcon)
        
        let balanceTitleLabel = UILabel()
        balanceTitleLabel.text = "钻石余额"
        balanceTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        balanceTitleLabel.textColor = UIColor(hex: "#666666")
        balanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        diamondBalanceView.addSubview(balanceTitleLabel)
        
        diamondBalanceLabel = UILabel()
        diamondBalanceLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        diamondBalanceLabel.textColor = UIColor(hex: "#111111")
        diamondBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        diamondBalanceView.addSubview(diamondBalanceLabel)
        
        NSLayoutConstraint.activate([
            diamondIcon.leadingAnchor.constraint(equalTo: diamondBalanceView.leadingAnchor, constant: 20),
            diamondIcon.centerYAnchor.constraint(equalTo: diamondBalanceView.centerYAnchor),
            diamondIcon.widthAnchor.constraint(equalToConstant: 30),
            diamondIcon.heightAnchor.constraint(equalToConstant: 30),
            
            balanceTitleLabel.leadingAnchor.constraint(equalTo: diamondIcon.trailingAnchor, constant: 15),
            balanceTitleLabel.topAnchor.constraint(equalTo: diamondBalanceView.topAnchor, constant: 20),
            
            diamondBalanceLabel.leadingAnchor.constraint(equalTo: balanceTitleLabel.leadingAnchor),
            diamondBalanceLabel.topAnchor.constraint(equalTo: balanceTitleLabel.bottomAnchor, constant: 5)
        ])
    }
    
    private func setupVIPStatusView() {
        vipStatusView = UIView()
        vipStatusView.backgroundColor = .white
        vipStatusView.layer.cornerRadius = 16
        vipStatusView.layer.shadowColor = UIColor.black.cgColor
        vipStatusView.layer.shadowOpacity = 0.1
        vipStatusView.layer.shadowOffset = CGSize(width: 0, height: 4)
        vipStatusView.layer.shadowRadius = 8
        vipStatusView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vipStatusView)
        
        let vipIcon = UIImageView()
        vipIcon.image = UIImage(systemName: "crown.fill")
        vipIcon.tintColor = UIColor(hex: "#FFD700")
        vipIcon.translatesAutoresizingMaskIntoConstraints = false
        vipStatusView.addSubview(vipIcon)
        
        let statusTitleLabel = UILabel()
        statusTitleLabel.text = "会员状态"
        statusTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        statusTitleLabel.textColor = UIColor(hex: "#666666")
        statusTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        vipStatusView.addSubview(statusTitleLabel)
        
        vipStatusLabel = UILabel()
        vipStatusLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        vipStatusLabel.textColor = UIColor(hex: "#111111")
        vipStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        vipStatusView.addSubview(vipStatusLabel)
        
        NSLayoutConstraint.activate([
            vipIcon.leadingAnchor.constraint(equalTo: vipStatusView.leadingAnchor, constant: 20),
            vipIcon.centerYAnchor.constraint(equalTo: vipStatusView.centerYAnchor),
            vipIcon.widthAnchor.constraint(equalToConstant: 24),
            vipIcon.heightAnchor.constraint(equalToConstant: 24),
            
            statusTitleLabel.leadingAnchor.constraint(equalTo: vipIcon.trailingAnchor, constant: 15),
            statusTitleLabel.centerYAnchor.constraint(equalTo: vipStatusView.centerYAnchor, constant: -10),
            
            vipStatusLabel.leadingAnchor.constraint(equalTo: statusTitleLabel.leadingAnchor),
            vipStatusLabel.topAnchor.constraint(equalTo: statusTitleLabel.bottomAnchor, constant: 2)
        ])
    }
    
    private func loadData() {
        rechargeProducts = IAPManager.shared.getAllLocalProducts()
        rechargeCollectionView.reloadData()
    }
    
    private func setupIAPCallbacks() {
        IAPManager.shared.onPurchaseSuccess = { [weak self] product in
            DispatchQueue.main.async {
                self?.updateUserInfo()
                self?.view.makeToast("购买成功！")
            }
        }
        
        IAPManager.shared.onPurchaseFailed = { [weak self] error in
            DispatchQueue.main.async {
                self?.view.makeToast("购买失败：\(error.localizedDescription)")
            }
        }
        
        IAPManager.shared.onRestoreSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUserInfo()
                self?.view.makeToast("恢复购买成功！")
            }
        }
        
        IAPManager.shared.onRestoreFailed = { [weak self] error in
            DispatchQueue.main.async {
                self?.view.makeToast("恢复购买失败：\(error.localizedDescription)")
            }
        }
    }
    
    private func updateUserInfo() {
        let userInfo = UserManager.shared.userInfo
        
        diamondBalanceLabel.text = "\(userInfo.diamondBalance)"
        vipStatusLabel.text = userInfo.isVip ? "VIP会员(会员免费咨询AI问题)" : "普通用户"
        vipStatusLabel.textColor = userInfo.isVip ? UIColor(hex: "#FFD700") : UIColor(hex: "#666666")
    }
    
    @objc private func restoreButtonTapped() {
        IAPManager.shared.restorePurchases()
    }
}

// MARK: - UICollectionViewDataSource
extension VIPCenterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rechargeProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RechargeProductCell", for: indexPath) as! RechargeProductCell
        let product = rechargeProducts[indexPath.item]
        cell.configure(with: product)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension VIPCenterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = rechargeProducts[indexPath.item]
        IAPManager.shared.purchaseProduct(withId: product.id)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VIPCenterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 15) / 2
        return CGSize(width: width, height: 120)
    }
}

// MARK: - RechargeProductCell
class RechargeProductCell: UICollectionViewCell {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        priceLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        priceLabel.textColor = UIColor(hex: "#FF6B35")
        priceLabel.textAlignment = .center
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(priceLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.textColor = UIColor(hex: "#666666")
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
    }
    
    func configure(with product: IAPManager.ProductInfo) {
        titleLabel.text = product.name
        priceLabel.text = "¥\(product.price)"
        
        if let diamonds = product.diamonds {
            descriptionLabel.text = "获得 \(diamonds) 钻石"
        } else if product.isVip {
            descriptionLabel.text = product.isFirstCharge ? "首充特惠" : "会员特权"
        } else {
            descriptionLabel.text = ""
        }
    }
} 
