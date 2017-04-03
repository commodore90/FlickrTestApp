//
//  flickrHelperStructures.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/7/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation
import UIKit

struct flickrOauthParams {
    
}

/*
    Flickr Enumerations
*/
enum RequestMethod: String {
    case GET    = "GET"
    case POST   = "POST"
    case PUT    = "PUT"
    case DELETE = "DELETE"
    case NOTSET = "NOTSET"
}

enum ResponseFormat: String {
    case JSON = "JSON"
    case TEXT = "TEXT"
}

/*
 Asynchronus methodes CompletionHandler Types
*/
enum AsyncResult<T> {
    case Success(T);
    case Failure(Error?);
}

/*
    Flickr Token Classes
*/

class flickrRequestToken {
    var oauthToken:String;
    var oauthTokenSecret:String;
    var oauthCallbackConfirmed:String;
    
    init() {
        self.oauthToken             = "";
        self.oauthTokenSecret       = "";
        self.oauthCallbackConfirmed = "";
    }
    
    init(oauthToken:String, oauthTokenSecret:String, oauthCallbackConfirmed:String) {
        self.oauthToken             = oauthToken;
        self.oauthTokenSecret       = oauthTokenSecret;
        self.oauthCallbackConfirmed = oauthCallbackConfirmed;
    }
    
    init(requestTokenDictionary:flickrResponseDictionary) {
        // TODO: instead of print use assert
        if let oauthCallbackConfirmed:String = requestTokenDictionary[flickrConstants.kOauthCallbackConfirmed] {
            self.oauthCallbackConfirmed = oauthCallbackConfirmed;
        }
        else {
            print("ERROR! Request Token is incomplete!");
            self.oauthCallbackConfirmed = "";
        }
        
        if let oauthToken:String = requestTokenDictionary[flickrConstants.kOauthToken] {
            self.oauthToken = oauthToken;
        }
        else {
            print("ERROR! Request Token is incomplete!");
            self.oauthToken = "";
        }

        if let oauthTokenSecret:String = requestTokenDictionary[flickrConstants.kOauthTokenSecret] {
            self.oauthTokenSecret = oauthTokenSecret;
        }
        else {
            print("ERROR! Request Token is incomplete!");
            self.oauthTokenSecret = "";
        }
    }
}

class flickrAccessToken {
    var fullName:String;
    var accessToken:String;
    var accessTokenSecret:String;
    var userNsid:String;
    var userName:String;
    
    init() {
        self.fullName          = "";
        self.accessToken       = "";
        self.accessTokenSecret = "";
        self.userNsid          = "";
        self.userName          = "";
    }
    
    init(fullName:String, accessToken:String, accessTokenSecret:String, userNsid:String, userName:String) {
        self.fullName          = fullName;
        self.accessToken       = accessToken;
        self.accessTokenSecret = accessTokenSecret;
        self.userNsid          = userNsid;
        self.userName          = userName;
    }
    
    init(accessTokenDictionary:flickrResponseDictionary) {
        if let fullName:String = accessTokenDictionary[flickrConstants.kOauthFullName] {
            self.fullName = fullName;
        }
        else {
            print("ERROR! Access Token is incomplete!" + flickrConstants.kOauthFullName)
            self.fullName = "";
        }
        
        if let accessToken:String = accessTokenDictionary[flickrConstants.kOauthToken] {
            self.accessToken = accessToken;
        }
        else {
            print("ERROR! Request Token is incomplete!" + flickrConstants.kOauthToken);
            self.accessToken = "";
        }
        
        if let accessTokenSecret = accessTokenDictionary[flickrConstants.kOauthTokenSecret] {
            self.accessTokenSecret = accessTokenSecret;
        }
        else {
            print("ERROR! Request Token is incomplete!" + flickrConstants.kOauthTokenSecret);
            self.accessTokenSecret = "";
        }
        
        if let userNsid:String = accessTokenDictionary[flickrConstants.kOauthUserNsid] {
            self.userNsid = userNsid;
        }
        else {
            print("ERROR! Request Token is incomplete!" + flickrConstants.kOauthUserNsid);
            self.userNsid = "";
        }
        
        if let userName = accessTokenDictionary[flickrConstants.kOauthUserName] {
            self.userName = userName;
        }
        else {
            print("ERROR! Request Token is incomplete!" + flickrConstants.kOauthUserName);
            self.userName = "";
        }
    }
}

class flickrUserAuthorization {
    var oauthVerifier:String;
    
    init() {
        self.oauthVerifier = "";
    }
    
    init (oauthVerifier:String) {
        if let oauthVerifier:String = oauthVerifier {
            self.oauthVerifier = oauthVerifier;
        }
        else {
            print("ERROR! oauth Verifier is incomplete!");
            self.oauthVerifier = "";
        }
    }
}


/* 
     Flickr HTTP API clsses
*/

class flickrAPIRequest {
    var httpMethod:RequestMethod;
    var host:String
    var path:String;                         // full URL path, without query params
    var headers:flickrJSON?;
    var query:[URLQueryItem]?;
    var body:Data?;
    
    init(httpMethod:RequestMethod,host:String ,path:String, headers:flickrJSON?, query:[URLQueryItem]?, body:Data?) {
        self.httpMethod = httpMethod;
        self.host       = host;
        self.path       = path;
        self.headers    = headers;
        self.query      = query;
        self.body       = body;
    }
}

class flickrAPIResponse {
    var responseFormat:ResponseFormat;
    var responseError:Error?;
    var responseData:Data?;
    var responseCode:Int?;
    
    init(responseFormat:ResponseFormat, responseError:Error?, responseData:Data?, responseCode:Int?) {
        self.responseFormat = responseFormat;
        self.responseError  = responseError;
        self.responseData   = responseData;
        self.responseCode   = responseCode;
    }
}

extension flickrAPIRequest {
    func getURL() -> URL {
        let requestURL:NSURLComponents = NSURLComponents.init();
        
        requestURL.scheme     = flickrConstants.kBaseHostURLScheme;
        requestURL.host       = self.host;
        requestURL.path       = self.path;
        requestURL.queryItems = self.query;
        
        return requestURL.url!
    }
}

/*
    Flickr Photo API
*/

class flickrPhotoContext {
    var id:String;
    var secret:String;
    var server:String;
    var farm:String;
    
    var thumbURL:URL?;
    var thumbPhoto:UIImage?;   // Data
    var photoInfo:flickrPhotoInfo?;
    
    init() {
        self.id     = "";
        self.secret = "";
        self.server = "";
        self.farm   = "";
    }
    
    init (id:String, secret:String, server:String, farm:String, thumbURL:URL, photoInfo: flickrPhotoInfo) {
        self.id        = id;
        self.secret    = secret;
        self.server    = server;
        self.farm      = farm;
        self.thumbURL  = thumbURL;
        
        let photoInfo = flickrPhotoInfo.init(
            originalFormat: photoInfo.originalFormat!,
            title:          photoInfo.dateTaken!,
            dateTaken:      photoInfo.title!
        );
        
        self.photoInfo = photoInfo;
    }

}

class flickrPhotoInfo {
    var originalFormat:String?;
    var title:String?;
    var dateTaken:String?;

    init() {
        self.originalFormat = "";
        self.title          = "";
        self.dateTaken      = "";
    }
    
    init(originalFormat:String, title:String, dateTaken:String) {
        self.originalFormat = originalFormat;
        self.title          = title;
        self.dateTaken      = dateTaken;
    }
    
}
