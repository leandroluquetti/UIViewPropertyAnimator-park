//
//  CollectionViewController.swift
//  PhotosAnimatedTransition
//
//  Created by Manuel Lopes on 09/09/2016.
//  Copyright © 2016 Manuel Carlos. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    // MARK:- Private Properties
    private let assetTransitionController = AssetTransitionController()
    private var mydataSource  = CollectionViewDataSource()
    
    var selecteCell: Cell?
    
    //MARK:- Initialzers
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
        setupCollectionView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupCollectionView()
    }
    
    
    
    //MARK:- View life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = " Pack "
        navigationController?.delegate = assetTransitionController
        
    }
    
 
    //MARK:- CollecitonView delegate methods
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? Cell else { return }
        selecteCell = cell
        cell.isHidden = true
            
        let pic = AvatarImage()
        pic.imageView = UIImageView(frame: cell.imageView.frame)
        pic.imageView?.image = cell.imageView.image
        pic.beginFrame =  view.convert(cell.imageView.bounds, from: cell.imageView)
        let picSize: CGFloat = 300
        let picRadius = picSize / 2
        let size = CGSize(width: picSize, height: picSize)
        pic.endFrame = CGRect(origin: CGPoint(x: view.center.x - picRadius , y:  view.center.y - picRadius) , size: size )

        assetTransitionController.avatarImage = pic
        assetTransitionController.startInteractive = false

        navigationController?.pushViewController( PictureViewController(with: cell.imageView.image!), animated: true)
    }
    
    
    
    //MARK:- Private convenience methods
    
    // setup collection View
    private func setupCollectionView(){
        
        // Register cell class & General setup
        collectionView?.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        collectionView?.indicatorStyle = .black
        collectionView?.backgroundColor = .white
        
        collectionView?.dataSource  = mydataSource
        collectionView?.delegate    = self
        
    }

  
    
} // ENd

