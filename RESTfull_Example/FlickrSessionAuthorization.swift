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
    var requestToken:flickrRequestToken?;
    var accessToken:flickrAccessToken?;
    var userAuthorization:flickrUserAuthorization?;
    // var oauthSignature:String?;
    
    private init() {
        
    }
    
    // setters
    func setRequestToken(requestToken:flickrRequestToken) {
        self.requestToken = requestToken;
    }
    
    func setAccessToken(accessToken:flickrAccessToken) {
        self.accessToken = accessToken;
    }
    
    func setUserAuthorizatrion(userAuthorization:flickrUserAuthorization) {
        self.userAuthorization = userAuthorization;
    }
    
//    func setOauthSignature(oauthSignature:String) {
//        self.oauthSignature = oauthSignature;
//    }
    
    // getters
    func getRequestToken() -> flickrRequestToken {
        return self.requestToken!;
    }
    
    func getAccessToken() -> flickrAccessToken {
        return self.accessToken!;
    }
    
    func getUserAuthorization() -> flickrUserAuthorization {
        return self.userAuthorization!;
    }
    
//    func getOauthSignature() -> String {
//        return self.oauthSignature!;
//    }
    
//    static func getSharedRequestToken() -> flickrRequestToken{
//        return self.sharedInstance.requestToken!;
//    }
    
}

