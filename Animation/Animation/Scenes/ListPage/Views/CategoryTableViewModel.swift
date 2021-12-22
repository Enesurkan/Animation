//
//  CategoryTableViewModel.swift
//  Animation
//
//  Created by Enes Urkan on 18.12.2021.
//

import Foundation

final class CategoryTableViewModel {
    
    // MARK: - Private Properties
    private let index   : Int
    private let category: Category
    
    // MARK: - Lifecycle
    
    init(category: Category, indexPath: IndexPath) {
        self.category = category
        self.index    = indexPath.row
    }
    
    deinit {
        print("CategoryTableViewModel deinit")
    }
    
    // MARK: - Public Properties
    
    var categoryHeaderTitle: String {
        category.title
    }
    
    var defaultFooterTitle: String? {
        category.tracks?.first?.title
    }
    
    // MARK: - Public Methods
    
    func getFooterTitle(index: Int) -> String? {
        category.tracks?[safeIndex: index]?.title
    }
    
    func getDataBy(index: Int) -> Track? {
        category.tracks?[safeIndex: index]
    }
    
    func getSectionCount() -> Int {
        category.tracks?.count ?? 0
    }
}
