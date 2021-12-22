//
//  CategoryItemCollectionCell.swift
//  Animation
//
//  Created by Enes Urkan on 19.12.2021.
//

import UIKit
import SDWebImage
 
final class CategoryItemCollectionCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setup()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CategoryItemCollectionCell deinit")
    }
    
    private func setup() {
        self.addSubview(imageView)
    }
    
    private func layout() {
        imageView.snp.makeConstraints({ $0.edges.equalToSuperview() })
    }
    
    // MARK: - Override Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
    }
    
    // MARK: - Public Methods
    
    func prepareWith(imageURL: String?) {
        guard let imageURL = URL(string: imageURL ?? "") else { return }
        imageView.sd_setImage(with: imageURL, completed: nil)
    }
    
}
