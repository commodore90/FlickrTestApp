//
//  FlickrPhotoSelectViewController.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/21/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import UIKit

class FlickrPhotoSelectViewController: UIViewController {

    var carButtonTapped:Bool   = false;
    var planeButtonTapped:Bool = false;
    var bikeButtonTapped:Bool  = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /*
     Selection View outlets
    */
    @IBAction func CarButtonTapped(_ sender: UIButton) {
        carButtonTapped = true;
    }
    
    
    @IBAction func PlaneButtonTapped(_ sender: UIButton) {
        planeButtonTapped = true;
    }
    
    
    @IBAction func BikeButtonTapped(_ sender: UIButton) {
        bikeButtonTapped = true;
    }
	
    
    // MARK: - Navigation
    // Before transition to FlickrPhotoviewController set delegate field
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ((segue.identifier?.range(of: "PresentPhoto")) != nil) {
            
            let destinationVC:FlickrPhotoViewController = segue.destination as! FlickrPhotoViewController;
            
            if carButtonTapped {
                let carStateManager:PhotoViewCarStateManager = PhotoViewCarStateManager.init();
                destinationVC.stateManagerDelegate = carStateManager;
            }
            
            
            if planeButtonTapped {
                let planeStateManager:PhotoViewPlaneStateManager = PhotoViewPlaneStateManager.init();
                destinationVC.stateManagerDelegate = planeStateManager;
            }
            
            
            if bikeButtonTapped {
                let bikeStateManager:PhotoViewBikeStateManager = PhotoViewBikeStateManager.init();
                destinationVC.stateManagerDelegate = bikeStateManager;
            }
        }
        
        carButtonTapped   = false;
        planeButtonTapped = false;
        bikeButtonTapped  = false;
    }

}
