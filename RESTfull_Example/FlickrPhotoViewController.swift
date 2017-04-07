//
//  FlickrPhotoViewController.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/16/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import UIKit

class FlickrPhotoViewController: UIViewController { // , FlickrPhotoViewControllerProtocol

    @IBOutlet weak var flickrImageView: UIImageView!;
    @IBOutlet weak var flickrDownloadProgressSpinner: UIActivityIndicatorView!;
    
    /*
    Local Variables
    */
    var photoContextToPresent: FlickrPhotoContext?;
    var loadingSpinner: FlickrProgressIndicator?;
    
    /*
        API instances
    */
    var flickrLoggingAPI:FlickrLoggingTestAPI = FlickrLoggingTestAPI.init();
    var flickrPhotoAPI  :FlickrPhotoAPI       = FlickrPhotoAPI.init();
    
    /* 
        Implement delegate properties and methode
    */
    // var stateManagerDelegate: FlickrPhotoViewStateManagerProtocol?;
    var photoSelectViewReturnDelegate: FlickrPhotoSelectViewReturnProtocol?;
    
    func showFlickrPhoto(photo: UIImage) {
        DispatchQueue.main.async {
            self.flickrImageView.image = photo;
        }
    }
    
    
    /*
     Main Application Behavior
    */
    
    override func viewWillDisappear(_ animated : Bool) {    // TableViewController Back button pressed!
        super.viewWillDisappear(animated)
        
        photoSelectViewReturnDelegate?.requestLoadingSpinerStop();
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadingSpinner = FlickrProgressIndicator.init(inview: self.view, loadingViewColor: UIColor.gray, indicatorColor: UIColor.red, msg: "Loading Photo");
        self.view.addSubview(loadingSpinner!)
        self.loadingSpinner!.start();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        self.fetchPhoto(photoContext: photoContextToPresent!) { (fetchPhotoRsp) in
            switch (fetchPhotoRsp) {
            case .Success(_):
                self.loadingSpinner!.stop();
                break;
            case .Failure(let fetchPhotoError):
                print("fetchPhoto Error \(fetchPhotoError)");
                break;
            }
        }
    }
    
    func fetchPhoto(photoContext: FlickrPhotoContext, completionHandler: @escaping (AsyncResult<Bool>) -> ()) {  // added new argument, photo context
        // var photoContext:FlickrPhotoContext = FlickrPhotoContext.init();
        // var photoIterator:Int?;
        
        self.flickrPhotoAPI.flickrDownloadPhotoFromURLUsingPhotoContext(photoContext: photoContext) { (downloadPhoto) in
            switch downloadPhoto {
            case .Success(let data):
                // Load and show some image
                self.showFlickrPhoto(photo: UIImage(data: data)!)
                self.loadingSpinner?.stop();
                completionHandler(AsyncResult.Success(true));
                break;
            case .Failure(let downloadPhotoError):
                print("Download Photo Error: \(downloadPhotoError)");
                completionHandler(AsyncResult.Failure(downloadPhotoError));
            }
        }
    }

}
