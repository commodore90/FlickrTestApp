//
//  flickrRestFullAPI.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/1/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation

class flickrRestFullAPIManager : flickrRestFullBaseAPIManager {
    
    override init() {
        
    }
    
    /*
      
        Get Request Token from Flickr Server
     
    */
    func getOAuthRequestToken() -> flickrRequestToken {   // success: TokenSuccessHandler, failure: FailureHandler? //
        // prepare API methode for http request execution
        let apiRequest:flickrAPIRequest = flickrHelperMethodes.flickrGenerateRequestTokenRequest();
        var requestTokenResponce:flickrResponceDictionary = flickrResponceDictionary.init();
        var requestToken:flickrRequestToken = flickrRequestToken.init();
        
        // call flickr API methode for initiating http request
        let getOauthRequestTask:URLSessionDataTask = super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (flickrAPIResponse) in
            
            print("completionHandler: response is returned to flickr restfull Flickr API!!!");
            
            print("Response Data : " + String(data: flickrAPIResponse.responseData!, encoding: String.Encoding.utf8)!);
            
            var responseString:String = String(data: flickrAPIResponse.responseData!, encoding: String.Encoding.utf8)!;
            // create onSuccess/onFailure blocks
            
            // Parse oauth Token and oauth Token secret
            requestTokenResponce = flickrHelperMethodes.flickrResponseStringParser(responseString: responseString, flickrParseArguments: ["oauth_token", "oauth_token_secret"]);
            
            
        }!
     
        requestToken = flickrRequestToken(requestTokenDictionary: requestTokenResponce);
        return requestToken;
    }
    
    
    /*
        
        Get Access Token based on Request Token and Token Secret
     
    */
    func getOAuthAccessToken() {   // success: TokenSuccessHandler, failure: FailureHandler?
        
        // prepare API methode for http request execution
        
        
    }
    
}
