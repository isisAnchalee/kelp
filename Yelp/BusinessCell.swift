//
//  BusinessCell.swift
//  Yelp
//
//  Created by Isis Anchalee on 2/11/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    var business: Business!{
        didSet {
            nameLabel.text = business.name
            thumbImageView.setImageWithURL((business.imageURL ?? NSURL(string:"http://placekitten.com/200/300"))!)
            categoryLabel.text = business.categories
            addressLabel.text = business.address
            reviewCountLabel.text = "\(business.reviewCount!)"
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            distanceLabel.text = business.distance
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
