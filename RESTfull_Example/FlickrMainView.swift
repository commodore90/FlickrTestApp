//
//  ViewController.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 2/23/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import UIKit
import Foundation.FoundationErrors

class MainViewController: UIViewController {

    @IBOutlet weak var textRestFull: UITextField!
    
    let flicktRestFullAPIobj:flickrRestFullAPIManager = flickrRestFullAPIManager.init();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let flickrUserAuthenticationSegue:String = "flickrUserAuthenticationSegue"
    
    // Flickr authentication
    @IBAction func flickrAuthButton(_ sender: UIButton) {
        
        // get Request Token
        flicktRestFullAPIobj.getOAuthRequestToken() { (requestTokenCompletion) in
            
            switch requestTokenCompletion {
            case .Success( _):
                // do User Authentication
                self.performSegue(withIdentifier: self.flickrUserAuthenticationSegue, sender: self)
                break;
            case .Failure(let oauthError):
                print("oauth Error: \(oauthError)");
                break;
                
            }
        }
    }
    
}

