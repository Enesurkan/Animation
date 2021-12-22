//
//  CustomFlowLayout.swift
//  Animation
//
//  Created by Enes Urkan on 21.12.2021.
//

import Foundation
import UIKit

final class CustomFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Public Variables
    static let lineSpacing: CGFloat = 10
    static let cellWidth: CGFloat = (((Screen.widht - 32) - (30)) / 3).rounded(.towardZero)
    static let borderWidth: CGFloat = ((Screen.widht - 32) - (30)) / 3
    var selectedIndex: Int = 0
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            return latestOffset
        }
        let cellWidth = ((Screen.widht - 32) - 30) / 3
        let pageWidth = cellWidth + minimumLineSpacing
        let approximatePage = collectionView.contentOffset.x / pageWidth
        let currentPage = velocity.x == 0 ? round(approximatePage) : (velocity.x < 0.0 ? floor(approximatePage) : ceil(approximatePage))
        let flickVelocity = velocity.x * 0.3
        let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)
        let newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - collectionView.contentInset.left
        selectedIndex = Int(newHorizontalOffset <= 0 ? 0 : newHorizontalOffset / pageWidth)
        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
    }
}
