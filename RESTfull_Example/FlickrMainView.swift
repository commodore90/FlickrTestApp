//
//  ViewController.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 2/23/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

/*
 NASA : "https://api.nasa.gov/planetary/apod" + ? + "api_key=HSJcqHFYHeB8l23rA0zTbAsQ9pYzGMpK31ToApfV"
 
 Flickr : Authentication URL: " https://www.flickr.com/auth-72157678460088022"
 
 */
import UIKit
import Foundation.FoundationErrors

class MainViewController: UIViewController {

    @IBOutlet weak var textRestFull: UITextField!
    
    // see instancetype -> sharedinstance
    let flicktRestFullAPIobj:flickrRestFullAPIManager = flickrRestFullAPIManager.init();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let flickrUserAuthenticationSegue:String = "flickrUserAuthenticationSegue"
    
    // Flickr authentication
    @IBAction func flickrAuthButton(_ sender: UIButton) {
        
        /* This should be used with programaticaly instatiated controller, and with pushViewController
        let controller: FlickrUserAuthenticationViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FlickrUserAuthenticationViewController") as! FlickrUserAuthenticationViewController
        
        */
        
        // get Request Token
        flicktRestFullAPIobj.getOAuthRequestToken() { (requestTokenCompletion) in
            
            switch requestTokenCompletion {
            case .Success( _):
                
                // do User Authentication
                self.performSegue(withIdentifier: self.flickrUserAuthenticationSegue, sender: self)
                
                /*
                controller.flickrAuthenticationURLstr = "http://google.com"
                self.navigationController?.pushViewController(controller, animated: true)
                */
                
                // get Access Token using Request Token & User authorization
                
                break;
            case .Failure(let oauthError):
                print("oauth Error: \(oauthError)");
                break;
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == flickrUserAuthenticationSegue {
            let destinationViewController = segue.destination as! FlickrUserAuthenticationViewController
            destinationViewController.flickrAuthenticationURLstr = "http://www.google.com";
        }
    }
}






/*
    Some obsolite code
 
 
 // timer settings
 var timer = Timer.init()
 var counter:Int16 = 0;
 counter = 0;
 //        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.timerUpdate), userInfo: nil,repeats: true);
 
 
 //extension Data {
 //    func hexString() -> String {
 //        let string = self.map{Int($0).hexString()}.joined()
 //        return string
 //    }
 //
 //    func MD5() -> Data {
 //        var result = Data(count: Int(CC_MD5_DIGEST_LENGTH))
 //        _ = result.withUnsafeMutableBytes {resultPtr in
 //            self.withUnsafeBytes {(bytes: UnsafePointer<UInt8>) in
 //                CC_MD5(bytes, CC_LONG(count), resultPtr)
 //            }
 //        }
 //        return result
 //    }
 //}
 //
 //extension String {
 //    func hexString() -> String {
 //        return self.data(using: .utf8)!.hexString()
 //    }
 //
 //    func MD5() -> String {
 //        return self.data(using: .utf8)!.MD5().hexString()
 //    }
 //}
 
 
 
     func timerUpdate() {
         counter = counter + 1;
         textRestFull.text = "Text Example" + String(self.counter);
 
         let urlTest = "https://api.nasa.gov/planetary/apod"; //"https://private-a3dfa-porterandsailapirary.apiary-mock.com/oauth/token";
         let urlTestWithParams = urlTest + "?" + APIkey;
 
         let completeURL = URL(string: urlTestWithParams);
 
         // configuration
         let config = URLSessionConfiguration.default;
         config.timeoutIntervalForResource = 2.0;
         let request = NSMutableURLRequest(url: completeURL!);
         let session = URLSession(configuration: config);
 
         // URLSession.shared.dataTask ....?
         /* The singleton shared session (which has no configuration object) is for basic requests. It is not as customizable as sessions that you create, but it serves as a good starting point if you have very limited requirements. You access this session by calling the shared class method. See that method’s discussion for more information about its limitations.
         */
 
         request.httpMethod = "GET"
 
         let task = session.dataTask(with: request as URLRequest) {  // Cast tto URLRequest because request was decalared as NSMutableURLRequest
             (data, response, error) in
 
             if error != nil{
                 print("error = \(error)");
                 return
             }
 
             let responceString = String(data: data!, encoding: String.Encoding.utf8);
             print("responceString = \(responceString)");
 
             // Convert server json response to NSDictionary
             do {
                 if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
 
                     // Print out dictionary
                     print(convertedJsonIntoDict)
 
                     // Get value by key
                     let accessToken = convertedJsonIntoDict["access_token"] as? String
                     if (accessToken != nil) {
                         print(accessToken!)
                     }
 
                 }
             } catch let error as NSError {
                 print(error.localizedDescription)
             }
 
             DispatchQueue.main.async {
                 //Update UI
             }
         }
         task.resume()
     }

 */
