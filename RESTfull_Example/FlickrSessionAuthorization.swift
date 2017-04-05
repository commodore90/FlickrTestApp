//
//  SessionAuthorization.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/15/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation

// Singleton shared resource container for:
//      requestToken
//      accessToken

final class FlickrSessionAuthorization {
    
    //MARK: Shared Instance
    static let sharedInstance: FlickrSessionAuthorization = FlickrSessionAuthorization()
    
    //MARK: Local Variable
    var requestToken:FlickrRequestToken?;
    var accessToken:FlickrAccessToken?;
    var userAuthorization:FlickrUserAuthorization?;
    // var oauthSignature:String?;
    
    private init() {
        
    }
    
    // setters
    func setRequestToken(requestToken:FlickrRequestToken) {
        self.requestToken = requestToken;
    }
    
    func setAccessToken(accessToken:FlickrAccessToken) {
        self.accessToken = accessToken;
    }
    
    func setUserAuthorizatrion(userAuthorization:FlickrUserAuthorization) {
        self.userAuthorization = userAuthorization;
    }
    
    // getters
    func getRequestToken() -> FlickrRequestToken {
        return self.requestToken!;
    }
    
    func getAccessToken() -> FlickrAccessToken {
        return self.accessToken!;
    }
    
    func getUserAuthorization() -> FlickrUserAuthorization {
        return self.userAuthorization!;
    }
    
    
}

