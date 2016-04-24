//
//  WebAPIClient.swift
//  TsuimanaMobile
//
//  Created by 酒井英伸 on 2016/04/24.
//  Copyright © 2016年 pokohide. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WebAPIClient {
    
    // MARK: - Properties
    private let domain = "http://www.tsuimana.com/api"
    
    func getAllEvideos(page: Int = 1, category: Category, callback: Result<[Evideo], NSError> -> Void) {
        let path = category == .All ? "evideos" : "evideos/category/\(category.path)"
        getRequest(path, parameters: ["page": page]) { result in
            switch result {
            case .Success(let value):
                let json = JSON(value)
                var evideos = [Evideo]()
                json["response"]["evideos"].forEach { evideos.append(Evideo(json: $0.1)) }
                callback(Result.Success(evideos))
            case .Failure(let error):
                callback(Result.Failure(error))
            }
        }
    }
    
    func getEvideo(id: Int, callback: Result<[Timedtext], NSError> -> Void) {
        let path = "evideos/\(id)"
        getRequest(path) { result in
            switch result {
            case .Success(let value):
                let json = JSON(value)
                var timedtexts = [Timedtext]()
                json["response"]["timedtexts"].forEach{ timedtexts.append(Timedtext(json: $0.1)) }
                callback(Result.Success(timedtexts))
            case .Failure(let error):
                callback(Result.Failure(error))
            }
        }
    }
    
    // MARK: - Privates
    private func getRequest(path: String, parameters: [String: AnyObject], callback: Result<AnyObject, NSError> -> Void) {
        Alamofire.request(.GET, NSURL(string: "\(domain)/\(path)")!, parameters: parameters)
            .responseJSON{ response in
                callback(response.result)
        }
    }
    private func getRequest(path: String, callback: Result<AnyObject, NSError> -> Void) {
        Alamofire.request(.GET, NSURL(string: "\(domain)/\(path)")!)
            .responseJSON{ response in
                callback(response.result)
        }
    }
    
}

