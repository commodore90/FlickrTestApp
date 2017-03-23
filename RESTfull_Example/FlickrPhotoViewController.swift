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
    var flickrLoggingAPI:FlickrLoggingTestAPI  = FlickrLoggingTestAPI.init();
    var flickrPhotoAPI  :FlickrPhotoAPI        = FlickrPhotoAPI.init();
    
    /* 
        Implement delegate properties and methode
    */
    var stateManagerDelegate: FlickrPhotoViewStateManagerProtocol?;   // ovo je klasa koja mora da implementrira FlickrPhotoViewStateManagerProtocol
    
    func showFlickrPhoto(photo: UIImage) {
        DispatchQueue.main.async {
            self.flickrImageView.image = photo;
        }
    }
    
    /*
        
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
        self.stateManagerDelegate?.fetchPhoto(); // fetchCustomPhoto()
        
    }
}



// state manager je bilo kog tipa. Treba mi interface gde ce pisati da svi state manageri moraju da imaju implementirano polje
//

// setuj polje state managera: referenca na self (view controller). to je requirement u interface-u
// stateManagerDelegate.



/* viewDidLoad->

 
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
 Test if user is logged in
 */
flickrLoggingAPI.flickrLoginTest() { (loginCompletion) in  // accessToken: FlickrSessionAuthorization.sharedInstance.getAccessToken()
    
    switch loginCompletion {
    case .Success(_):
        print("User is logged in");
    case .Failure(let loginError):
        print("Login error : \(loginError)")
    }
}

/*
 Search images by photo tag
 */
flickrPhotoAPI.flickrPhotosSearchByTag(photoTag: photoTag) { (photosSearch) in
    
    switch photosSearch {
        
    case .Success(let photoContextArray) :
        self.photoContextArray = photoContextArray;
        self.photoContext = self.photoContextArray[1];
        /*
         Download Photo
         */
        self.flickrPhotoAPI.flickrDownloadPhotoFromURL(photoContext: self.photoContext) { (downloadPhoto) in
            
            switch downloadPhoto {
            case .Success(let data):
                // Load some image
                self.flickrImageView.image = UIImage(data: data)
                
                break;
            case .Failure(let downloadPhotoError):
                print("Download Photo Error: \(downloadPhotoError)");
            }
        }
        
        print("Search Complete!");
        break;
    case .Failure(let photosSearchError):
        print("Photos Search error!: \(photosSearchError)");
        break;
    }
}
 
*/
