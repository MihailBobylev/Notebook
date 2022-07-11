//
//  UserViewController.swift
//  Notebook
//
//  Created by Mikhail on 24.06.2022.
//

import UIKit
import CoreData

class UserViewController: UIViewController {

    @IBOutlet weak var userTable: UITableView!
    
    var usersResponseModel = [Users]()
    var imgArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Users"
        userTable.delegate = self
        userTable.dataSource = self
        userTable.register(UINib(nibName: "UserInfoCell", bundle: nil), forCellReuseIdentifier: "UserInfoCellId")
        
        if let _usersResponseModel = DataManager.shared.loadUserInfo() {
            usersResponseModel = _usersResponseModel
        }

        if usersResponseModel.count == 0 && NetworkMonitorService.shared.isConnected {
            getUsers()
        }
    }
    
    func getUsers() {
        AlamofireService.shared.getFriendsInfo { [weak self] items in
            guard let _items = items else {return}
            self?.usersResponseModel += _items
            self?.userTable.reloadData()
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usersResponseModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCellId", for: indexPath) as? UserInfoCell {
            if usersResponseModel.count != 0 {
                let item = usersResponseModel[indexPath.row]
                cell.refresh(item)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = usersResponseModel.count - 1
        if indexPath.row == lastElement && NetworkMonitorService.shared.isConnected {
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.startAnimating()
            if let tvFooterHeight = tableView.tableFooterView?.bounds.height {
                spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tvFooterHeight)
            } else {
                spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height / 5)
            }
            
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false

            getUsers()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = usersResponseModel[indexPath.row]
        
        let storyBoard = UIStoryboard(name: "UserTableItem", bundle:nil)
        if let resultViewController = storyBoard.instantiateViewController(withIdentifier: "UserTableItemViewControllerId") as? UserTableItemViewController {
            
            resultViewController.refresh(item)
            
            navigationController?.pushViewController(resultViewController, animated: true)
        }
    }
}
