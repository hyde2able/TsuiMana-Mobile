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
    @IBOutlet private weak var ytPlayer: UIWebView!
    @IBOutlet weak var timedtextsTable: UITableView!
    
    override func viewDidLoad() {
        evideo = self.contextValue()
        fetchData(true)
        ytPlayerInit()
        print(evideo)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimedtextCell", forIndexPath: indexPath) as! TimedtextViewCell
        cell.timedtext = timedtexts[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timedtexts.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let cell = tableView.cellForRowAtIndexPath(indexPath) as! EvideoViewCell
        //self.performSegueWithIdentifier("showEvideo", context: cell.evideo)
        print(indexPath.row)
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
                self.timedtextsTable.reloadData()
            }
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        print("webViewDidFinishLoad")
        print(ytPlayer.request?.URL)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webViewDidStartLoad(webView: UIWebView!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        print("webViewDidStartLoad")
        print(ytPlayer.request?.URL)
    }
    
    
    
    private func ytPlayerInit() {
        guard let evideo = self.evideo, videoId = evideo.videoId else { return }
        self.changeUserAgent()
        let html: String! = "<div style='position:relative;width:100%;padding:56.25% 0 0 0'><iframe src='http://www.youtube.com/embed/\(videoId)?playsinline=1' frameborder='0' style='position:absolute;top:0;left:0;width:100%;height:100%'></div>"
        self.ytPlayer.loadHTMLString(html, baseURL: nil)
        self.ytPlayer.scrollView.bounces = false
        self.ytPlayer.allowsInlineMediaPlayback = true
    }
    
    private func changeUserAgent(){
        let userAgent: String! = self.ytPlayer.stringByEvaluatingJavaScriptFromString("navigator.userAgant")
        let userAgentStr = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.52 Safari/537.36"
        let customUserAgent: String = userAgent.stringByAppendingString(userAgentStr)
        let dic: NSDictionary = ["UserAgent": customUserAgent]
        NSUserDefaults.standardUserDefaults().registerDefaults(dic as! [String : AnyObject])
    }
    
}