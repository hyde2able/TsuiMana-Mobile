//
//  TimedtextViewCell.swift
//  TsuimanaMobile
//
//  Created by 酒井英伸 on 2016/04/24.
//  Copyright © 2016年 pokohide. All rights reserved.
//


import UIKit

class TimedtextViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet private weak var startLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    
    // MARK: - Properties    
    var timedtext: Timedtext? {
        didSet {
            startLabel.text = startToSec(timedtext?.start)
            bodyLabel.text = timedtext?.body
        }
    }
    
    // MARK: - View life cycle
    override func awakeFromNib() {
    }
    
    // MARK: - Private
    private func startToSec(start: Int?) -> String {
        guard let start = start else { return "00:00" }
        let min = NSString(format: "%02d", start / 60)
        let sec = NSString(format: "%02d", start % 60)
        return "\(min):\(sec)"
    }
}