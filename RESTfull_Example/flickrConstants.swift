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
    static let kOauthCallback:String        = "https://www.stefantestapp.rs"; // www.stefantestapp.rs
    static let kOauthCallbackConfirmed      = "oauth_callback_confirmed";
    static let kOauthTokenSecret            = "oauth_token_secret";
    static let kOauthToken                  = "oauth_token";
    static let kOauthFullName               = "fullname";
    static let kOauthUserNsid               = "user_nsid";
    static let kOauthUserName               = "username";
    
    // API Constants
    static let kApiKey:String               = "8324d02c6f6d3bb625a23c1ba1f1e7d7";
    static let kSecretKey:String            = "4aebcb00756dcd78";
    
    // Flickr API Methodes Constants
    static let kGetFullToken:String         = "flickr.auth.getFullToken"
    
    // Flickr API URL Base
    static let kBaseHostURLScheme:String    = "https";
    static let kBaseHostURL:String          = "www.flickr.com";
    
    // Flickr API URL Constants
    static let kOauthServiceURL:String      = "/services/oauth";
    static let kGetRequestTokenURL:String   = "/request_token";
    static let kGetUserAuthorization:String = "/authorize";
    static let kGetAccessToken:String       = "/access_token";
    static let kCallFlickrAPI:String        = "/rest";
    
    // Flickr JSON mark
    static let kFlickrJSONmark:String       = "jsonFlickrApi";
    
    // Consumer Secret : $params['api_key'] . '&' . $params['secret'];
    static let kInputConsumerSecret:String  = "";
    
    // 
    static let kInputTokenSecret:String     = "";
    
}
