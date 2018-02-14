//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by yxx3tch on 2018/02/13.
//  Copyright © 2018年 yxx3tch. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(_ postData: PostData) {
        self.postImageView.image = postData.image
        
        let caption = "\(postData.name!) : \(postData.caption!)\n"
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: postData.date!)
        self.dateLabel.text = dateString
        
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        var comments = "Comments\n"
        var dates: [Date] = []
        
        for(_, comment) in postData.comments {
            let date = Date.init(timeIntervalSinceReferenceDate: Double(comment["time"]!)!)
            dates.append(date)
        }
        
        dates.sort {$0 < $1}
        
        for d in dates {
            for (_, comment) in postData.comments {
                let date = Date.init(timeIntervalSinceReferenceDate: Double(comment["time"]!)!)
                if date == d {
                    comments += "\(comment["name"]!) : \(comment["comment"]!)\n"
                }
            }
        }
        
        self.captionLabel.text = caption + comments
    }
}
