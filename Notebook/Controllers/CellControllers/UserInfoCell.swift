//
//  UserInfoCell.swift
//  Notebook
//
//  Created by Mikhail on 24.06.2022.
//

import UIKit
import SDWebImage

class UserInfoCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func refresh (_ user: Users) {
        
        if let _dataImg = Data(base64Encoded: user.picture.large) {
            userImageView.image = UIImage(data: _dataImg)
        } else {
            if let url = URL(string: user.picture.large) {
                userImageView.sd_setImage(with: url)
            }
        }
        
        userImageView.contentMode = .scaleToFill
        nameLabel.text = user.name.title + " " + user.name.first + " " + user.name.last

    }
    
}
