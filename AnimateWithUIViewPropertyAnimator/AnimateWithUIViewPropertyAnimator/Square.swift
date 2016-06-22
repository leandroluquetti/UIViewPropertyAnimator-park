//
//  Square.swift
//  AnimateWithUIViewPropertyAnimator
//
//  Created by Manuel Lopes on 22/06/2016.


import UIKit

class Square: UIView {
    // MARK: Properties
    
    
    
    
    /*
     Custom implementations of the getter and setter for the comment propety.
     Changes to this property are forwarded to the label and the intrinsic content size is invalidated.
     */
    var image: UIImage? {
        get { return pictureView.image  }
        set { pictureView.image = newValue }
    }
    
    let blurEffect:  UIVisualEffectView
    
    
    private let pictureView: UIImageView
  
    
    // MARK: Initialization
    
    // This initializer will be called if the control is created programatically.
    override init(frame: CGRect) {
        
        blurEffect = Square.blur()
        pictureView = Square.setupImage()
        
        super.init(frame: frame)
        
        insertViews()
    }
    
    // This initializer will be called if the control is loaded from a storyboard.
    required init?(coder aDecoder: NSCoder) {
        blurEffect = Square.blur()
        pictureView = Square.setupImage()
        super.init(coder: aDecoder)
        
        insertViews()
    }
    
     // MARK: Initialization
    deinit {
        print("de-init Square")
    }
    

    

    
    // MARK: Content Size Handling
    
    override func intrinsicContentSize() -> CGSize {
        return pictureView.intrinsicContentSize()
    }

    
    
    
    
    
    
     //MARK: - Setup constraints
    override func updateConstraints() {
        
       
        var newConstraints = [NSLayoutConstraint]()
        
        let views = ["backgroundView": blurEffect]
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|[backgroundView]|", options: [], metrics: nil, views: views)
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|", options: [], metrics: nil, views: views)
        
        let picv = ["pic" : pictureView ]
        newConstraints +=  NSLayoutConstraint.constraints(withVisualFormat: "|[pic]|", options: [], metrics: nil, views: picv)
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[pic]|", options: [], metrics: nil, views: picv)
        
        NSLayoutConstraint.activate(newConstraints)
        
        super.updateConstraints()
    }
    
    
    //MARK: Private  Convenience Methods
    
    // create a blur effect
    static private func blur() ->  UIVisualEffectView {
        
        let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        backgroundView.contentView.backgroundColor = UIColor(white: 0.8, alpha: 0.1)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        return backgroundView
    }
    
    
    
    
    // set up the image view
    static private func setupImage() -> UIImageView{
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }
    
    
    
 
    
    // add to the view hierchy
    private func insertViews() {
        addSubview(pictureView)
        insertSubview( blurEffect, aboveSubview: pictureView)
    }


    
    
}// end

