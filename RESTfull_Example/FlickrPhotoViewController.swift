//
//  FlickrPhotoViewController.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/16/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import UIKit

class FlickrPhotoViewController: UIViewController, FlickrPhotoViewControllerProtocol {

    @IBOutlet weak var flickrImageView: UIImageView!;
    @IBOutlet weak var flickrDownloadProgressSpinner: UIActivityIndicatorView!;
    
    
    var loadingSpinner: ProgressIndicator?;
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        // loadingSpinner = ProgressIndicator(inview: self.view, loadingViewColor: UIColor.blue, indicatorColor: UIColor.gray, msg: "Loading Photo")
        // loadingSpinner!.stop();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Spinner
        loadingSpinner = ProgressIndicator.init(inview: self.view, loadingViewColor: UIColor.gray, indicatorColor: UIColor.red, msg: "Loading Photo");
        self.view.addSubview(loadingSpinner!)
        
        self.loadingSpinner!.start();
    }
    
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
        
        // DispatchQueue.global().async {
            /*
                test if User is logged in
            */
            self.stateManagerDelegate?.testIfUserIsLoggedIn();
            
            /*
                download image and show it
            */
            self.stateManagerDelegate?.fetchPhoto() { (completion) in
                switch completion {
                case .Success(_):
                    self.loadingSpinner?.stop();
                    break;
                case .Failure(let fetchPhotoError):
                    print("Photo Load failed: \(fetchPhotoError)")
                    break;
                }
                
            }
        // }
    }
}
