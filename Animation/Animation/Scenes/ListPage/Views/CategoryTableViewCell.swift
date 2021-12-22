//
//  CategoryTableViewCell.swift
//  Animation
//
//  Created by Enes Urkan on 18.12.2021.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    private lazy var footerTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = CustomFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = CustomFlowLayout.lineSpacing
        layout.minimumInteritemSpacing = CustomFlowLayout.lineSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryItemCollectionCell.self, forCellWithReuseIdentifier: "CategoryItemCollectionCell")
        collectionView.bounces = false
        return collectionView
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 5
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var blurView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.7)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // MARK: - Private Properties
    private var viewModel: CategoryTableViewModel?
    private var transition = Transition()
    
    // MARK: - Public Properties
    var isLayerActive = false {
        didSet {
            self.blurView.isHidden = self.isLayerActive
            self.borderView.isHidden = !self.isLayerActive
        }
    }

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        backgroundColor = .clear
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CategoryTableViewCell deinit")
    }
    
    // MARK: - Setup
    private func setup() {
        contentView.addSubview(headerTitleLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(footerTitleLabel)
        contentView.addSubview(blurView)
        contentView.addSubview(borderView)
        borderView.isHidden = !isLayerActive
        blurView.isHidden = !isLayerActive
    }
    
    private func layout() {
        headerTitleLabel.snp.makeConstraints { make in
            make.top.trailing.leading.equalTo(0)
            make.height.equalTo(30)
        }
        
        footerTitleLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(0)
            make.height.equalTo(60)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(headerTitleLabel.snp.bottom).offset(0)
            make.bottom.equalTo(footerTitleLabel.snp.top).offset(0)
        }
        
        blurView.snp.makeConstraints({$0.edges.equalToSuperview()})
        
        borderView.snp.makeConstraints { make in
            make.centerX.equalTo(collectionView.snp.centerX)
            make.centerY.equalTo(collectionView.snp.centerY)
            make.height.equalTo(collectionView.snp.height)
            make.width.equalTo(CustomFlowLayout.borderWidth)
        }
    }
    
    // MARK: - Public Methods
    func prepareViewWith(viewModel: CategoryTableViewModel){
        self.viewModel = viewModel
        headerTitleLabel.text = viewModel.categoryHeaderTitle
        footerTitleLabel.text = viewModel.defaultFooterTitle
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.getSectionCount() ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryItemCollectionCell", for: indexPath) as? CategoryItemCollectionCell else { return UICollectionViewCell() }
        guard let viewModel = self.viewModel else { return UICollectionViewCell() }
        cell.prepareWith(imageURL: viewModel.getDataBy(index: indexPath.row)?.backgroundContent?.sourcePath)
        transition.destinationFrame = CGRect(x: 0, y: 0, width: Screen.widht, height: Screen.height)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CategoryTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let track = viewModel?.getDataBy(index: indexPath.row) else { return }
        guard let layout = collectionView.collectionViewLayout as? CustomFlowLayout else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryItemCollectionCell else { return }
        guard let topVC = UIApplication.getTopViewController() else { return }
        guard layout.selectedIndex == indexPath.row else { return }
        
        
        let rectFrame = collectionView.convert(cell.frame, to: UIApplication.shared.windows.first)
        transition.startingFrame = CGRect(x: rectFrame.minX, y: rectFrame.minY, width: cell.frame.width, height: cell.frame.height)
        
        let detailViewController = DetailViewController(track: track)
        detailViewController.transitioningDelegate = self
        detailViewController.modalPresentationStyle = .custom
        topVC.present(detailViewController, animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDelegate Flow Layout

extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = CustomFlowLayout.cellWidth
        let height = self.collectionView.bounds.size.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: CustomFlowLayout.cellWidth + (3 * CustomFlowLayout.lineSpacing) , bottom: 0, right: CustomFlowLayout.cellWidth + (3 * CustomFlowLayout.lineSpacing))
    }
}

// MARK: - ScrollView Delegate

extension CategoryTableViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let customFlowLayout = collectionView.collectionViewLayout as? CustomFlowLayout else { return }
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {
            self.footerTitleLabel.alpha = 0
            self.footerTitleLabel.text = self.viewModel?.getFooterTitle(index: customFlowLayout.selectedIndex)
            self.footerTitleLabel.alpha = 1
        } completion: { status in
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension CategoryTableViewCell: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        return transition
    }
}



