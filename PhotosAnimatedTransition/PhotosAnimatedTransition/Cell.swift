//
//  Cell.swift
//  PhotosAnimatedTransition
//
//  Created by Manuel Lopes on 09/09/2016.
//  Copyright © 2016 Manuel Carlos. All rights reserved.
//


import UIKit

class Cell : UICollectionViewCell{
    
    static var reuseIdentifier: String { return "\(self)" }
    
    let  imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// Setting up the view
    func setup() {
        contentView.addSubview(imageView)
    
    }
    
    
    
} //End

