import UIKit

class PhotoPreviewController: UIViewController {
    private var images: [UIImage] = []
    private var startIndex: Int = 0
    private var collectionView: UICollectionView!
    private var closeButton: UIButton!
    private var pageLabel: UILabel!
    private var currentIndex: Int = 0

    convenience init(images: [UIImage], startIndex: Int) {
        self.init()
        self.images = images
        self.startIndex = startIndex
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionView()
        setupCloseButton()
        setupPageLabel()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoPreviewCell.self, forCellWithReuseIdentifier: "PhotoPreviewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        // 滚动到初始index
        DispatchQueue.main.async {
            let idx = IndexPath(item: self.startIndex, section: 0)
            self.collectionView.scrollToItem(at: idx, at: .centeredHorizontally, animated: false)
        }
    }

    private func setupCloseButton() {
        closeButton = UIButton(type: .custom)
        closeButton.setTitle("关闭", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        closeButton.layer.cornerRadius = 18
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.statusBarHeight + 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 60),
            closeButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func setupPageLabel() {
        pageLabel = UILabel()
        pageLabel.textColor = .white
        pageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        pageLabel.textAlignment = .center
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageLabel)
        NSLayoutConstraint.activate([
            pageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.statusBarHeight + 16),
            pageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        currentIndex = startIndex
        updatePageLabel()
    }

    private func updatePageLabel() {
        pageLabel.text = "\(currentIndex + 1)/\(images.count)"
    }

    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}

class PhotoPreviewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func configure(with image: UIImage) {
        imageView.image = image
    }
}

extension PhotoPreviewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoPreviewCell", for: indexPath) as! PhotoPreviewCell
        cell.configure(with: images[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        currentIndex = page
        updatePageLabel()
    }
} 