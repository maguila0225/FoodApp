//
//  NewMessageVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/13/22.
//

import UIKit
import Firebase

class NewMessageVC: UIViewController {
    
    @IBOutlet weak var recipientListTextField: UITextField!
    @IBOutlet weak var usersTableView: UITableView!
    
    let firestoreDatabase = Firestore.firestore()
    let storage = Storage.storage()
    let signedInUser = UserDefaults.standard.object(forKey: "foodAppIsSignedInUser")
    var userList: [[String:Any]] = []
    var docIDList: [String] = []
    var roomMembers: [String] = []
    var userDocID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        getUsersFromFirebase()
        
    }
}

extension NewMessageVC{
    func setupView(){
        view.layer.cornerRadius = 20
        usersTableView.delegate = self
        usersTableView.dataSource = self
        recipientListTextField.delegate = self
    }
    
    func setupTableView(){
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.register(NewMessageTableViewCell.nib(), forCellReuseIdentifier: NewMessageTableViewCell.identifier)
    }
    
    func getUsersFromFirebase(){
        let colRef = firestoreDatabase.collection("UserInfo").whereField("email", isNotEqualTo: self.signedInUser ?? "")
        colRef.getDocuments { snapshot, error in
            guard let querySnapshot = snapshot, error == nil else{
                print("getDocuments failed: \(error!.localizedDescription)")
                return
            }
            for document in querySnapshot.documents{
                self.docIDList.append(document.documentID)
                self.userList.append(document.data())
            }
            self.usersTableView.reloadData()
        }
    }
}

extension NewMessageVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if roomMembers.contains(userList[indexPath.row]["email"] as! String) == false{
            roomMembers.append(userList[indexPath.row]["email"] as! String)
            recipientListTextField.text = recipientListTextField.text! +
            (userList[indexPath.row]["email"] as! String) + " "
            recipientListTextField.becomeFirstResponder()
        }
        print(self.roomMembers)
    }
}

extension NewMessageVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docIDList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersTableView.dequeueReusableCell(withIdentifier: NewMessageTableViewCell.identifier) as! NewMessageTableViewCell
        
        let name = (userList[indexPath.row]["firstName"] as! String) + " " + (userList[indexPath.row]["lastName"] as! String)
        let image = UIImage(systemName: "person")!
        cell.configure(Name: name, Image: image)
        return cell
    }
}

extension NewMessageVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let sortedRoomMembers = sortUsers()
        presentMessageVC(sortedRoomMembers)
        return true
    }
    
    func sortUsers() -> [String]{
        self.roomMembers.append(signedInUser as! String)
        let sortedRoomMembers = self.roomMembers.sorted()
        return sortedRoomMembers
    }

    fileprivate func presentMessageVC(_ sortedRoomMembers: [String]) {
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
        vc.roomMembers = sortedRoomMembers
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
