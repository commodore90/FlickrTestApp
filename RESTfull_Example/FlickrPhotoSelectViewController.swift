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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ((segue.identifier?.range(of: "PhotoSelect")) != nil) {
            print(segue.identifier);
            
            
        }
    }

}
