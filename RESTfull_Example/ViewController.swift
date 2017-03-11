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

class ViewController: UIViewController {

    @IBOutlet weak var textRestFull: UITextField!
    
    let APIkey:String = "api_key=HSJcqHFYHeB8l23rA0zTbAsQ9pYzGMpK31ToApfV";
    var timer = Timer.init()
    var counter:Int16 = 0;
    
    // see instancetype -> sharedinstance
    let flicktRestFullAPIobj:flickrRestFullAPIManager = flickrRestFullAPIManager.init();
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        counter = 0;
//        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.timerUpdate), userInfo: nil,repeats: true);
        
    }

    func MD5(string: String) -> Data? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {
            digestBytes in messageData.withUnsafeBytes {
                messageBytes in CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData
    }
    
    
//    func timerUpdate() {
//        counter = counter + 1;
//        textRestFull.text = "Text Example" + String(self.counter);
//        
//        let urlTest = "https://api.nasa.gov/planetary/apod"; //"https://private-a3dfa-porterandsailapirary.apiary-mock.com/oauth/token";
//        let urlTestWithParams = urlTest + "?" + APIkey;
//        
//        let completeURL = URL(string: urlTestWithParams);
//        
//        // configuration 
//        let config = URLSessionConfiguration.default;
//        config.timeoutIntervalForResource = 2.0;
//        let request = NSMutableURLRequest(url: completeURL!);
//        let session = URLSession(configuration: config);
//        
//        // URLSession.shared.dataTask ....?
//        /* The singleton shared session (which has no configuration object) is for basic requests. It is not as customizable as sessions that you create, but it serves as a good starting point if you have very limited requirements. You access this session by calling the shared class method. See that method’s discussion for more information about its limitations.
//        */
//
//        request.httpMethod = "GET"
//        
//        let task = session.dataTask(with: request as URLRequest) {  // Cast tto URLRequest because request was decalared as NSMutableURLRequest
//            (data, response, error) in
//            
//            if error != nil{
//                print("error = \(error)");
//                return
//            }
//
//            let responceString = String(data: data!, encoding: String.Encoding.utf8);
//            print("responceString = \(responceString)");
//            
//            // Convert server json response to NSDictionary
//            do {
//                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
//                    
//                    // Print out dictionary
//                    print(convertedJsonIntoDict)
//                    
//                    // Get value by key
//                    let accessToken = convertedJsonIntoDict["access_token"] as? String
//                    if (accessToken != nil) {
//                        print(accessToken!)
//                    }
//                    
//                }
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//            
//            DispatchQueue.main.async {
//                //Update UI
//            }
//        }
//        task.resume()
//    }
    
    
    // Flickr authentication
    // MD5 - crypto algorithm for generating 128-bit hash value
    
    @IBAction func flickrAuthButton(_ sender: UIButton) {
        
        /*
        // generate flickr Signature
        let flickrSignature:String = flickrHelperMethodes.flickrGenerateOauthSignature()
        
        // call SH1 calculation and generate hashMD5Signature
        let hashSH1Signature:String = flickrHelperMethodes.flickrCalculteSHA1FromString(string: flickrSignature)!;
        print("Calculated hashSHA1Sum: " + hashSH1Signature);
        
        // generate Nonce
        let flickrNonce:String = flickrHelperMethodes.flickrGenerateOauthNonce();
        print("Generated Nonce: " + flickrNonce);
        
        // generate timestamp from 1970
        let flickrTimestamp:String = flickrHelperMethodes.flickrGenerateOauthTimestamp();
        print("Generated Timestamp: " + flickrTimestamp);
        
        */
        
        // get Access Token
        
        flicktRestFullAPIobj.getOAuthRequestToken();  // callbackURL: flickrHelperMethodes.flickrGenerateRequestTokenURL()
        
    }
}




// let timestamp = String(Int64(Date().timeIntervalSince1970))
// let nonce = OAuthSwiftCredential.generateNonce()
// 
// func generateNonce() -> String {
// let uuidString = UUID().uuidString
// return uuidString.substring(to: 8)

