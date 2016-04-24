//
//  EvideoViewCell.swift
//  TsuimanaMobile
//
//  Created by 酒井英伸 on 2016/04/24.
//  Copyright © 2016年 pokohide. All rights reserved.
//

import UIKit

class EvideoViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var word: UILabel!

    
    // MARK: - Properties
    var evideo: Evideo? {
        didSet {
            print(evideo?.title)
            // TODO: SDWebImageを使う
            if let url = evideo?.imageUrl {
                do {
                    let imageData = try NSData(contentsOfURL: url, options: .DataReadingMappedIfSafe)
                    thumbnail.image = UIImage(data: imageData)
                } catch {
                    print("Error: can't create image.")
                }
            }
            
            title.text = evideo?.title
            word.text = evideo?.word
        }
    }
    
    // MARK: - View life cycle
    override func awakeFromNib() {
    }
}