//
//  ViewController.swift
//  IOSBasics
//





import UIKit

@available(iOS 10.0, *)
class ViewController: UIViewController {
    
    // MARK:- Properties
    
    var colorChange: UIViewPropertyAnimator!
    let square: Square = Square()
    
    var mainStack: UIStackView?
    var animator: UIViewPropertyAnimator?
    
    // MARK: Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
    }
    
    
    init() {
       
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: De-init
    
    
    
    deinit{
        print("deinit viewController")
        
    } 
    
  
    
   

    
    
    // MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupSquare()
        
        animator = UIViewPropertyAnimator(duration: 0, curve: .linear) {
            self.square.blurEffect.effect = nil
        }
        
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        slider.value = 0.4
        slider.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        slider.maximumTrackTintColor =  #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        slider.thumbTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        let leftSliderDummyView = UIView()
        leftSliderDummyView.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        
        let rightSliderDummyView = UIView()
        rightSliderDummyView.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        
        
        let sliderStack = UIStackView(arrangedSubviews: [ leftSliderDummyView, slider, rightSliderDummyView])
        sliderStack.axis = .horizontal
        
        
        leftSliderDummyView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rightSliderDummyView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        //Vertical StackView with the Album Picture and the stackView of Controls
        
        mainStack = UIStackView(arrangedSubviews: [ square, sliderStack ])
        mainStack?.axis = .vertical
        mainStack?.spacing = 2
        mainStack?.distribution = UIStackViewDistribution.fillEqually
        mainStack?.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(mainStack!)
        
        slider.addTarget(self, action: #selector(ViewController.sliderValueChanged(sender:)), for: .valueChanged)
        
    
    }
    
    
    func sliderValueChanged(sender: UISlider) {
        print(sender.value)
        animator?.fractionComplete = CGFloat(sender.value)
        
    }


    
    
    private func setupSquare(){
        
        square.image = #imageLiteral(resourceName: "rocket")
        square.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(square)
        
    }
    
    
    //MARK:- apply constraints to the main Stack view
    override func updateViewConstraints() {
        
        let margins = view.layoutMarginsGuide
        
        mainStack?.leadingAnchor.constraint(equalTo: margins.leadingAnchor,constant: -20 ).isActive = true
        mainStack?.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 20).isActive = true
        mainStack?.topAnchor.constraint(equalTo: margins.topAnchor,constant: 0).isActive = true
        mainStack?.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        super.updateViewConstraints()
    }

    
    
    // MARK:- Handle Device Rotation
    override func viewWillTransition( to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        super.viewWillTransition(to: size , with: coordinator)
        
        coordinator.animate(alongsideTransition: {
            context in
            
            if size.width > size.height { self.mainStack?.axis = .horizontal   }
            else {   self.mainStack?.axis = .vertical  }
            
            }, completion: nil        )
    }
    

    
    
    
}// END

