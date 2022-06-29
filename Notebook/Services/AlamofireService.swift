//
//  AlamofireService.swift
//  Notebook
//
//  Created by Mikhail on 24.06.2022.
//

import Foundation
import Alamofire
import EGOCache

class AlamofireService {
    
    static let shared = AlamofireService()
    private let baseURL = "https://randomuser.me/api/?"
    private let params = "results=10&inc=picture,name,gender,dob,email,location"
    let tmp = "https://randomuser.me/api/?results=10&inc=picture,name,gender,dob,email,location"
    
    func getFriendsInfo(success: @escaping ((_ items: [Users]?) -> Void), failure: @escaping ((_ error: NSError) -> Void)) {
        AF.request(baseURL+params, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseDecodable(of: UserModel.self) { [weak self] data in
                
                switch data.result {
                case .success(_):
                    guard let users = data.value else {return}
                    success(users.results)
                case .failure(let error):
                    failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription]))
                }
                
            }
    }
    
    func getAllImagesFrom(photo: String, success: @escaping ((_ image: UIImage?) -> Void), failure: @escaping ((_ error: NSError) -> Void)) {
        AF.request(photo, method: .get, encoding: URLEncoding.default).response {
            [weak self] responseData in

            guard responseData.data != nil else {
                failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error: Empty data"]))
                return
            }
            
            let respImage = responseData.data.map(UIImage.init(data:))
            if let _respImage = respImage, let _respImage2 = _respImage {
                EGOCache.global().setImage(_respImage2, forKey: photo)
                success(_respImage2)
            }
        }
    }

}
