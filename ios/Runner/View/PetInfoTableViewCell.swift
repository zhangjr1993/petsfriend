//
//  PetInfoTableViewCell.swift
//  Runner
//
//  Created by Bolo on 2025/7/4.
//

import UIKit

class PetInfoTableViewCell: UITableViewCell {

    // MARK: - UI Components
    private let containerView = UIView()
    private let petAvatar = UIImageView()
    private let petNickname = UILabel()
    private let petCategory = UILabel()
    private let petAge = UILabel()
    private let petDescription = UILabel()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // 容器视图
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 14
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 宠物头像
        petAvatar.backgroundColor = .systemGray5
        petAvatar.layer.cornerRadius = 12
        petAvatar.clipsToBounds = true
        petAvatar.contentMode = .scaleAspectFill
        petAvatar.translatesAutoresizingMaskIntoConstraints = false
        
        // 宠物昵称
        petNickname.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        petNickname.textColor = .defaultTextColor
        petNickname.translatesAutoresizingMaskIntoConstraints = false
        
        // 宠物类别
        petCategory.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        petCategory.textColor = .customBlue
        petCategory.backgroundColor = .lightBlueBackground
        petCategory.layer.cornerRadius = 9
        petCategory.textAlignment = .center
        petCategory.translatesAutoresizingMaskIntoConstraints = false
        
        // 宠物年龄
        petAge.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        petAge.textColor = .customOrange
        petAge.backgroundColor = .lightOrangeBackground
        petAge.layer.cornerRadius = 9
        petAge.textAlignment = .center
        petAge.translatesAutoresizingMaskIntoConstraints = false
        
        // 宠物描述
        petDescription.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        petDescription.textColor = .descriptionTextColor
        petDescription.numberOfLines = 2
        petDescription.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加到contentView
        contentView.addSubview(containerView)
        containerView.addSubview(petAvatar)
        containerView.addSubview(petNickname)
        containerView.addSubview(petCategory)
        containerView.addSubview(petAge)
        containerView.addSubview(petDescription)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 容器视图
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            // 宠物头像
            petAvatar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 6),
            petAvatar.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            petAvatar.widthAnchor.constraint(equalToConstant: 100),
            petAvatar.heightAnchor.constraint(equalToConstant: 100),
            
            // 宠物昵称
            petNickname.leadingAnchor.constraint(equalTo: petAvatar.trailingAnchor, constant: 16),
            petNickname.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            petNickname.topAnchor.constraint(equalTo: petAvatar.topAnchor, constant: 8),
            
            // 宠物类别
            petCategory.leadingAnchor.constraint(equalTo: petNickname.leadingAnchor),
            petCategory.topAnchor.constraint(equalTo: petNickname.bottomAnchor, constant: 8),
            petCategory.heightAnchor.constraint(equalToConstant: 18),
            
            // 宠物年龄
            petAge.leadingAnchor.constraint(equalTo: petCategory.trailingAnchor, constant: 6),
            petAge.centerYAnchor.constraint(equalTo: petCategory.centerYAnchor),
            petAge.heightAnchor.constraint(equalToConstant: 18),
            
            // 宠物描述
            petDescription.leadingAnchor.constraint(equalTo: petNickname.leadingAnchor),
            petDescription.trailingAnchor.constraint(equalTo: petNickname.trailingAnchor),
            petDescription.topAnchor.constraint(equalTo: petCategory.bottomAnchor, constant: 8),
            petDescription.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configuration
    func configure(with pet: PetsCodable) {
        // 加载宠物头像图片
        petAvatar.setAppImg(pet.petPic)
        
        petNickname.text = pet.petName
        petCategory.text = pet.petCategory
        petAge.text = pet.petAge
        petDescription.text = pet.desc
        
        // 动态调整类别和年龄标签的宽度
        let categorySize = pet.petCategory.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium)])
        let ageSize = pet.petAge.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium)])
        
        // 移除之前的宽度约束（如果存在）
        petCategory.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                petCategory.removeConstraint(constraint)
            }
        }
        petAge.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                petAge.removeConstraint(constraint)
            }
        }
        
        // 添加新的宽度约束
        petCategory.widthAnchor.constraint(equalToConstant: categorySize.width + 10).isActive = true
        petAge.widthAnchor.constraint(equalToConstant: ageSize.width + 10).isActive = true
    }
    
  

}
