//
//  DataManager.swift
//  Notebook
//
//  Created by Mikhail on 11.07.2022.
//

import Foundation
import UIKit
import CoreData

struct DataManager {
    
    static let shared = DataManager()
    
    func loadUserInfo() -> [Users]? {
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
         
        let managedContext = appDelegate.persistentContainer.viewContext
         
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfoTmp")
        var usersResponseModel = [Users]()
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                for data in result {
                    let userInfo = Users(
                        dob: Dob(
                            age: data.value(forKey: "age") as? Int ?? 0,
                            date: data.value(forKey: "date") as? String ?? "None"),
                        email: data.value(forKey: "email") as? String ?? "None",
                        gender: data.value(forKey: "gender") as? String ?? "None",
                        location: Location(
                            timezone: Timezone(
                                description: data.value(forKey: "userDescription") as? String ?? "None",
                                offset: data.value(forKey: "offset") as? String ?? "None")),
                        name: Name(
                            first: data.value(forKey: "first") as? String ?? "None",
                            last: data.value(forKey: "last") as? String ?? "None",
                            title: data.value(forKey: "title") as? String ?? "None"),
                        picture: Picture(
                            large: data.value(forKey: "image") as? String ?? ""))
                    
                    usersResponseModel.append(userInfo)
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        return usersResponseModel
    }
    
    func saveUserInfo(userImageData: String, userInfo: Users?) {
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
    
    func deleteData() {
        guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserInfoTmp")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try managedContext.execute(deleteRequest)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
    }
}
