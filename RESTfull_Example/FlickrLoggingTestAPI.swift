//
//  FlickrLoggingAPI.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/19/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation


class FlickrLoggingTestAPI : FlickrRestFullBaseAPIManager{
    
    
    func flickrLoginTest(completionHandler: @escaping (AsyncResult<Bool>) -> ()) { // accessToken: FlickrAccessToken, 

        let apiRequest:FflickrAPIRequest = FlickrHelperMethodes.fickrGenerateLoginTestRequest();
        var responseString:String?;
        var oauthCompletion:Bool = false;
        
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (FlickrAPIResponse) in
            
            DispatchQueue.main.async {
                switch FlickrAPIResponse {
                case .Success(let flickrResponse):
                    responseString = String(data: flickrResponse.responseData!, encoding: String.Encoding.utf8)!;
                    print("Response Data : " + responseString!);
                    
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
