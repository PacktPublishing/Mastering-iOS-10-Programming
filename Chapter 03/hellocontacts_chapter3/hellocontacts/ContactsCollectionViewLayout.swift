//
//  ContactsCollectionViewLayout.swift
//  HelloContacts
//
//  Created by Donny Wals on 20/06/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit

class ContactsCollectionViewLayout: UICollectionViewLayout {
    var itemSize = CGSize(width: 110, height: 90)
    var itemSpacing: CGFloat = 10
    
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    private var numberOfItems = 0
    private var numRows = 0
    private var numColumns = 0
    
    override func prepare() {
        guard let collectionView = collectionView else { return }

        numberOfItems = collectionView.numberOfItems(inSection: 0)
        let collectionViewHeight = collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        numRows = Int(collectionViewHeight + itemSpacing) / Int(itemSize.height + itemSpacing)
        numColumns = Int(ceil(CGFloat(numberOfItems) / CGFloat(numRows)))
        
        layoutAttributes.removeAll()
        
        for itemIndex in 0..<numberOfItems {
            let row = itemIndex % numRows
            let column = itemIndex / numRows
            
            var xPos = column * Int(itemSize.width + itemSpacing)
            if row % 2 == 1 {
                xPos += Int(itemSize.width / 2)
            }
            
            let yPos = row * Int(itemSize.height + itemSpacing)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: itemIndex, section: 0))
            attributes.frame = CGRect(x: CGFloat(xPos), y: CGFloat(yPos), width: itemSize.width, height: itemSize.height)
            
            layoutAttributes.append(attributes)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return true }
        
        let availableHeight = newBounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        let possibleRows = Int(availableHeight + itemSpacing) / Int(itemSize.height + itemSpacing)
        
        return possibleRows != numRows
    }
    
    override func collectionViewContentSize() -> CGSize {
        let width = CGFloat(numColumns) * itemSize.width + CGFloat(numColumns - 1) * itemSpacing
        let height = CGFloat(numRows) * itemSize.height + CGFloat(numRows - 1) * itemSpacing
        
        return CGSize(width: width, height: height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { attributes in
            return attributes.frame.intersects(rect)
        }
    }
 
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.row]
    }
}
