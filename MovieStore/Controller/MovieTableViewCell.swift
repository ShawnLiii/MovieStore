//
//  MovieTableViewCell.swift
//  MovieStore
//
//  Created by Shawn Li on 5/3/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell
{

    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieName: UILabel!
    
    @IBOutlet weak var movieType: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
