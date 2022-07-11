//
//  UserTableItemViewController.swift
//  Notebook
//
//  Created by Mikhail on 24.06.2022.
//

import UIKit
import ImageViewer_swift
import EGOCache
import CoreData

class UserTableItemViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var userInfo: Users?
    var userImageVal = ""
    var nameVal = ""
    var genderVal = ""
    var dobVal = ""
    var age = 0
    var emailVal = ""
    var timeVal = ""
    var dobDate = Date()
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadURLCell()
    }

    func loadURLCell () {
        if let _dataImg = Data(base64Encoded: userImageVal) {
            userImageView.image = UIImage(data: _dataImg)
            userImageView.setupImageViewer()
        } else if let _image = EGOCache.global().image(forKey: userImageVal) {
            userImageView.image = _image
            userImageView.setupImageViewer()
        } else if NetworkMonitorService.shared.isConnected {
            loadImage()
        }
        
        nameLabel.text = "Name: " + nameVal
        
        if genderVal == "male" {
            genderImageView.image = UIImage(named: "male")
        } else {
            genderImageView.image = UIImage(named: "female")
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dobVal) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dobLabel.text = "Dob: " + dateFormatter.string(from: date) + " (age: \(age))"
        }
        
        emailLabel.text = "Email: " + emailVal
        locationLabel.text = "Location: " + timeVal
        
        getCurrentDate()
    }
    
    func loadImage() {
        AlamofireService.shared.getAllImagesFrom(photo: userImageVal) { [weak self] image in
            guard let _image = image else {return}

            self?.userImageView.image = _image
            self?.userImageView.setupImageViewer()
            
            if let _imgData = _image.jpegData(compressionQuality: 1)?.base64EncodedString() {
                DataManager.shared.saveUserInfo(userImageData: _imgData, userInfo: self?.userInfo)
            }

        } failure: { error in
            print(error.localizedDescription)
        }
    }
    
    func getCurrentDate() {
        if let _userInfo = userInfo {
            
            var date = Date()
            let myOffset = TimeZone.current.secondsFromGMT()
            let userOffset = _userInfo.location.timezone.offset.replacingOccurrences(of: ":", with: ".")
            guard let _userOffset = Double(userOffset) else {return}
            
            date.addTimeInterval(-1 * Double(myOffset) + _userOffset * 3600)
            dateFormatter.dateFormat = "HH:mm:ss"
            timeLabel.text = "Local time: " + dateFormatter.string(from: date)
        }
            
    }
    
    func refresh(_ user: Users) {
        userInfo = user
        
        userImageVal = user.picture.large
        nameVal = user.name.title + " " + user.name.first + " " + user.name.last
        genderVal = user.gender
        dobVal = user.dob.date
        age = user.dob.age
        emailVal = user.email
        timeVal = user.location.timezone.description + " " + user.location.timezone.offset
    }
    
}
