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
    
    /// **beginframe** will store the inital frame of the image before the transition, and
    /// **endFrame** will hold the frame values for the image once  the transition ends.
    var (beginFrame, endFrame): (CGRect, CGRect) = (.zero, .zero)
    
}// end


//MARK:- Data source for the collectionView
class CollectionViewDataSource: NSObject, UICollectionViewDataSource{
    
    
    
    //MARK: CollectionView DataSource Methods
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    public func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 48
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        print(indexPath)
        cell.imageView.image = UIImage(named: "\(indexPath.item)")
        
        
        return cell
    }
    
    
}// end


