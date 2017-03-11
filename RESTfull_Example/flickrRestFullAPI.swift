//
//  flickrRestFullAPI.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/1/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation

class flickrRestFullAPIManager : flickrRestFullBaseAPIManager {
    
    var requestToken:flickrRequestToken?;
    var accessToken:flickrAccessToken?;
    
    override init() {
        
    }
    
    /*
      
        Get Request Token from Flickr Server
     
    */
    func getOAuthRequestToken() {  // -> flickrRequestToken?
        // prepare API methode for http request execution
        let apiRequest:flickrAPIRequest = flickrHelperMethodes.flickrGenerateRequestTokenRequest();
        var requestTokenResponce:flickrResponceDictionary = flickrResponceDictionary.init();
        var responseString:String = "";
        var requestToken:flickrRequestToken?;
        // var requestToken:flickrRequestToken = flickrRequestToken.init();
        
        // call flickr API methode for initiating http request
        // let getOauthRequestTask:URLSessionDataTask =
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (flickrAPIResponse) in
            
            switch flickrAPIResponse {
            case .Sucess(let flickrResponse):
                print("completionHandler: response is returned to flickr restfull Flickr API!!!");
                print("Response Data : " + String(data: flickrResponse.responseData!, encoding: String.Encoding.utf8)!);
                responseString = String(data: flickrResponse.responseData!, encoding: String.Encoding.utf8)!;
                requestTokenResponce = flickrHelperMethodes.flickrResponseStringParser(responseString: responseString, flickrParseArguments: ["oauth_token", "oauth_token_secret"]);

                requestToken = flickrRequestToken(requestTokenDictionary: requestTokenResponce);
                self.requestToken = requestToken!;
                break;
                
            case .Failure(let flickrError):
                print("completionHandler: \(flickrError)");
                self.requestToken = nil;
                break;
            }
    
        }

        // code written here, in body of getOAuthRequestToken() would be concurent with http API method task
        // so task would never have time to execute!
    }
    
    
    /*
        
        Get Access Token based on Request Token and Token Secret
     
    */
    func getOAuthAccessToken() {   // success: TokenSuccessHandler, failure: FailureHandler?
        
        // prepare API methode for http request execution
        
        
    }
    
}
