//
//  EvideoTableViewControllers.swift
//  TsuimanaMobile
//
//  Created by 酒井英伸 on 2016/04/24.
//  Copyright © 2016年 pokohide. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON
import SegueContext
import SVProgressHUD

class EvideoTableViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    var category: Category? = .All {
        didSet {
            title = category?.rawValue
        }
    }

    var evideos = [Evideo]()
    private var isLoading = false
    private var page = 1
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        SVProgressHUD.show()
        fetchData(true)
    }
    
    // MARK: - Publics
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= 0 {
            fetchData(false)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EvideoCell", forIndexPath: indexPath) as! EvideoViewCell
        cell.evideo = evideos[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.evideos.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EvideoViewCell
        self.performSegueWithIdentifier("showEvideo", context: cell.evideo)
    }
    
    // MARK: - Privates
    private func fetchData(initialize: Bool) {
        guard let category = category else { return }
        if !isLoading {
            isLoading = true
            
            if initialize {
                self.page = 1
                self.evideos = [Evideo]()
            }
            
            WebAPIClient().getAllEvideos(page, category: category) { result in
                switch result {
                case .Success(let evideos):
                    evideos.forEach { self.evideos.append($0) }
                    self.tableView.reloadData()
                    self.page += 1
                case .Failure(let error):
                    print(error)
                }
                SVProgressHUD.dismiss()
                self.isLoading = false
                self.tableView.reloadData()
            }
        }
    }
    
}
