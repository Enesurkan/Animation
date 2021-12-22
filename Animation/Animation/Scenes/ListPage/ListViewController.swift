//
//  ViewController.swift
//  Animation
//
//  Created by Enes Urkan on 14.12.2021.
//

import UIKit
import SnapKit

final class ListViewController: UIViewController {
    
    //MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 300
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.decelerationRate = .fast
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        return tableView
    }()
    
    // MARK: - Private Variables
    
    private var categories = [Category]()
    private var topCellIndexPath = IndexPath(row: 0, section: 0)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categories = ListProvider.getAllList()
        setup()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.view.bounds.height - 300, right: 0)
    }
    
    // MARK: - Setup
    
    private func setup() {
        self.view.backgroundColor = .black
        self.view.addSubview(tableView)
    }
    
    private func layout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            make.leading.trailing.equalTo(0)
        }
    }
    
    private func clearAllCellLayer() {
        guard let visibleCellIndexPaths = self.tableView.indexPathsForVisibleRows else { return }
        for visibleCellIndexPath in visibleCellIndexPaths {
            guard let cell = self.tableView.cellForRow(at: visibleCellIndexPath) as? CategoryTableViewCell else { return }
            cell.isLayerActive = false
            cell.isUserInteractionEnabled = false
        }
    }
    
    private func setTopCellLayerWith(indexPath: IndexPath) {
        self.topCellIndexPath = indexPath
        guard let cell = self.tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else { return }
        cell.isLayerActive = true
        cell.isUserInteractionEnabled = true
    }
}

// MARK: - UITableView DataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let category = self.categories[safeIndex: indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        cell.prepareViewWith(viewModel: .init(category: category, indexPath: indexPath))
        cell.isLayerActive = indexPath == self.topCellIndexPath ? true : false
        cell.isUserInteractionEnabled = indexPath == self.topCellIndexPath ? true : false
        return cell
    }
}

// MARK: - UITableView Delegate

extension ListViewController: UITableViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = self.tableView.contentOffset.x
        let y = self.tableView.contentOffset.y+tableView.rowHeight/2
        guard let indexPathToScrollTo = self.tableView.indexPathForRow(at: CGPoint(x: x, y: y)) else { return }
        self.setSnapToTopCellBorderView(topIndexPath: indexPathToScrollTo)
        self.tableView.scrollToRow(at: indexPathToScrollTo, at: .top, animated: true)
    }
    
    func setSnapToTopCellBorderView(topIndexPath: IndexPath) {
        self.clearAllCellLayer()
        setTopCellLayerWith(indexPath: topIndexPath)
    }
}

// MARK: - UIScrollView Delegate

extension ListViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.clearAllCellLayer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
}
