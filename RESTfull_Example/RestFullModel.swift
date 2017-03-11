//
//  RestFullModel.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 2/23/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation

// model can have static methodes, but all methodes then have to be independent from each other
// model can be instanitated once (onViewLoaded) and passed using delegate

//class RestFullModel {
//    
//    // let input_string: String = "000005fab4534d05api_key9a0554259914a86fb9e7eb014e4e5d52methodflickr.auth.getFullTokenmini_token123-456-789";
//    static var md5Data:Data? = Data.init();
//    
//    // methodes
//    static func calculateMD5toString(inputString: String) -> String {
//        var hashString : String = "";
//        
//        md5Data = MD5(string: inputString);
//        hashString = DataToString(md5Data:Data);
//        return md5Data!.map { String(format: "%02hhx", $0) }.joined()
//    }
//    
//    static func MD5(string: String) -> Data? {
//        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
//        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
//        
//        _ = digestData.withUnsafeMutableBytes {
//            digestBytes in messageData.withUnsafeBytes {
//                messageBytes in CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
//            }
//        }
//        
//        return digestData
//    }
//    
//    static func print_MD5_Data() {
//        let md5Hex =  md5Data!.map { String(format: "%02hhx", $0) }.joined()
//        print("md5Hex: \(md5Hex)")
//    }
//    
//    static func DataToString(md5Data:Data) -> String {
//        var hashValueString:String = "";
//        hashValueString =  md5Data.map { String(format: "%02hhx", $0) }.joined();
//        
//        return hashValueString;
//    }
//    
//}
