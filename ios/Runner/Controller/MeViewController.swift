import UIKit

class MeViewController: UIViewController, MyPetCollectionCellDelegate {
    func myPetCollectionCell(_ cell: MyPetCollectionCell, didSelectPet pet: PetProfile) {

    }
    
    private var tableView: UITableView!
    private var pets: [PetProfile] = []
    private let functionItems: [(icon: String, title: String)] = [
        ("icon_me_ment", "用户协议"),
        ("icon_me_ment", "隐私协议"),
        ("icon_me_about", "关于")
    ]
    private let avatarSize: CGFloat = 98
    private let avatarTop: CGFloat = 28
    private let nickname = "月亮姐姐"
    private var userProfile: UserProfile? {
        return UserDefaults.standard.userProfile
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPets()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupGradientBackground()
        setupTableView()
        setupEditButton()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserProfile), name: .userProfileDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPets), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc private func refreshUserProfile() {
        tableView.reloadData()
    }
    @objc private func refreshPets() {
        loadPets()
        tableView.reloadData()
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

    private func setupEditButton() {
        let editBtn = UIButton(type: .custom)
        editBtn.setBackgroundImage(UIImage(named: "btn_me_edit"), for: .normal)
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        editBtn.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        view.addSubview(editBtn)
        NSLayoutConstraint.activate([
            editBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.statusBarHeight + 12),
            editBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editBtn.widthAnchor.constraint(equalToConstant: 32),
            editBtn.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MyPetCollectionCell.self, forCellReuseIdentifier: "MyPetCollectionCell")
        tableView.register(FunctionCell.self, forCellReuseIdentifier: "FunctionCell")
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadPets() {
        if let data = UserDefaults.standard.data(forKey: "pet_profiles"),
           let arr = try? JSONDecoder().decode([PetProfile].self, from: data) {
            pets = arr
        } else {
            pets = []
        }
        self.tableView.reloadData()
    }
    private func savePets() {
        if let data = try? JSONEncoder().encode(pets) {
            UserDefaults.standard.set(data, forKey: "my_pets")
        }
    }

    @objc private func editTapped() {
        let editVC = EditProfileViewController()
        navigationController?.pushViewController(editVC, animated: true)
    }
}

extension MeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1 // 头部
        case 1: return pets.isEmpty ? 0 : 1 // 宠物区
        case 2: return functionItems.count // 功能区
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return avatarTop + UIApplication.statusBarHeight + avatarSize + 18 + 24 // 头像+昵称+间距
        case 1: return 246 // title+collectionView高度
        case 2: return 56
        default: return 44
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            let avatar = UIImageView()
            avatar.backgroundColor = .systemGray5
            avatar.layer.cornerRadius = 12
            avatar.clipsToBounds = true
            avatar.contentMode = .scaleAspectFill
            if let data = userProfile?.avatarData, let img = UIImage(data: data) {
                avatar.image = img
            } else {
                avatar.image = UIImage(named: "icon_head")
            }
            avatar.translatesAutoresizingMaskIntoConstraints = false
            let nameLab = UILabel()
            nameLab.text = userProfile?.nickname ?? nickname
            nameLab.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            nameLab.textColor = .defaultTextColor
            nameLab.textAlignment = .center
            nameLab.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(avatar)
            cell.contentView.addSubview(nameLab)
            NSLayoutConstraint.activate([
                avatar.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                avatar.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: avatarTop + UIApplication.statusBarHeight),
                avatar.widthAnchor.constraint(equalToConstant: avatarSize),
                avatar.heightAnchor.constraint(equalToConstant: avatarSize),
                nameLab.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                nameLab.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 18)
            ])
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPetCollectionCell", for: indexPath) as! MyPetCollectionCell
            cell.configure(with: pets)
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FunctionCell", for: indexPath) as! FunctionCell
            let item = functionItems[indexPath.row]
            cell.configure(icon: item.icon, title: item.title)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 可根据indexPath跳转协议或关于页面
        
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                let vc = UserAgreementViewController()
                navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1 {
                let vc = PrivacyAgreementViewController()
                navigationController?.pushViewController(vc, animated: true)
            }else {
                // 关于
                let vc = AboutViewController()
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

class MyPetCollectionCell: UITableViewCell {
    private var collectionView: UICollectionView!
    private var pets: [PetProfile] = []
    weak var delegate: MyPetCollectionCellDelegate?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 160, height: 214)
        layout.minimumLineSpacing = 15
        layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MyPetCardCell.self, forCellWithReuseIdentifier: "MyPetCardCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        let titleLab = UILabel()
        titleLab.text = "我的宠物"
        titleLab.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLab.textColor = .defaultTextColor
        titleLab.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLab)
        NSLayoutConstraint.activate([
            titleLab.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLab.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titleLab.heightAnchor.constraint(equalToConstant: 22),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLab.bottomAnchor, constant: 16),
            collectionView.heightAnchor.constraint(equalToConstant: 214),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func configure(with pets: [PetProfile]) {
        self.pets = pets
        collectionView.reloadData()
    }
}

protocol MyPetCollectionCellDelegate: AnyObject {
    func myPetCollectionCell(_ cell: MyPetCollectionCell, didSelectPet pet: PetProfile)
}

extension MyPetCollectionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPetCardCell", for: indexPath) as! MyPetCardCell
        cell.configure(with: pets[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pet = pets[indexPath.item]
        delegate?.myPetCollectionCell(self, didSelectPet: pet)
    }
}
class MyPetCardCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let nameLab = UILabel()
    private let tagLab = UILabel()
    private let ageLab = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.cornerRadius = 12
        layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLab.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        nameLab.textColor = .defaultTextColor
        nameLab.translatesAutoresizingMaskIntoConstraints = false
        tagLab.font = UIFont.systemFont(ofSize: 12)
        tagLab.textColor = .white
        tagLab.backgroundColor = .customBlue
        tagLab.layer.cornerRadius = 9
        tagLab.layer.masksToBounds = true
        tagLab.textAlignment = .center
        tagLab.translatesAutoresizingMaskIntoConstraints = false
        ageLab.font = UIFont.systemFont(ofSize: 12)
        ageLab.textColor = .white
        ageLab.backgroundColor = .customOrange
        ageLab.layer.cornerRadius = 9
        ageLab.layer.masksToBounds = true
        ageLab.textAlignment = .center
        ageLab.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addSubview(nameLab)
        contentView.addSubview(tagLab)
        contentView.addSubview(ageLab)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 160),
            nameLab.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLab.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            tagLab.leadingAnchor.constraint(equalTo: nameLab.leadingAnchor),
            tagLab.topAnchor.constraint(equalTo: nameLab.bottomAnchor, constant: 6),
            tagLab.heightAnchor.constraint(equalToConstant: 18),
            ageLab.leadingAnchor.constraint(equalTo: tagLab.trailingAnchor, constant: 8),
            ageLab.centerYAnchor.constraint(equalTo: tagLab.centerYAnchor),
            ageLab.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func configure(with pet: PetProfile) {
        if let img = UIImage(data: pet.avatarData) {
            imageView.image = img
        } else {
            imageView.image = UIImage(named: "icon_head")
        }
        nameLab.text = pet.name
        tagLab.text = pet.type
        ageLab.text = pet.age
        let tagW = (tagLab.text?.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12)]).width ?? 0) + 16
        let ageW = pet.age.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12)]).width + 16
        tagLab.widthAnchor.constraint(equalToConstant: tagW).isActive = true
        ageLab.widthAnchor.constraint(equalToConstant: ageW).isActive = true
    }
}
class FunctionCell: UITableViewCell {
    private let iconView = UIImageView()
    private let titleLab = UILabel()
    private let arrowView = UIImageView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLab.font = UIFont.systemFont(ofSize: 15)
        titleLab.textColor = .defaultTextColor
        titleLab.translatesAutoresizingMaskIntoConstraints = false
        arrowView.image = UIImage(named: "icon_me_go")
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconView)
        contentView.addSubview(titleLab)
        contentView.addSubview(arrowView)
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            titleLab.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLab.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            arrowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 8),
            arrowView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func configure(icon: String, title: String) {
        iconView.image = UIImage(named: icon)
        titleLab.text = title
    }
} 
