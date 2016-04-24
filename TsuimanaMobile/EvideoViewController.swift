//
//  EvideoViewController.swift
//  TsuimanaMobile
//
//  Created by 酒井英伸 on 2016/04/24.
//  Copyright © 2016年 pokohide. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SegueContext

class EvideoViewController: UIViewController {

    var timedtexts = [Timedtext]()
    private var isLoading = false
    private var evideo: Evideo? = nil
    
    override func viewDidLoad() {
        evideo = self.contextValue()
        fetchData(true)
        print(evideo)
    }
    
    // MARK: - Privates
    private func fetchData(initialize: Bool) {
        guard let evideo = self.evideo, id = evideo.id else { return }
        if !isLoading {
            isLoading = true
            
            if initialize {
                self.timedtexts = [Timedtext]()
            }
            WebAPIClient().getEvideo(id) { result in
                switch result {
                case .Success(let timedtexts):
                    timedtexts.forEach{ self.timedtexts.append($0) }
                    print(timedtexts)
                case .Failure(let error):
                    print(error)
                }
                SVProgressHUD.dismiss()
                self.isLoading = false
            }
        }
    }
        
}