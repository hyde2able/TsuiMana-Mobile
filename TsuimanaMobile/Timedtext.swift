//
//  Timedtext.swift
//  TsuimanaMobile
//
//  Created by 酒井英伸 on 2016/04/24.
//  Copyright © 2016年 pokohide. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Timedtext {
    // MARK: - Properties
    var id: String?
    var body: String?
    var half: Bool?
    var japanese: String?
    var start: Int?
    var userid: Int?
    var evideoid: Int?
    
    init(id: String, body: String, half: Bool, japanese: String, start: Int, userid: Int, evideoid: Int) {
        self.id = id
        self.body = body
        self.half = half
        self.japanese = japanese
        self.start = start
        self.userid = userid
        self.evideoid = evideoid
    }
    
    init(json: JSON) {
        self.init(
            id: json["id"]["$oid"].stringValue,
            body: json["body"].stringValue,
            half: json["half"].boolValue,
            japanese: json["japanese"].stringValue,
            start: json["start"].intValue,
            userid: json["userid"].intValue,
            evideoid: json["evideoid"].intValue
        )
    }
    
}