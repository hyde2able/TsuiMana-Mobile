//
//  EvideoViewCell.swift
//  TsuimanaMobile
//
//  Created by 酒井英伸 on 2016/04/24.
//  Copyright © 2016年 pokohide. All rights reserved.
//

import UIKit
import SDWebImage

class EvideoViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var thumbnail: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var word: UILabel!

    // MARK: - Properties
    var evideo: Evideo? {
        didSet {
            guard let url = evideo?.imageUrl else { return }
            thumbnail.sd_setImageWithURL(url, placeholderImage: nil)
            title.text = evideo?.title
            word.text = evideo?.word
        }
    }
    
    // MARK: - View life cycle
    override func awakeFromNib() {
    }
}