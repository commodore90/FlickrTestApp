//
//  FlickrPhotoViewController.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/16/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import UIKit

class FlickrPhotoViewController: UIViewController, FlickrPhotoViewControllerProtocol {

    @IBOutlet weak var flickrImageView: UIImageView!
    
    /*
        API instances
    */
    var flickrLoggingAPI:FlickrLoggingTestAPI = FlickrLoggingTestAPI.init();
    var flickrPhotoAPI  :FlickrPhotoAPI       = FlickrPhotoAPI.init();
    
    /* 
        Implement delegate properties and methode
    */
    var stateManagerDelegate: FlickrPhotoViewStateManagerProtocol?;
    
    func showFlickrPhoto(photo: UIImage) {
        DispatchQueue.main.async {
            self.flickrImageView.image = photo;
        }
    }
    
    /*
     Main Application Behavior
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set Photo View Delegate 
        self.stateManagerDelegate?.photoViewDelegate = self;
        
        /*
         Format image View
         */
        flickrImageView.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight,
            .flexibleBottomMargin,
            .flexibleRightMargin,
            .flexibleLeftMargin,
            .flexibleTopMargin
        ]
        flickrImageView.contentMode   = UIViewContentMode.scaleAspectFit;
        flickrImageView.clipsToBounds = true;
        
        
        /*
            test if User is logged in
        */
        self.stateManagerDelegate?.testIfUserIsLoggedIn();
        
        /*
            download image and show it
        */
        self.stateManagerDelegate?.fetchPhoto();
        
    }
}
