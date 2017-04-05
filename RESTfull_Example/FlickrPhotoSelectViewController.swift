//
//  FlickrPhotoSelectViewController.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/21/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import UIKit

class FlickrPhotoSelectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /*
     Selection View outlets
    */

    @IBOutlet weak var CarButton: UIButton!
    @IBOutlet weak var PlaneButton: UIButton!
    @IBOutlet weak var BikeButton: UIButton!
    
    // MARK: - Navigation
    // Before transition to FlickrPhotoviewController set delegate field
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC:FlickrTablePhotoSelectViewController = segue.destination as! FlickrTablePhotoSelectViewController;
        
        if ((segue.identifier?.range(of: "flickrPresentPhotoCarSegue")) != nil) {
            let carStateManager:TablePhotoCarStateManager = TablePhotoCarStateManager.init();
            destinationVC.stateManagerDelegate = carStateManager;
        }
        else if ((segue.identifier?.range(of: "flickrPresentPhotoPlaneSegue")) != nil) {
            let planeStateManager:TablePhotoPlaneStateManager = TablePhotoPlaneStateManager.init();
            destinationVC.stateManagerDelegate = planeStateManager;
        }
        else if ((segue.identifier?.range(of: "flickrPresentPhotoBikeSegue")) != nil) {
            let bikeStateManager:TablePhotoBikeStateManager = TablePhotoBikeStateManager.init();
            destinationVC.stateManagerDelegate = bikeStateManager;
        }
    
    }
}
