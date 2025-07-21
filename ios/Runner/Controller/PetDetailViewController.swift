import UIKit
import Toast_Swift
import AVFoundation // Added for AVCaptureDevice

class PetDetailViewController: UIViewController {
    
    // MARK: - UI Components
    private var tableView: UITableView!
    private var headerImageView: UIImageView!
    private var headerContainerView: UIView!
    private var infoContainerView: UIView! // 新增白色圆角容器
    private var petAvatarImageView: UIImageView!
    private var ownerNameLabel: UILabel!
    var messageButton: UIButton!
    var callButton: UIButton!
    private var topBarView: UIView! // 自定义顶部栏
    private var backButton: UIButton! // 自定义返回按钮
     var reportButton: UIButton! // 举报按钮
    
    // MARK: - Data
    private var petData: PetsCodable!
    private var headerImageHeight: CGFloat = 0
    private let originalHeaderHeight: CGFloat = UIScreen.main.bounds.width * 4 / 3 // 3:4 宽高比
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true) // 隐藏系统导航条
        setupUI()
        setupTopBar()
    }
    
    // MARK: - Initialization
    init(pet: PetsCodable) {
        super.init(nibName: nil, bundle: nil)
        self.petData = pet
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .white
        setupTableView()
        setupHeaderView()
    }
    
    private func setupTopBar() {
        // 顶部黑色渐变视图
        topBarView = UIView()
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBarView)
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 60+UIApplication.statusBarHeight)
        ])
        // 渐变层
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60+UIApplication.statusBarHeight)
        topBarView.layer.insertSublayer(gradient, at: 0)
        // 返回按钮
        backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back_white"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        topBarView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: topBarView.topAnchor, constant: UIApplication.statusBarHeight + 8),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        // 举报按钮
        reportButton = UIButton(type: .custom)
        reportButton.setTitle("举报", for: .normal)
        reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        topBarView.addSubview(reportButton)
        NSLayoutConstraint.activate([
            reportButton.trailingAnchor.constraint(equalTo: topBarView.trailingAnchor, constant: -8),
            reportButton.topAnchor.constraint(equalTo: topBarView.topAnchor, constant: UIApplication.statusBarHeight + 8),
            reportButton.widthAnchor.constraint(equalToConstant: 42),
            reportButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        
        // 注册自定义cell
        tableView.register(PetInfoCell.self, forCellReuseIdentifier: "PetInfoCell")
        tableView.register(AboutCell.self, forCellReuseIdentifier: "AboutCell")
        tableView.register(GalleryCell.self, forCellReuseIdentifier: "GalleryCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor), // 顶部对齐屏幕顶部
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupHeaderView() {
        headerContainerView = UIView()
        headerContainerView.backgroundColor = .clear
        
        // 头部背景图片
        headerImageView = UIImageView()
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        headerImageView.setAppImg(petData.userPic)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.addSubview(headerImageView)
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: originalHeaderHeight)
        ])
        // 白色圆角容器
        infoContainerView = UIView()
        infoContainerView.backgroundColor = .white
        infoContainerView.translatesAutoresizingMaskIntoConstraints = false
        // 左上和右上圆角12px
        infoContainerView.layer.cornerRadius = 12
        infoContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        infoContainerView.layer.masksToBounds = true
        headerContainerView.addSubview(infoContainerView)
        NSLayoutConstraint.activate([
            infoContainerView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            infoContainerView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -24), // 轻微覆盖大图底部
            infoContainerView.heightAnchor.constraint(equalToConstant: 80)
        ])
        // 宠物头像
        petAvatarImageView = UIImageView()
        petAvatarImageView.backgroundColor = .systemGray5
        petAvatarImageView.layer.cornerRadius = 24
        petAvatarImageView.clipsToBounds = true
        petAvatarImageView.contentMode = .scaleAspectFill
        petAvatarImageView.layer.borderWidth = 3
        petAvatarImageView.layer.borderColor = UIColor.white.cgColor
        petAvatarImageView.setAppImg(petData.petPic)
        petAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
        // 主人名称
        ownerNameLabel = UILabel()
        ownerNameLabel.text = petData.userName
        ownerNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        ownerNameLabel.textColor = .defaultTextColor
        ownerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        // 私信按钮
        messageButton = UIButton()
        messageButton.setImage(UIImage(named: "icon_chat"), for: .normal)
        messageButton.backgroundColor = UIColor.systemGray6
        messageButton.layer.cornerRadius = 20
        messageButton.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        // 通话按钮
        callButton = UIButton()
        callButton.setImage(UIImage(named: "icon_video"), for: .normal)
        callButton.backgroundColor = UIColor.systemGray6
        callButton.layer.cornerRadius = 20
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        callButton.translatesAutoresizingMaskIntoConstraints = false
        // 添加到infoContainerView
        infoContainerView.addSubview(petAvatarImageView)
        infoContainerView.addSubview(ownerNameLabel)
        infoContainerView.addSubview(messageButton)
        infoContainerView.addSubview(callButton)
        NSLayoutConstraint.activate([
            petAvatarImageView.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 20),
            petAvatarImageView.centerYAnchor.constraint(equalTo: infoContainerView.centerYAnchor),
            petAvatarImageView.widthAnchor.constraint(equalToConstant: 48),
            petAvatarImageView.heightAnchor.constraint(equalToConstant: 48),
            ownerNameLabel.leadingAnchor.constraint(equalTo: petAvatarImageView.trailingAnchor, constant: 12),
            ownerNameLabel.centerYAnchor.constraint(equalTo: petAvatarImageView.centerYAnchor),
            callButton.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -20),
            callButton.centerYAnchor.constraint(equalTo: petAvatarImageView.centerYAnchor),
            callButton.widthAnchor.constraint(equalToConstant: 40),
            callButton.heightAnchor.constraint(equalToConstant: 40),
            messageButton.trailingAnchor.constraint(equalTo: callButton.leadingAnchor, constant: -12),
            messageButton.centerYAnchor.constraint(equalTo: petAvatarImageView.centerYAnchor),
            messageButton.widthAnchor.constraint(equalToConstant: 40),
            messageButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        // 设置tableHeaderView
        let headerHeight = originalHeaderHeight + 56 // 56=infoContainerView高度+重叠部分
        headerContainerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight)
        tableView.tableHeaderView = headerContainerView
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func messageButtonTapped() {
        print("Message button tapped")
        // 实现私信功能
        let chat = ChatViewController(chatId: petData.id, title: petData.userName)
        navigationController?.pushViewController(chat, animated: true)
    }
    
    @objc private func callButtonTapped() {
        // 1. 检查摄像头和麦克风权限
        let videoStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        func showDeniedAlert(_ type: String) {
            let alert = UIAlertController(title: "无法访问\(type)", message: "请在设置中打开\(type)权限", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            present(alert, animated: true)
        }
        guard videoStatus == .authorized else {
            if videoStatus == .notDetermined {
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        if granted { self.callButtonTapped() } else { showDeniedAlert("摄像头") }
                    }
                }
            } else {
                showDeniedAlert("摄像头")
            }
            return
        }
        guard audioStatus == .authorized else {
            if audioStatus == .notDetermined {
                AVCaptureDevice.requestAccess(for: .audio) { granted in
                    DispatchQueue.main.async {
                        if granted { self.callButtonTapped() } else { showDeniedAlert("麦克风") }
                    }
                }
            } else {
                showDeniedAlert("麦克风")
            }
            return
        }
        // 2. 权限通过，弹出视频通话页面
        let vc = VideoCallViewController(petData: petData)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func reportButtonTapped() {
        let reportVC = ReportViewController()
        reportVC.modalPresentationStyle = .overFullScreen
        reportVC.onReportSuccess = { [weak self] in
            self?.view.makeToast("举报成功，感谢你的宝贵意见")
        }
        present(reportVC, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension PetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // 宠物信息、关于、相册
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PetInfoCell", for: indexPath) as! PetInfoCell
            cell.configure(with: petData)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath) as! AboutCell
            cell.configure(with: petData.desc)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
            cell.configure(with: petData.gallery)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 80 // 宠物信息cell高度
        case 1:
            // 动态计算关于cell的高度
            let titleHeight: CGFloat = 26 // 标题高度
            let titleBottomMargin: CGFloat = 10
            let descTopMargin: CGFloat = 10
            let descBottomMargin: CGFloat = 20
            let descWidth = view.frame.width - 40 // 左右各20的边距
            
            let descHeight = petData.desc.boundingRect(
                with: CGSize(width: descWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)],
                context: nil
            ).height
            
            return titleHeight + titleBottomMargin + descTopMargin + descHeight + descBottomMargin
        case 2:
            return 210 // 相册cell高度
        default:
            return 44
        }
    }
    
    // MARK: - Scroll View Delegate for Header Image Scaling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY < 0 {
            // 下拉时放大图片
            let scale = 1 + abs(offsetY) / originalHeaderHeight
            headerImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            // 调整图片位置
            let newY = offsetY * 0.5
            headerImageView.frame.origin.y = newY
        } else {
            // 恢复原始状态
            headerImageView.transform = .identity
            headerImageView.frame.origin.y = 0
        }
    }
}

// MARK: - PetInfoCell
class PetInfoCell: UITableViewCell {
    
    private let petNameLabel = UILabel()
    private let petCategoryLabel = UILabel()
    private let petAgeLabel = UILabel()
    
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
        
        // 宠物昵称
        petNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        petNameLabel.textColor = UIColor(hex: "#111111")
        petNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 宠物类别
        petCategoryLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        petCategoryLabel.textColor = .customBlue
        petCategoryLabel.backgroundColor = .lightBlueBackground
        petCategoryLabel.layer.cornerRadius = 9
        petCategoryLabel.layer.masksToBounds = true
        petCategoryLabel.textAlignment = .center
        petCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 宠物年龄
        petAgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        petAgeLabel.textColor = .customOrange
        petAgeLabel.backgroundColor = .lightOrangeBackground
        petAgeLabel.layer.cornerRadius = 9
        petAgeLabel.layer.masksToBounds = true
        petAgeLabel.textAlignment = .center
        petAgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(petNameLabel)
        contentView.addSubview(petCategoryLabel)
        contentView.addSubview(petAgeLabel)
        
        NSLayoutConstraint.activate([
            petNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            petNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            petCategoryLabel.leadingAnchor.constraint(equalTo: petNameLabel.leadingAnchor),
            petCategoryLabel.topAnchor.constraint(equalTo: petNameLabel.bottomAnchor, constant: 8),
            petCategoryLabel.heightAnchor.constraint(equalToConstant: 18),
            
            petAgeLabel.leadingAnchor.constraint(equalTo: petCategoryLabel.trailingAnchor, constant: 6),
            petAgeLabel.centerYAnchor.constraint(equalTo: petCategoryLabel.centerYAnchor),
            petAgeLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func configure(with pet: PetsCodable) {
        petNameLabel.text = pet.petName
        petCategoryLabel.text = pet.petCategory
        petAgeLabel.text = pet.petAge
        
        // 动态调整标签宽度
        let categorySize = pet.petCategory.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium)])
        let ageSize = pet.petAge.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium)])
        
        petCategoryLabel.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                petCategoryLabel.removeConstraint(constraint)
            }
        }
        petAgeLabel.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                petAgeLabel.removeConstraint(constraint)
            }
        }
        
        petCategoryLabel.widthAnchor.constraint(equalToConstant: categorySize.width + 10).isActive = true
        petAgeLabel.widthAnchor.constraint(equalToConstant: ageSize.width + 10).isActive = true
    }
}

// MARK: - AboutCell
class AboutCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
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
        
        // 标题
        titleLabel.text = "关于"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 描述
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(hex: "#666666")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func configure(with description: String) {
        descriptionLabel.text = description
    }
}

// MARK: - GalleryCell
class GalleryCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private var collectionView: UICollectionView!
    private var galleryImages: [String] = []
    weak var delegate: GalleryCellDelegate?
    
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
        
        // 标题
        titleLabel.text = "相册"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(hex: "#111111")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 160, height: 160)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GalleryImageCell.self, forCellWithReuseIdentifier: "GalleryImageCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalToConstant: 160),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with images: [String]) {
        galleryImages = images
        collectionView.reloadData()
    }
}

// MARK: - GalleryImageCell
class GalleryImageCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with imageUrl: String) {
        imageView.setAppImg(imageUrl)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension GalleryCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryImageCell", for: indexPath) as! GalleryImageCell
        let imageUrl = galleryImages[indexPath.item]
        cell.configure(with: imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.galleryCell(self, didSelectImageAt: indexPath.item, images: galleryImages)
    }
}

// MARK: - GalleryCellDelegate
protocol GalleryCellDelegate: AnyObject {
    func galleryCell(_ cell: GalleryCell, didSelectImageAt index: Int, images: [String])
}

extension PetDetailViewController: GalleryCellDelegate {
    func galleryCell(_ cell: GalleryCell, didSelectImageAt index: Int, images: [String]) {
        // 将所有图片url转为UIImage
        let uiImages: [UIImage] = images.compactMap { urlStr in
            if let url = URL(string: urlStr), let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
                return img
            } else if let img = UIImage(named: urlStr) { // 本地图片
                return img
            } else if let img = UIImage.fromRunnerBundle(imgName: urlStr) { // 本地图片
                return img
            } else {
                return nil
            }
        }
        guard !uiImages.isEmpty else { return }
        let preview = PhotoPreviewController(images: uiImages, startIndex: min(index, uiImages.count-1))
        preview.modalPresentationStyle = .fullScreen
        present(preview, animated: true, completion: nil)
    }
} 
