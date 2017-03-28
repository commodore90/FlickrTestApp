//
//  flickrPhotoLoadingSpinner.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/24/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import UIKit
import Foundation

class ProgressIndicator: UIView {
    
    var indicatorColor:UIColor
    var loadingViewColor:UIColor
    var loadingMessage:String
    var messageFrame = UIView()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    init(inview:UIView,loadingViewColor:UIColor,indicatorColor:UIColor,msg:String){
        
        
        self.indicatorColor   = indicatorColor
        self.loadingViewColor = loadingViewColor
        self.loadingMessage   = msg

        super.init(frame: CGRect(x: Int(inview.frame.midX - 50), y: Int(inview.frame.midY - 80), width: 100, height: 100));
        initalizeCustomIndicator()
    }
    convenience init(inview:UIView) {
        
        self.init(inview: inview,loadingViewColor: UIColor.brown,indicatorColor:UIColor.black, msg: "Loading..")
    }
    convenience init(inview:UIView,messsage:String) {
        
        self.init(inview: inview,loadingViewColor: UIColor.brown,indicatorColor:UIColor.black, msg: messsage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func initalizeCustomIndicator(){
        
        messageFrame.frame = self.bounds
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.tintColor = indicatorColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(x: self.bounds.origin.x, y: 0, width: 100, height: 100)
        
        print(activityIndicator.frame)
        let strLabel = UILabel(frame:CGRect(x: self.bounds.origin.x + 20, y: 0, width: self.bounds.width - (self.bounds.origin.x + 30) , height: 50));
        strLabel.font = UIFont.boldSystemFont(ofSize: 22);
        strLabel.text = loadingMessage;
        strLabel.adjustsFontSizeToFitWidth = true;
        strLabel.textColor = UIColor.white;
        strLabel.textAlignment = NSTextAlignment.center;
        messageFrame.layer.cornerRadius = 15;
        messageFrame.backgroundColor = loadingViewColor;
        messageFrame.alpha = 0.8;
        messageFrame.addSubview(activityIndicator);
        messageFrame.addSubview(strLabel);

    }
    
    func  start(){
        //check if view is already there or not. if again started
        if !self.subviews.contains(messageFrame) {
            
            activityIndicator.startAnimating();
            self.addSubview(messageFrame);
        }
    }
    
    func stop(){
        
        if self.subviews.contains(messageFrame) {
            
            activityIndicator.stopAnimating();
            messageFrame.removeFromSuperview();
        }
    }
}
