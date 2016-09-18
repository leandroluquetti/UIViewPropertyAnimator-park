//
//  CollectionViewDataSource.swift
//  PhotosAnimatedTransition
//
//  Created by Manuel Lopes on 09/09/2016.
//  Copyright © 2016 Manuel Carlos. All rights reserved.
//


import UIKit


//MARK:- Object that will hold the image and its info while the transition runs.
class AvatarImage {
    
    /// The UIImageView that will hold the image being animated during the transition.
    var imageView: UIImageView?
    
    /// **frameAt.start** will store the inital frame of the image before the transition, and
    /// **frameAt.end** will hold the frame values for the image once  the transition ends.
    var frameAt: (start: CGRect, end: CGRect) = (.zero, .zero)

    
    /// The center point of the image view.
    var position: CGPoint?{
        get{
            return imageView?.center
        }
        set{
            imageView?.center = newValue!
        }
    }
    
    /// the size of the image view.
    var size: CGSize?{
        get{
            return imageView?.bounds.size
        }
        set{
            imageView?.bounds.size = newValue!
        }
    }

    
}// end




//MARK:- Data source for the collectionView.
class CollectionViewDataSource: NSObject, UICollectionViewDataSource{
    
    
    
    //MARK: CollectionView DataSource Methods.
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    public func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 48
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        cell.imageView.image = UIImage(named: "\(indexPath.item)")
        
        return cell
    }
    
    
}// end


