//
//  RequestModel.swift
//  Caritathelp
//
//  Created by Jeremy gros on 14/01/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RequestModel {
    
    var status = ""
    //var userTab = [String:AnyObject]()
    
    func request(type:String,param:[String:String], add:String, callback: ((isOk: Bool, User : JSON)->Void)?){
        
        var res : AnyObject = ""
        //var status = ""
        if(type == "POST"){
            Alamofire.request(.POST, "http://52.31.151.160:3000/"+add, parameters: param, encoding: .JSON)
            .responseJSON() { response in

                print("Response JSON: \(response.result.value)")
                res = response.result.value!
                let json = JSON(res)
                //print(json["response"]["lastname"])
                self.status = String(res["status"])
                if (self.status == "Optional(200)"){
                    callback?(isOk: true, User: json)
                }else{
                    callback?(isOk: false, User: json) }
                
            }
        }
        else if(type == "GET"){
            
            Alamofire.request(.GET, "http://52.31.151.160:3000/"+add, parameters: param)
                .responseJSON { response in
                    print("Response JSON: \(response.result.value)")
                    res = response.result.value!
                    let json = JSON(res)
                    //print(json["response"]["lastname"])
                    self.status = String(res["status"])
                    if (self.status == "Optional(200)"){
                        callback?(isOk: true, User: json)
                    }else{
                        callback?(isOk: false, User: json) }
                    
            }
        }
        else if(type == "PUT"){
            
            Alamofire.request(.PUT, "http://52.31.151.160:3000/"+add, parameters: param)
                .responseJSON { response in
                    print("Response JSON: \(response.result.value)")
                    res = response.result.value!
                    let json = JSON(res)
                    //print(json["response"]["lastname"])
                    self.status = String(res["status"])
                    if (self.status == "Optional(200)"){
                        callback?(isOk: true, User: json)
                    }else{
                        callback?(isOk: false, User: json) }
                    
            }
        }
        else if(type == "DELETE"){
            
            Alamofire.request(.DELETE, "http://52.31.151.160:3000/"+add, parameters: param)
                .responseJSON { response in
                    print("Response JSON: \(response.result.value)")
                    res = response.result.value!
                    let json = JSON(res)
                    //print(json["response"]["lastname"])
                    self.status = String(res["status"])
                    if (self.status == "Optional(200)"){
                        callback?(isOk: true, User: json)
                    }else{
                        callback?(isOk: false, User: json) }
                    
            }
        }

    }
    
    func requestDeco(callback: ((isOk: Bool)->Void)?){
    
        var res : AnyObject = ""
        Alamofire.request(.POST, "http://52.31.151.160:3000/logout").responseJSON { response in
        print("Response JSON: \(response.result.value)")
        res = response.result.value!
        //let json = JSON(res)
        //print(json["response"]["lastname"])
        self.status = String(res["status"])
        if (self.status == "Optional(200)"){
            callback?(isOk: true)
        }else{
            callback?(isOk: false) }
    }
    }
}