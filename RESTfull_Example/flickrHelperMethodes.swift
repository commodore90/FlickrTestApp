//
//  flickrHelperMethodes.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 2/28/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

/* Usefull links:
 
 1. https://www.flickr.com/services/api/auth.oauth.html#access_token
 2. https://www.flickr.com/services/api/auth.howto.mobile.html
 
 */

import Foundation

extension String {
    var RFC3986URLEncoded:String {
        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharset = NSCharacterSet(charactersIn: unreservedChars)
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: unreservedCharset as CharacterSet)
        return encodedString ?? self
    }
    
}


class flickrHelperMethodes {
    
    // recursive methode for extracting all json key/value pairs
    static private func collectAllStructuresFromJSON(inputStructure:Any, key:String?) -> [Any]? {
        var structureKey   :String?
        var subStructureKey:String?
        
        struct parsedArray {
            static var array:[Any]?
        }
        
        // 1. try to cast sub-structure to Dictionary, if nil try to cast to Array
        if let tempDict = inputStructure as? NSDictionary {
            for (key, value) in tempDict {
                structureKey = key as? String;
                collectAllStructuresFromJSON(inputStructure: value, key: key as? String);
                print("Only Sub-Dictionary Keys: \(structureKey)");
            }
            // here, algorithm stoped at bottom of leaf
            print("Extracted Dictionary for Key: \(structureKey):  \(tempDict)");
        }
        // 2. if cast to Dictionary failed, sub-structure may be array of [key, value] pairs
        else if let tempArray = inputStructure as? NSArray {
            for value in tempArray {
                subStructureKey = structureKey;
                collectAllStructuresFromJSON(inputStructure: value, key: nil);
            }
            // store this array if needed
            print("Extracted Array for Key: \(key) \(tempArray)")
            
            // get values for keys : (tempArray[0] as? NSDictionary)?.value(forKey: "title") as? String
        }
        else {
            // here, can extract all [key, value] pairs, undependently
            //print("Extracted Key: \(key) with Value: \(inputStructure)");
        }
     
        return parsedArray.array!;
    }
    
    /*
        JSON parser of data returned by http API methode
     */
         // Convert server json response to NSDictionary
    static func flickrGetJSONDictionary(data: Data) -> NSDictionary? { // , parserKeys:[String] -> [String:Any]
        // var jsonDictionary = [String:Any]();
        var jsonDictionary:NSDictionary?
         do {
            if let convertedJsonIntoDict:NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                // Print out dictionary
                print(convertedJsonIntoDict)
                jsonDictionary = convertedJsonIntoDict;
                
                // collectAllStructuresFromJSON(inputStructure: inputDictionary, key: nil);
                
             }
         }
         catch let error as NSError {
            print(error.localizedDescription)
        }
        return jsonDictionary;
    }
 
    /*
        Get Specific Base-URL Methodes
        these methodes generate URLs buth withouth valid oAuth Signature
        oAuth Signature is generated based on this URL and then apended
        to URL as query parameter
    */
    
    static func flickrGetBaseURL() -> URL {
        let baseURL:NSURLComponents = NSURLComponents.init();
        baseURL.scheme = flickrConstants.kBaseHostURLScheme;
        baseURL.host   = flickrConstants.kBaseHostURL;
        return baseURL.url!;
    }
    
    static func flickrGetServicesOauthURL() -> URL {
        let servicesOauthURL:NSURLComponents = NSURLComponents.init();
        
        servicesOauthURL.scheme = flickrGetBaseURL().scheme;
        servicesOauthURL.host   = flickrGetBaseURL().host;
        servicesOauthURL.path   = flickrConstants.kOauthServiceURL;
        
        print("Services/OAuth URL: " + String(describing: servicesOauthURL.url));
        return servicesOauthURL.url!;
    }
    
    /*
        Cryptography Calculations
    */
    
    static func flickrCalculteMD5FromString(string: String) -> String? {
        
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
        var md5Data = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = md5Data.withUnsafeMutableBytes {
            md5Bytes in messageData.withUnsafeBytes {
                messageBytes in CC_MD5(messageBytes, CC_LONG(messageData.count), md5Bytes)
            }
        }
        
        let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        print("md5Hex: \(md5Hex)")
        return md5Hex
        
    }
    
    static func flickrCalculteSHA1FromString(string: String) -> String? {
        
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
        var sha1Data = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
        
        _ = sha1Data.withUnsafeMutableBytes {
            sha1Bytes in messageData.withUnsafeBytes {
                messageBytes in CC_SHA1(messageBytes, CC_LONG(messageData.count), sha1Bytes)
            }
        }
        
        let sha1Hex =  sha1Data.map { String(format: "%02hhx", $0) }.joined()
        print("sha1Hex: \(sha1Hex)")
        
        
         let hmacResult:String = string.hmac(algorithm: HMACAlgorithm.SHA1, key: string)
        
        return hmacResult
        
    }
    
    /* 
        Oauth Generate Query methodes
    */
 
    static func flickrGenerateOauthSignature() -> String {
        let flickrSignature:String = flickrConstants.kSecretKey + "api_key" + flickrConstants.kApiKey + flickrConstants.kGetFullToken + "mini_token" + "953-717-260"
        
        return flickrSignature;
    }
    
    static func flickrGenerateOauthNonce() -> String {
        let uuidString:String = UUID().uuidString
        
        let index = uuidString.index(uuidString.startIndex, offsetBy: 8)
        return uuidString.substring(to: index)
    }
    
    static func flickrGenerateOauthTimestamp() -> String {
        let timestamp = String(Int64(Date().timeIntervalSince1970))
        return timestamp
    }
    
    static func flickrGenerateOauthConsumerKey() -> String {
        var oauthConsumerKey:String = "";
        oauthConsumerKey = flickrConstants.kApiKey;
        return oauthConsumerKey;
    }
    
    static func flickrResponseStringParser(responseString:String, flickrParseArguments:[String]) -> [String: String] {
        var stringValueArray:[String] = [];
        var parsedDictionary = [String: String]();

        stringValueArray = responseString.components(separatedBy: "&");
        for keyValuePair in stringValueArray {
            parsedDictionary[keyValuePair.components(separatedBy: "=")[0]] = keyValuePair.components(separatedBy: "=")[1];
        }
        
        return parsedDictionary;
    }
    
    /* 
        Flickr API Request generator methodes
        These methodes generate valid Flickr URLs
    */
    
    static func flickrProcessAndAddSignatureQueryParameterToURL(httpRequestURL:URL, requestQueryArray:[URLQueryItem], tokenSecret:String?, queryPercentageEncode:Bool = false) -> NSURLComponents {
        // variables
        var URLBaseSring:String                   = "";
        var signatureKey:String                   = "";
        var oauthSignature:String                 = "";
        var sortedQueryArray:[URLQueryItem]       = [];
        var URLWithQueryParams:NSURLComponents    = NSURLComponents.init();
        let URLWithoutQueryParams:NSURLComponents = NSURLComponents.init();
        
        // process query parameters
        URLWithQueryParams.scheme     = httpRequestURL.scheme;
        URLWithQueryParams.host       = httpRequestURL.host;
        URLWithQueryParams.path       = httpRequestURL.path;
        
        URLWithoutQueryParams.scheme  = httpRequestURL.scheme;
        URLWithoutQueryParams.host    = httpRequestURL.host;
        URLWithoutQueryParams.path    = httpRequestURL.path;
        
        
        // Sort query array lexicographically
        sortedQueryArray = flickrSortQueryParamsLexi(inputQeryArray: requestQueryArray);
        URLWithQueryParams.queryItems = sortedQueryArray;
        
        // Percentage encode each query value:
        if (queryPercentageEncode) {
            var i:Int = 0;
            for _ in URLWithQueryParams.queryItems!{
                URLWithQueryParams.queryItems?[i].value = URLWithQueryParams.queryItems?[i].value?.RFC3986URLEncoded;
                i += 1;
            }
        }
        
        // Generate URL Base String [GET/POST] + & + [percetage encoded current URL] + "&" + [percentage encoded query params, again!]
        URLBaseSring = "GET" + "&" + (URLWithoutQueryParams.url?.absoluteString.RFC3986URLEncoded)! + "&" + (URLWithQueryParams.query?.RFC3986URLEncoded)!;
        
        // Generate signature key [percentage encoded]
        if let _ = tokenSecret {                            // Some/None can be used
            signatureKey = String(flickrConstants.kSecretKey + "&" + tokenSecret!)!;
        }
        else {
            signatureKey = String(flickrConstants.kSecretKey + "&");
        }
        
        // Generate oAuth Signature as SHA1 of current URL Base String, and store it to sharedInstance
        oauthSignature = URLBaseSring.hmac(algorithm: HMACAlgorithm.SHA1, key: signatureKey);
        oauthSignature = oauthSignature.RFC3986URLEncoded;

        // Append new Query Parameter (oauth_signature) to existing URL
        let tempArray:[URLQueryItem] = [NSURLQueryItem(name: "oauth_signature", value: oauthSignature) as URLQueryItem];
        // flickrInsertQueryParamsLexiToURL(url: &requestTokenURL, aditionalQueryArray: tempArray)
        URLWithQueryParams = flickrInsertQueryParamsLexiToURLComponents(urlComponents: URLWithQueryParams, aditionalQueryArray: tempArray)
        
        print("Generated Processed request URL: " + (URLWithQueryParams.url?.absoluteURL.absoluteString)!);

        return URLWithQueryParams;
    }
    
    
    // Generate Request Token complete api Request
    static func flickrGenerateRequestTokenRequest() -> flickrAPIRequest {
        // Generate valid Lexicographicaly value sorted Request Token URL
        let requestTokenURL:URL = flickrGetRequestTokenBaseURL(); // (NSURLComponents)
        var requestTokenURLWithQueryParams:NSURLComponents = NSURLComponents.init();
        var tokenRequestQueryArray:[URLQueryItem] = [];

        // Add query parameteres
        tokenRequestQueryArray = flickrGenerateRequestTokenStartParams();
        
        requestTokenURLWithQueryParams = flickrProcessAndAddSignatureQueryParameterToURL(
            httpRequestURL: requestTokenURL,
            requestQueryArray: tokenRequestQueryArray,
            tokenSecret: nil,
            queryPercentageEncode: true
        );
        
        let apiRequest:flickrAPIRequest = flickrAPIRequest.init(
            httpMethod: RequestMethod.GET,
            host: flickrConstants.kBaseHostURL,
            path: String(flickrConstants.kOauthServiceURL + flickrConstants.kGetRequestTokenURL),
            headers: nil,
            query: requestTokenURLWithQueryParams.queryItems,
            body: nil);
        
        return apiRequest
    }
    
    // Generate User Authorization Verifier
    static func flickrGenerateUserAuthorizationRequest(requestToken:flickrRequestToken) -> flickrAPIRequest {
        let userAuthorizationURL:URL = flickrGetAuthorizationBaseURL();
        let userAuthorizationURLWithQueryParams:NSURLComponents = NSURLComponents();
        var authorizationQueryArray:[URLQueryItem] = [];
        
        userAuthorizationURLWithQueryParams.scheme = userAuthorizationURL.scheme;
        userAuthorizationURLWithQueryParams.host   = userAuthorizationURL.host;
        userAuthorizationURLWithQueryParams.path   = userAuthorizationURL.path;
        
        authorizationQueryArray.append(URLQueryItem.init(name: "oauth_token", value: requestToken.oauthToken));
        userAuthorizationURLWithQueryParams.queryItems = authorizationQueryArray;
        
        let apiRequest:flickrAPIRequest = flickrAPIRequest.init(
            httpMethod: RequestMethod.GET,
            host: flickrConstants.kBaseHostURL,
            path: String(flickrConstants.kOauthServiceURL + flickrConstants.kGetUserAuthorization),
            headers: nil,
            query: userAuthorizationURLWithQueryParams.queryItems,
            body: nil
        );
        
        return apiRequest
    }
    
    // Generate Access Token complete api Request
    static func flickrGenerateAccessTokenRequest(requestToken:flickrRequestToken, userAuthorization:flickrUserAuthorization) -> flickrAPIRequest {
        
        let accessTokenURL:URL = flickrGetAccessTokenBaseURL();
        var accessTokenURLWithQueryParams:NSURLComponents = NSURLComponents();
        
        accessTokenURLWithQueryParams = flickrProcessAndAddSignatureQueryParameterToURL(
            httpRequestURL: accessTokenURL,
            requestQueryArray: flickrGenerateAccessTokenStartParams(),
            tokenSecret: FlickrSessionAuthorization.sharedInstance.getRequestToken().oauthTokenSecret,
            queryPercentageEncode: true
        );
        
        let apiRequest:flickrAPIRequest = flickrAPIRequest.init(
            httpMethod: RequestMethod.GET,
            host:  flickrConstants.kBaseHostURL,
            path: String(flickrConstants.kOauthServiceURL + flickrConstants.kGetAccessToken),
            headers: nil,
            query: accessTokenURLWithQueryParams.queryItems,
            body: nil
        );
        
        return apiRequest
    }
    
    /*
        Generate Image API request
    */
    
    static func fickrGenerateLoginTestRequest() -> flickrAPIRequest {
        let flickrAPIsrvice:URL = flickrGenerateAPIBaseURL();
        var loginURLWithQueryParams:NSURLComponents = NSURLComponents.init();
        var accessTokenString:String = FlickrSessionAuthorization.sharedInstance.getAccessToken().accessToken;
        
        // manage query parameters:
        loginURLWithQueryParams = flickrProcessAndAddSignatureQueryParameterToURL(
            httpRequestURL: flickrAPIsrvice,
            requestQueryArray: flickrGenerateLoginTesstStartParams(accessTokenString: accessTokenString),
            tokenSecret: FlickrSessionAuthorization.sharedInstance.getAccessToken().accessTokenSecret
        );
        
        let apiRequest:flickrAPIRequest = flickrAPIRequest.init(
            httpMethod: RequestMethod.GET,
            host: flickrConstants.kflickrAPIHost,
            path: flickrAPIsrvice.path,
            headers: nil,
            query: loginURLWithQueryParams.queryItems,
            body: nil
        );
        
        return apiRequest
    }
    
    // Flickr Photo API
    static func fickrGeneratePhotosSearchRequest(photoTag:String) -> flickrAPIRequest {
        let flickrAPIsrvice:URL = flickrGenerateAPIBaseURL();
        var searchURLWithQueryParams:NSURLComponents = NSURLComponents.init();
        let accessTokenString:String = FlickrSessionAuthorization.sharedInstance.getAccessToken().accessToken;
        let userID:String = FlickrSessionAuthorization.sharedInstance.getAccessToken().userNsid;
        
        // manage query parameters:
        searchURLWithQueryParams = flickrProcessAndAddSignatureQueryParameterToURL(
            httpRequestURL: flickrAPIsrvice,
            requestQueryArray: flickrGeneratePhotosSearchStartParams(accessTokenString: accessTokenString, userID: userID, photoTag: photoTag),
            tokenSecret: FlickrSessionAuthorization.sharedInstance.getAccessToken().accessTokenSecret
        );
        
        
        let apiRequest:flickrAPIRequest = flickrAPIRequest.init(
            httpMethod: RequestMethod.GET,
            host: flickrConstants.kflickrAPIHost,
            path: flickrAPIsrvice.path,
            headers: nil,
            query: searchURLWithQueryParams.queryItems,
            body: nil
        );
        
        return apiRequest
    }
    
    static func flickrGenerateDownloadPhotoFromPhotoContextURLRequest(photoContext: flickrPhotoContext) -> flickrAPIRequest {
        let flickrStaticPhotoDownloadURLHost:String = "farm" + photoContext.farm + ".staticflickr.com";
        let flickrStaticPhotoDownloadURLPath:String = "/" + photoContext.server + "/" + photoContext.id + "_" + photoContext.secret + ".jpg";   // format info should be provided externaly!
        
        let apiRequest:flickrAPIRequest = flickrAPIRequest.init(
            httpMethod: RequestMethod.GET,
            host: flickrStaticPhotoDownloadURLHost,
            path: flickrStaticPhotoDownloadURLPath,
            headers: nil,
            query: nil,
            body: nil
        );
        
        return apiRequest;
    }
    
    static func flickrGenerateDownloadPhotoURLRequest(photoURL:URL) -> flickrAPIRequest {
        let flickrStaticPhotoDownloadURL:URL = photoURL;
        
        let apiRequest:flickrAPIRequest = flickrAPIRequest.init(
            httpMethod: RequestMethod.GET,
            host: flickrStaticPhotoDownloadURL.host!,
            path: flickrStaticPhotoDownloadURL.path,
            headers: nil,
            query: nil,
            body: nil
        );
        
        return apiRequest;
    }
    
    static func flickrGeneratePhotoInfoRequest(photoId: String) -> flickrAPIRequest {
        let flickrAPIsrvice:URL = flickrGenerateAPIBaseURL();
        var getInfoURLWithQueryParams:NSURLComponents = NSURLComponents.init();
        let accessTokenString:String = FlickrSessionAuthorization.sharedInstance.getAccessToken().accessToken;

        // manage query parameters:
        getInfoURLWithQueryParams = flickrProcessAndAddSignatureQueryParameterToURL(
            httpRequestURL: flickrAPIsrvice,
            requestQueryArray: flickrGeneratePhotoInfoStartParams(accessTokenString: accessTokenString, photoId: photoId),
            tokenSecret: FlickrSessionAuthorization.sharedInstance.getAccessToken().accessTokenSecret
        );
        
        
        let apiRequest:flickrAPIRequest = flickrAPIRequest.init(
            httpMethod: RequestMethod.GET,
            host: flickrConstants.kflickrAPIHost,
            path: flickrAPIsrvice.path,
            headers: nil,
            query: getInfoURLWithQueryParams.queryItems,
            body: nil
        );
        
        return apiRequest;
    }
    
    static func flickrGeneratePhotoSizesRequest(photoId:String) -> flickrAPIRequest {
        let flickrAPIsrvice:URL = flickrGenerateAPIBaseURL();
        var getInfoURLWithQueryParams:NSURLComponents = NSURLComponents.init();
        let accessTokenString:String = FlickrSessionAuthorization.sharedInstance.getAccessToken().accessToken;
        
        // manage query parameters:
        getInfoURLWithQueryParams = flickrProcessAndAddSignatureQueryParameterToURL(
            httpRequestURL: flickrAPIsrvice,
            requestQueryArray: flickrGeneratePhotoGetSizesStartParams(accessTokenString: accessTokenString, photoId: photoId),
            tokenSecret: FlickrSessionAuthorization.sharedInstance.getAccessToken().accessTokenSecret
        );
        
        
        let apiRequest:flickrAPIRequest = flickrAPIRequest.init(
            httpMethod: RequestMethod.GET,
            host: flickrConstants.kflickrAPIHost,
            path: flickrAPIsrvice.path,
            headers: nil,
            query: getInfoURLWithQueryParams.queryItems,
            body: nil
        );
        
        return apiRequest;

    }
    
    
    /*
        Internal helper methodes
    */
    
    private static func flickrGetRequestTokenBaseURL() -> URL {
        let requestTokenURL:NSURLComponents = NSURLComponents.init();
        
        requestTokenURL.scheme = flickrGetServicesOauthURL().scheme;
        requestTokenURL.host   = flickrGetServicesOauthURL().host;
        requestTokenURL.path   = flickrGetServicesOauthURL().path + flickrConstants.kGetRequestTokenURL;
        
        print("Request Token URL: " + String(describing: requestTokenURL.url));
        return requestTokenURL.url!;
        
    }
    
    private static func flickrGetAuthorizationBaseURL() -> URL {
        let authorizationURL:NSURLComponents = NSURLComponents.init();
        
        authorizationURL.scheme = flickrGetServicesOauthURL().scheme;
        authorizationURL.host   = flickrGetServicesOauthURL().host;
        authorizationURL.path   = flickrGetServicesOauthURL().path + flickrConstants.kGetUserAuthorization;
        
        print("Authorization URL: " + String(describing: authorizationURL.url));
        return authorizationURL.url!;
    }
    
    private static func flickrGetAccessTokenBaseURL() -> URL {
        let accessTokenURL:NSURLComponents = NSURLComponents.init();
        
        accessTokenURL.scheme = flickrGetServicesOauthURL().scheme;
        accessTokenURL.host   = flickrGetServicesOauthURL().host;
        accessTokenURL.path   = flickrGetServicesOauthURL().path + flickrConstants.kGetAccessToken;
        
        print("Access Token URL: " + String(describing: accessTokenURL.url));
        return accessTokenURL.url!;
    }
    
    // generates Flickr API Base URL ->  https://api.flickr.com/services/rest/
    private static func flickrGenerateAPIBaseURL() -> URL {
        let flickrAPIBaseURL:NSURLComponents = NSURLComponents.init();
        
        flickrAPIBaseURL.scheme = flickrConstants.kBaseHostURLScheme;
        flickrAPIBaseURL.host   = flickrConstants.kflickrAPIHost;
        flickrAPIBaseURL.path   = flickrConstants.kFlickrAPIPath;
        
        return flickrAPIBaseURL.url!;
    }
    
    // Generate callback parameter
    private static func flickrGenerateOauthCallback(inputOauthCallback:String?) -> String {
        var oauthCallback:String = "";
        
        if inputOauthCallback == nil {
            oauthCallback = "oob";
        }
        else {
            oauthCallback = inputOauthCallback!;
        }
        
        return oauthCallback;
    }
    
    // Generate Request Token Start Query parameters -> parameters without oauth signature
    private static func flickrGenerateRequestTokenStartParams() -> [URLQueryItem] {
        let queryParams:[URLQueryItem] = [
            URLQueryItem(name: "oauth_nonce", value: flickrHelperMethodes.flickrGenerateOauthNonce()),
            URLQueryItem(name: "oauth_timestamp", value: flickrHelperMethodes.flickrGenerateOauthTimestamp()),
            URLQueryItem(name: "oauth_consumer_key", value: flickrConstants.kApiKey),
            URLQueryItem(name: "oauth_version", value: flickrConstants.kOauthVersion),
            URLQueryItem(name: "oauth_signature_method", value: flickrConstants.kOauthSignatureMethod),
            URLQueryItem(name: "oauth_callback", value: flickrGenerateOauthCallback(inputOauthCallback: flickrConstants.kOauthCallback)),
            URLQueryItem(name: "format", value: "json")
        ];
        return queryParams
    }
    
    // Generate Access Token Start Query parameters -> parameters without oauth signature
    private static func flickrGenerateAccessTokenStartParams() -> [URLQueryItem] {
        let queryParams:[URLQueryItem] = [
            URLQueryItem(name: "oauth_nonce", value: flickrHelperMethodes.flickrGenerateOauthNonce()),
            URLQueryItem(name: "oauth_timestamp", value: flickrHelperMethodes.flickrGenerateOauthTimestamp()),
            URLQueryItem(name: "oauth_verifier", value: FlickrSessionAuthorization.sharedInstance.getUserAuthorization().oauthVerifier),
            URLQueryItem(name: "oauth_consumer_key", value: flickrConstants.kApiKey),
            URLQueryItem(name: "oauth_signature_method", value: flickrConstants.kOauthSignatureMethod),
            URLQueryItem(name: "oauth_version", value: flickrConstants.kOauthVersion),
            URLQueryItem(name: "oauth_token", value: FlickrSessionAuthorization.sharedInstance.getRequestToken().oauthToken)
            // URLQueryItem(name: "oauth_signature", value: FlickrSessionAuthorization.sharedInstance.getOauthSignature())
        ];
        return queryParams;
    }
    
    private static func flickrGenerateLoginTesstStartParams(accessTokenString:String) -> [URLQueryItem] {
        let queryParams:[URLQueryItem] = [
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "oauth_nonce", value: flickrHelperMethodes.flickrGenerateOauthNonce()),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "oauth_consumer_key", value: flickrConstants.kApiKey),
            URLQueryItem(name: "oauth_timestamp", value: flickrHelperMethodes.flickrGenerateOauthTimestamp()),
            URLQueryItem(name: "oauth_signature_method", value: flickrConstants.kOauthSignatureMethod),
            URLQueryItem(name: "oauth_version", value: flickrConstants.kOauthVersion),
            URLQueryItem(name: "oauth_token", value: accessTokenString),
            URLQueryItem(name: "method", value: "flickr.test.login")
            ];
        return queryParams
    }
    
    private static func flickrGeneratePhotosSearchStartParams(accessTokenString:String, userID:String, photoTag:String) -> [URLQueryItem] {
        let queryParams:[URLQueryItem] = [
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "oauth_nonce", value: flickrHelperMethodes.flickrGenerateOauthNonce()),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "oauth_consumer_key", value: flickrConstants.kApiKey), // api_key
            URLQueryItem(name: "user_id", value: userID),
            URLQueryItem(name: "oauth_timestamp", value: flickrHelperMethodes.flickrGenerateOauthTimestamp()),
            URLQueryItem(name: "oauth_signature_method", value: flickrConstants.kOauthSignatureMethod),
            URLQueryItem(name: "oauth_version", value: flickrConstants.kOauthVersion),
            URLQueryItem(name: "oauth_token", value: accessTokenString),
            URLQueryItem(name: "tags", value: photoTag),
            URLQueryItem(name: "extras", value: "url_t,+original_format,+date_taken"),                              // get thumbnail URLs
            URLQueryItem(name: "method", value: "flickr.photos.search")
            ];
        return queryParams
    }
    
    private static func flickrGeneratePhotoInfoStartParams(accessTokenString:String, photoId:String) -> [URLQueryItem] {
        let queryParams:[URLQueryItem] = [
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "photo_id", value: photoId),
            URLQueryItem(name: "oauth_consumer_key", value: flickrConstants.kApiKey),
            URLQueryItem(name: "oauth_token", value: accessTokenString),
            URLQueryItem(name: "method", value: "flickr.photos.getInfo")
        ];
        return queryParams
    }
    
    private static func flickrGeneratePhotoGetSizesStartParams(accessTokenString:String, photoId:String) -> [URLQueryItem] {
        let queryParams:[URLQueryItem] = [
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "photo_id", value: photoId),
            URLQueryItem(name: "oauth_consumer_key", value: flickrConstants.kApiKey),
            URLQueryItem(name: "oauth_token", value: accessTokenString),
            URLQueryItem(name: "method", value: "flickr.photos.getSizes")
        ];
        return queryParams
    }
    
    // Sort array of Query
    private static func flickrSortQueryParamsLexi(inputQeryArray: [URLQueryItem]) -> [URLQueryItem] {
        var sortedQuaryArray:[URLQueryItem] = inputQeryArray;
        
        // make cloasure method sort lexicographical by query parameter name
        /*
            Why have to have instance instantiated to use cloasure? This is problematic line:
                -> inputQeryArray.sort { (xQuery:URLQueryItem, yQuery:URLQueryItem) -> Bool in
        */
        sortedQuaryArray.sort { (xQuery:URLQueryItem, yQuery:URLQueryItem) -> Bool in
            if xQuery.name < yQuery.name {
                return true
            }
            else {
                return false;
            }
        };
        return sortedQuaryArray
    }
    
    // insert Query parameter array
    private static func flickrInsertQueryParamsLexiToURLComponents(urlComponents:NSURLComponents, aditionalQueryArray:[URLQueryItem]) -> NSURLComponents {
        
        let tempURLComponents:NSURLComponents = NSURLComponents.init();
    
        // Get URL query params
        var tempQueryArray:[URLQueryItem] = urlComponents.queryItems!; // (URLComponents(string: url.absoluteString)?.queryItems)!;

        // Append new parameters
        tempQueryArray.append(contentsOf: aditionalQueryArray);

        // Sort new Array
        tempQueryArray = flickrSortQueryParamsLexi(inputQeryArray: tempQueryArray)
        
        // Create new URL
        tempURLComponents.scheme      = urlComponents.scheme;
        tempURLComponents.host        = urlComponents.host;
        tempURLComponents.path        = urlComponents.path;
        tempURLComponents.queryItems  = tempQueryArray;
        
        // create URL from components
        
        return tempURLComponents
    }
}
