//
//  flickrRestFullAPI.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/1/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation

class flickrRestFullAPIManager : FlickrRestFullBaseAPIManager {
    
    override init() {
        
    }
    
    /*
        Get Request Token from Flickr Server
    */
    func getOAuthRequestToken(completionHandler: @escaping (AsyncResult<Bool>) -> ()) {  // -> flickrRequestToken?
        // prepare API methode for http request execution
        let apiRequest:flickrAPIRequest = flickrHelperMethodes.flickrGenerateRequestTokenRequest();
        var requestTokenResponse:flickrResponseDictionary = flickrResponseDictionary.init();
        var responseString:String?;
        var requestToken:flickrRequestToken?;
        var oauthCompletion:Bool = false;
        
        // call flickr API methode for initiating http request
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (flickrAPIResponse) in
            
            DispatchQueue.main.async {
                switch flickrAPIResponse {
                case .Success(let flickrResponse):
                    print("completionHandler: getRequestToken response is returned to flickr restfull Flickr API!!!");
                    print("Response Data : " + String(data: flickrResponse.responseData!, encoding: String.Encoding.utf8)!);
                    responseString = String(data: flickrResponse.responseData!, encoding: String.Encoding.utf8)!;
                    requestTokenResponse = flickrHelperMethodes.flickrResponseStringParser(responseString: responseString!, flickrParseArguments: ["oauth_token", "oauth_token_secret"]);

                    requestToken = flickrRequestToken(requestTokenDictionary: requestTokenResponse);
                    
                    // self.requestToken = requestToken!;
                    
                    FlickrSessionAuthorization.sharedInstance.setRequestToken(requestToken: requestToken!);
                    
                    oauthCompletion = true;
                    completionHandler(AsyncResult.Success(oauthCompletion));
                    break;
                    
                case .Failure(let flickrError):
                    print("completionHandler: \(flickrError)");
                    
                    // self.requestToken = nil;

                    completionHandler(AsyncResult.Failure(flickrError));
                    break;
                }
            }
        }

        // code written here, in body of getOAuthRequestToken() would be concurent with http API method task
        // so task would never have time to execute!
    }
    
    /*
     
     Get Access Token based on Request Token and Token Secret
     
     */
    func getOAuthAccessToken(requestToken: flickrRequestToken, userAuthorization:flickrUserAuthorization, completionHandler: @escaping (AsyncResult<Bool>) -> ()) {
        // prepare API methode for http request execution
        let apiRequest:flickrAPIRequest = flickrHelperMethodes.flickrGenerateAccessTokenRequest(requestToken: requestToken, userAuthorization: userAuthorization)
        var accessTokenResponse:flickrResponseDictionary = flickrResponseDictionary.init();
        var responseString:String?;
        var accessToken:flickrAccessToken?;
        
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (flickrAPIResponse) in
            
            DispatchQueue.main.async {
                switch flickrAPIResponse {
                case .Success(let flickrResponse):
                    print("completionHandler: getAccessToken response is returned to flickr restfull Flickr API!!!");
                    print("Response Data : " + String(data: flickrResponse.responseData!, encoding: String.Encoding.utf8)!);
                    responseString = String(data: flickrResponse.responseData!, encoding: String.Encoding.utf8)!;
                    accessTokenResponse = flickrHelperMethodes.flickrResponseStringParser(responseString: responseString!, flickrParseArguments: ["oauth_token", "oauth_token_secret"]);
                    
                    accessToken = flickrAccessToken.init(accessTokenDictionary: accessTokenResponse);
                    
                    // store access Token to shaterdInstance
                    FlickrSessionAuthorization.sharedInstance.setAccessToken(accessToken: accessToken!);
                    
                    completionHandler(AsyncResult.Success(true));
                    
                    break;
                case .Failure(let flickrError):
                    print("completionHandler: \(flickrError)");
                    
                    // self.requestToken = nil;
                    
                    completionHandler(AsyncResult.Failure(flickrError));
                    break;
                }
            }
        }
    }
}
