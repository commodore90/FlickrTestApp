//
//  flickrConstants.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 2/28/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation


struct flickrConstants {
    // oAuth Constants
    static let kOauthVersion:String         = "1.0";
    static let kOauthSignatureMethod:String = "HMAC-SHA1";
    static let kOauthCallback:String        = "https://www.google.rs"; // "oob";
    static let kOauthCallbackConfirmed      = "oauth_callback_confirmed";
    static let kOauthTokenSecret            = "oauth_token_secret";
    static let kOauthToken                  = "oauth_token";
    
    // API Constants
    static let kApiKey:String    = "8324d02c6f6d3bb625a23c1ba1f1e7d7";
    static let kSecretKey:String = "4aebcb00756dcd78";
    
    // Flickr API Methodes Constants
    static let kGetFullToken:String = "flickr.auth.getFullToken"
    
    // Flickr API URL Base
    static let kBaseHostURLScheme:String  = "https";
    static let kBaseHostURL:String        = "www.flickr.com";
    
    // Flickr API URL Constants
    static let kOauthServiceURL:String      = "/services/oauth";
    static let kGetRequestTokenURL:String   = "/request_token";
    static let kGetUserAuthorization:String = "/authorize";
    static let kGetAccessToken:String       = "/access_token";
    static let kCallFlickrAPI:String        = "/rest";
    
    // Flickr JSON mark
    static let kFlickrJSONmark:String       = "jsonFlickrApi";
    
    
    
    
    
    /*
     
        Testing purpose only
        consumer_key = API key
        consumer_secret = secret
     
    */
//    static let kInputSignatureString:String = "000005fab4534d05api_key9a0554259914a86fb9e7eb014e4e5d52methodflickr.auth.getFullTokenmini_token123-456-789"
    
    static let kTestInputSignatureString:String = "GET&https%3A%2F%2Fwww.flickr.com%2Fservices%2Foauth%2Frequest_token&oauth_callback%3Dhttp%253A%252F%252Fwww.example.com%26oauth_consumer_key%3D653e7a6ecc1d528c516cc8f92cf98611%26oauth_nonce%3D95613465%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1305586162%26oauth_version%3D1.0"
    
    // Consumer Secret : $params['api_key'] . '&' . $params['secret'];
    static let kInputConsumerSecret:String = "";
    
    // 
    static let kInputTokenSecret:String    = "";
    
    
//    struct Path {
//        static let Documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
//        static let Tmp = NSTemporaryDirectory()
//    }
    
}
