//
//  Evideo.swift
//  TsuimanaMobile
//
//  Created by 酒井英伸 on 2016/04/24.
//  Copyright © 2016年 pokohide. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Category: String {
    case All = "TOP"
    case Letsplay = "ゲーム"
    case Funny = "おもしろい"
    case Girls = "ガールズ"
    case Benefit = "タメになる"
    case Music = "洋楽・映画"
    case Other = "その他"
    
    static let values = [All, Letsplay, Funny, Girls, Benefit, Music, Other].map { $0.rawValue }
    
    var path: String {
        return ["all", "letsplay", "funny", "girls", "benefit", "music", "other"][hashValue]
    }
}

struct Evideo {
    
    // MARK: - Properties
    var id: Int?
    var title: String?
    var videoId: String?
    var playtime: Int?
    var level: Int?
    var category: Category?
    var instant: Bool?
    var editable: Bool?
    var word: String?
    var view: Int?
    var imageUrl: NSURL?
    
    // MARK: - Publics
    init(id: Int, title: String, videoId: String, playtime: Int, level: Int, category: String, instant: Bool, editable: Bool, word: String, view: Int) {
        self.id = id
        self.title = title
        self.videoId = videoId
        self.playtime = playtime
        self.level = level
        self.category = Category(rawValue: category)
        self.instant = instant
        self.editable = editable
        self.word = word
        self.view = view
        self.imageUrl =  NSURL(string: "http://i.ytimg.com/vi/\(videoId)/mqdefault.jpg")
    }
    
    init(json: JSON) {
        self.init(
            id: json["id"].intValue,
            title: json["title"].stringValue,
            videoId: json["youtube"].stringValue,
            playtime: 0,
            level: json["level"].intValue,
            category: json["category"].stringValue,
            instant: json["instant"].boolValue,
            editable: json["editable"].boolValue,
            word: json["word"].stringValue,
            view: json["view"].intValue
        )
    }
}