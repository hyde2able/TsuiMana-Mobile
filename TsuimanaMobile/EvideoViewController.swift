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
import XCDYouTubeKit

class EvideoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var timedtexts = [Timedtext]()
    var relatedEvideos = [Evideo]()
    private var isLoading = false
    private var evideo: Evideo? = nil
    @IBOutlet private weak var timedtextsTable: UITableView!
    @IBOutlet weak var ytBackView: UIView!
    
    private var ytPlayer: XCDYouTubeVideoPlayerViewController? = nil
    private var ytPlayerPlaying = false
    
    override func viewDidLoad() {
        
        self.timedtextsTable.estimatedRowHeight = 60
        self.timedtextsTable.rowHeight = UITableViewAutomaticDimension
        
        evideo = self.contextValue()
        fetchData(true)
        ytPlayerInit()
        
//        NSNotificationCenter.defaultCenter().addObserver(
//            self,
//            selector: "moviePlayerNowPlayingMovieDidChange:",
//            name: MPMoviePlayerNowPlayingMovieDidChangeNotification,
//            object: ytPlayer?.moviePlayer)
//        
//        NSNotificationCenter.defaultCenter().addObserver(
//            self,
//            selector: "moviePlayerLoadStateDidChange:",
//            name: MPMoviePlayerLoadStateDidChangeNotification,
//            object: ytPlayer?.moviePlayer)
//        
//        NSNotificationCenter.defaultCenter().addObserver(
//            self,
//            selector: "moviePlayerPlaybackDidChange:",
//            name: MPMoviePlayerPlaybackStateDidChangeNotification,
//            object: ytPlayer?.moviePlayer)
//        
//        NSNotificationCenter.defaultCenter().addObserver(
//            self,
//            selector: "moviePlayerPlayBackDidFinish:",
//            name: MPMoviePlayerPlaybackDidFinishNotification,
//            object: ytPlayer?.moviePlayer)
    }

    // ページを去るときは動画を停止する
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if( self.ytPlayerPlaying ) {
            self.ytPlayer?.moviePlayer.stop()
        }
        
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
        print(indexPath.row)
    }
    
    // MARK: - Privates
    private func fetchData(initialize: Bool) {
        guard let evideo = self.evideo, id = evideo.id else { return }
        if !isLoading {
            isLoading = true
            
            if initialize {
                self.timedtexts = [Timedtext]()
                self.relatedEvideos = [Evideo]()
            }
            WebAPIClient().getEvideo(id) { result in
                switch result {
                case .Success(let timedtexts):
                    timedtexts.forEach{ self.timedtexts.append($0) }
                    //print(timedtexts)
                case .Failure(let error):
                    print(error)
                }
                SVProgressHUD.dismiss()
                self.isLoading = false
                self.tableInit()
            }
            
            WebAPIClient().getRelatedEvideos(id) { result in
                switch result {
                case .Success(let relatedEvideos):
                    relatedEvideos.forEach{ self.relatedEvideos.append($0) }
                case .Failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    // MARK: - Private
    private func tableInit() {
        self.timedtextsTable.reloadData()
        self.timedtextsTable.estimatedRowHeight = 60
        self.timedtextsTable.rowHeight = UITableViewAutomaticDimension
    }
    
    private func ytPlayerInit() {
//        let originX: CGFloat = self.view.bounds.origin.x
//        let originY: CGFloat = self.view.bounds.origin.y
//        let screenWidth: CGFloat = self.view.bounds.width
//        let screenHeight: CGFloat = screenWidth * 9 / 16
//        let ytFrame: CGRect = CGRect(x: originX, y: originY, width: screenWidth, height: screenHeight)
        guard let evideo = self.evideo, videoId = evideo.videoId else { return }
        self.ytPlayer?.videoIdentifier = videoId
        //self.ytPlayer?.view.frame = ytFrame
        //self.ytBackView.addSubview((self.ytPlayer?.view)!)

        self.ytPlayer?.moviePlayer.prepareToPlay()
        self.ytPlayer?.moviePlayer.shouldAutoplay = true
        self.ytPlayer?.moviePlayer.fullscreen = false
        self.ytPlayer?.presentInView(self.ytBackView)
        self.ytPlayer?.moviePlayer.play()
    }
}