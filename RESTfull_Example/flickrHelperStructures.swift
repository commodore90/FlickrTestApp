//
//  flickrHelperStructures.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/7/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation

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

enum AsyncResult<T> {
    case Sucess(T);
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
    
    init(requestTokenDictionary:flickrResponceDictionary) {
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
    
}
/* 
     Flickr HTTP API clsses
*/

class flickrAPIRequest {
    var httpMethod:RequestMethod;
    var path:String;                         // full URL path, without query params
    var headers:flickrJSON?;
    var query:[URLQueryItem]?;
    var body:Data?;
    
    init(httpMethod:RequestMethod, path:String, headers:flickrJSON?, query:[URLQueryItem]?, body:Data?) {
        self.httpMethod = httpMethod;
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
