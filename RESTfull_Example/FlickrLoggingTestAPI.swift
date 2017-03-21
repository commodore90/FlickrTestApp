//
//  FlickrLoggingAPI.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/19/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation


class FlickrLoggingTestAPI : FlickrRestFullBaseAPIManager{
    
    
    func flickrLoginTest(completionHandler: @escaping (AsyncResult<Bool>) -> ()) { // accessToken: flickrAccessToken, 

        let apiRequest:flickrAPIRequest = flickrHelperMethodes.fickrGenerateLoginTestRequest();
        var flickrLoginResponse:flickrResponseDictionary = flickrResponseDictionary.init();
        var responseString:String?;
        var oauthCompletion:Bool = false;
        var responseJson = [String:String]();
        
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (flickrAPIResponse) in
            
            DispatchQueue.main.async {
                switch flickrAPIResponse {
                case .Success(let flickrResponse):
                    responseString = String(data: flickrResponse.responseData!, encoding: String.Encoding.utf8)!;
                    print("Response Data : " + responseString!);
                    
                    // parse output data if json or string if text and if some of known flickr errors are present -> set error in .Failure block
                
                    // Parse response JSON data
                    // var parserKeys:[String] = ["user", "stat"]
                    // responseJson = flickrHelperMethodes.flickrJSONParser(data: flickrResponse.responseData!)!
                    
                    oauthCompletion = true;
                    completionHandler(AsyncResult.Success(oauthCompletion));
                    break;
                    
                case .Failure(let flickrError):
                    print("completionHandler: \(flickrError)");
                    
                    completionHandler(AsyncResult.Failure(flickrError));
                    break;
                }
            }
        }
    }
    
    
}
