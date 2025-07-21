//
//  UIImage+Extension.swift
//  Runner
//
//  Created by Bolo on 2025/7/4.
//

import UIKit
import SDWebImage

extension UIImage {
    /// 从RunnerBundle加载图片，支持jpg、png、webp。imgName需带后缀。
    static func fromRunnerBundle(imgName: String) -> UIImage? {
        // 获取RunnerBundle.bundle路径
        guard let bundlePath = Bundle.main.path(forResource: "RunnerBundle", ofType: "bundle"),
              let bundle = Bundle(path: bundlePath) else {
            print("[UIImage+Extension] RunnerBundle.bundle not found")
            return nil
        }
        // 遍历所有子目录
        let subdirectories = ["afang", "baxi", "nanju", "paopao", "shine", "sunshine", "youmi", "mre", "ganster", "donggua", "daixi", "cpcord"]
        for subdirectory in subdirectories {
            if let imagePath = bundle.path(forResource: imgName, ofType: nil, inDirectory: subdirectory) {
                if imgName.lowercased().hasSuffix(".webp") {
                    // SDWebImage解码webp
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: imagePath)) {
                        return UIImage.sd_image(withWebPData: data)
                    }
                    return nil
                } else {
                    return UIImage(contentsOfFile: imagePath)
                }
            }
        }
        return nil
    }
}

extension UIImageView {
    /// 设置图片，优先从RunnerBundle加载，支持jpg/png/webp，imgName需带后缀
    func setAppImg(_ imgName: String) {
        if let image = UIImage.fromRunnerBundle(imgName: imgName) {
            self.image = image
            return
        }
        // 兜底：主bundle
        if let image = UIImage(named: imgName) {
            self.image = image
            return
        }
        // 未找到
        self.image = nil
        self.backgroundColor = .systemGray5
    }
}
