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
    
    static func flickrGetRequestTokenBaseURL() -> URL{
        let requestTokenURL:NSURLComponents = NSURLComponents.init();
        
        requestTokenURL.scheme = flickrGetServicesOauthURL().scheme;
        requestTokenURL.host   = flickrGetServicesOauthURL().host;
        requestTokenURL.path   = flickrGetServicesOauthURL().path + flickrConstants.kGetRequestTokenURL;
        
        print("Request Token URL: " + String(describing: requestTokenURL.url));
        return requestTokenURL.url!;
        
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
    
    static func flickrGenerateOauthCallback(inputOauthCallback:String?) -> String {
        var oauthCallback:String = "";
        
        if inputOauthCallback == nil {
            oauthCallback = "oob";
        }
        else {
            oauthCallback = inputOauthCallback!;
        }
        
        return oauthCallback;
    }
    
    // better make flickrResponseStringParser() which will parse stirng with (example) : 
    // Left Bound  = "oauth_token"
    // Right Bound = "&"
    
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
    
    // Generate Request Token complete api Request
    static func flickrGenerateRequestTokenRequest() -> flickrAPIRequest {
        var requestTokenURLBaseSring:String = "";
        
        var signatureKey:String             = "";
        let requestTokenSecret:String       = ""; // this is a first stage so token secret is empty
        
        // Generate valid Lexicographicaly value sorted Request Token URL
        let requestTokenURL:URL = flickrGetRequestTokenBaseURL(); // (NSURLComponents)
        
        
        var requestTokenURLWithQueryParams:NSURLComponents = NSURLComponents.init();
        let requestTokenURLWithoutQueryParams:NSURLComponents = NSURLComponents.init();
        
        var tokenRequestQueryArray:[URLQueryItem] = [];
        var oauthSignature:String = "";
        
        // Add query parameteres
        tokenRequestQueryArray = flickrGenerateRequestTokenStartParams();
        
        // Sort Query parameters
        print("UNSORTED tokenRequestQueryArray: ");
        dump(tokenRequestQueryArray);
        
        tokenRequestQueryArray = flickrSortQueryParamsLexi(inputQeryArray: tokenRequestQueryArray);

        print("SORTED tokenRequestQueryArray: ");
        dump(tokenRequestQueryArray);
        
        // Create URL with parameters and Append query parameters to request token URL
        requestTokenURLWithQueryParams.scheme     = requestTokenURL.scheme;
        requestTokenURLWithQueryParams.host       = requestTokenURL.host;
        requestTokenURLWithQueryParams.path       = requestTokenURL.path;
        
        requestTokenURLWithoutQueryParams.scheme  = requestTokenURLWithQueryParams.scheme;
        requestTokenURLWithoutQueryParams.host    = requestTokenURLWithQueryParams.host;
        requestTokenURLWithoutQueryParams.path    = requestTokenURLWithQueryParams.path;
        
        requestTokenURLWithQueryParams.queryItems = tokenRequestQueryArray;
        
        // Request Token URL. This URL is used to generate URL base string -> percetnageEncode(URL)
        // requestTokenURL = requestTokenURLWithQueryParams.url!;
        
        // Percentage encode query calues:
        var i:Int = 0;
        for _ in requestTokenURLWithQueryParams.queryItems!{
            requestTokenURLWithQueryParams.queryItems?[i].value = requestTokenURLWithQueryParams.queryItems?[i].value?.RFC3986URLEncoded;
            i += 1;
        }
        
        // Generate URL Base String [GET/POST] + & + [percetage encoded current URL] + "&" + [percentage encoded query params, again!]
        requestTokenURLBaseSring = "GET" + "&" + (requestTokenURLWithoutQueryParams.url?.absoluteString.RFC3986URLEncoded)! + "&" + (requestTokenURLWithQueryParams.query?.RFC3986URLEncoded)!;
        
        
        // requestTokenURLWithQueryParams.query?.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)
        
        
        
        // Generate signature key [percentage encoded]
        signatureKey = String(flickrConstants.kSecretKey + "&" + requestTokenSecret); //.RFC3986URLEncoded;
        
        // Generate oAuth Signature as SHA1 of current URL Base String
        oauthSignature = requestTokenURLBaseSring.hmac(algorithm: HMACAlgorithm.SHA1, key: signatureKey);
        oauthSignature = oauthSignature.RFC3986URLEncoded;
        
        // Append new Query Parameter (oauth_signature) to existing URL
        let tempArray:[URLQueryItem] = [NSURLQueryItem(name: "oauth_signature", value: oauthSignature) as URLQueryItem];
        // flickrInsertQueryParamsLexiToURL(url: &requestTokenURL, aditionalQueryArray: tempArray)
        requestTokenURLWithQueryParams = flickrInsertQueryParamsLexiToURLComponents(urlComponents: requestTokenURLWithQueryParams, aditionalQueryArray: tempArray)
        
        print("Generated requestTokenURL: " + (requestTokenURLWithQueryParams.url?.absoluteURL.absoluteString)!);
        
        let apiRequest:flickrAPIRequest = flickrAPIRequest.init(
            httpMethod: RequestMethod.GET,
            path: String(flickrConstants.kOauthServiceURL + flickrConstants.kGetRequestTokenURL),
            headers: nil,
            query: requestTokenURLWithQueryParams.queryItems,
            body: nil);
        
        return apiRequest

    }

    
    /*
        Internal helper methodes
    */
    
    // Generate Request Token Start Query parameters -> parameters without oauth signature
    static func flickrGenerateRequestTokenStartParams() -> [URLQueryItem] {
        let queryParams:[URLQueryItem] = [
            URLQueryItem(name: "oauth_nonce", value: flickrHelperMethodes.flickrGenerateOauthNonce()),
            URLQueryItem(name: "oauth_timestamp", value: flickrHelperMethodes.flickrGenerateOauthTimestamp()),
            URLQueryItem(name: "oauth_consumer_key", value: flickrConstants.kApiKey),
            URLQueryItem(name: "oauth_version", value: flickrConstants.kOauthVersion),
            URLQueryItem(name: "oauth_signature_method", value: flickrConstants.kOauthSignatureMethod),
            URLQueryItem(name: "oauth_callback", value: flickrConstants.kOauthCallback),
            URLQueryItem(name: "format", value: "json")
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
//        inputQeryArray = sortedQuaryArray;
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
