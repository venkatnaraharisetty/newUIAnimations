//
//  ImageViewController.swift
//  newUIAnimations
//
//  Created by Naraharisetty, Venkat on 12/23/18.
//  Copyright © 2018 Naraharisetty, Venkat. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image:UIImage?
    var imageSet:Dictionary<String, Any>?
    var imageArray:[Dictionary<String,Any>] = []
    
    @IBOutlet weak var initialImageView: UIImageView!
    @IBOutlet weak var imageSetLabel: UILabel!
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.alpha = 0
        overlayView.alpha = 0
        if let availableImage = image, let availableData = imageSet {
            initialImageView.image = availableImage
            imageSetLabel.text = availableData["homeCellLabel"] as? String
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
        
    }
    
    func getData(){
        print("get Data function")
        guard let location = Bundle.main.url(forResource: "Images", withExtension: "plist") else{return}
        imageArray = (NSArray(contentsOf: location) as? [Dictionary<String, Any>])!
        self.setupUI()
        
    }
    
    func setupUI(){
        UIView.animate(withDuration: 0.5) {
            self.overlayView.alpha = 1
            self.backButton.alpha = 1
        }
        scrollView.contentSize.width = self.scrollView.frame.width *  CGFloat(imageArray.count + 1)
        print(imageArray)
        for (i,image) in imageArray.enumerated(){
            let frame = CGRect(x: self.scrollView.frame.width * CGFloat(i+1), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            guard let photoView = Bundle.main.loadNibNamed("ImageView", owner: self, options: nil)?.first as? ImageView else {return}
            photoView.frame = frame
            photoView.imageView.image = UIImage(named: image["imageName"] as! String)
            photoView.label.text = image["description"] as? String
            
            scrollView.addSubview(photoView)
        }
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.setContentOffset(CGPoint.zero, animated: false)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.overlayView.alpha = 0
                sender.alpha = 0
            }, completion:{ _ in
                self.navigationController?.popViewController(animated: true)
            })
            
        }
        
    }
}

// MARK Animation
extension ImageViewController:Scaling {
    func animateImageView(transition: ImageTransitionDelegate) -> UIImageView? {
        return initialImageView
    }
}
