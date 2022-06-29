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
        } else {
            loadImage()
        }
        
        nameLabel.text = nameVal
        
        if genderVal == "male" {
            genderImageView.image = UIImage(named: "male")
        } else {
            genderImageView.image = UIImage(named: "female")
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dobVal) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            dobVal = dateFormatter.string(from: date)
            if let _dobDate = dateFormatter.date(from: dobVal) {
                dobDate = _dobDate
            }
            
            dobLabel.text = dateFormatter.string(from: date) + " (\(age))"
        }
        emailLabel.text = emailVal
        locationLabel.text = timeVal
        
        getCurrentDate()
    }
    
    func loadImage() {
        AlamofireService.shared.getAllImagesFrom(photo: userImageVal) { [weak self] image in
            guard let _image = image else {return}

            self?.userImageView.image = _image
            self?.userImageView.setupImageViewer()
            
            if let _imgData = _image.jpegData(compressionQuality: 1)?.base64EncodedString() {
                self?.saveUserInfo(userImageData: _imgData)
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
            guard let userDoubleOffset = Double(userOffset) else {return}
            
            date.addTimeInterval(-1 * Double(myOffset) + userDoubleOffset * 3600)
            dateFormatter.dateFormat = "HH:mm:ss"
            let s = dateFormatter.string(from: date)
            timeLabel.text = s
        }
            
    }
    func saveUserInfo(userImageData: String) {
        if let _userInfo = userInfo {
            
            //1
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
             
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //2
            guard let entity = NSEntityDescription.entity(forEntityName: "UserInfoTmp", in: managedContext) else {return}
            let userNSModel = NSManagedObject(entity: entity, insertInto: managedContext)
            
            //3
            userNSModel.setValue(userImageData, forKey: "image")
            userNSModel.setValue(_userInfo.dob.date, forKey: "date")
            userNSModel.setValue(_userInfo.email, forKey: "email")
            userNSModel.setValue(_userInfo.gender, forKey: "gender")
            userNSModel.setValue(_userInfo.name.first, forKey: "first")
            userNSModel.setValue(_userInfo.name.last, forKey: "last")
            userNSModel.setValue(_userInfo.name.title, forKey: "title")
            userNSModel.setValue(_userInfo.location.timezone.offset, forKey: "offset")
            userNSModel.setValue(_userInfo.location.timezone.description, forKey: "userDescription")
            userNSModel.setValue(_userInfo.dob.age, forKey: "age")
              
            //4
            do {
                try managedContext.save()
            } catch {
                print(error.localizedDescription)
            }
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
