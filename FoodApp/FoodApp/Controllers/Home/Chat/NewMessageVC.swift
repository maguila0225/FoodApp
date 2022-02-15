//
//  NewMessageVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/13/22.
//

import UIKit
import Firebase

class NewMessageVC: UIViewController {
    
    @IBOutlet weak var personSearchTextField: UITextField!
    @IBOutlet weak var usersTableView: UITableView!
    let firestoreDatabase = Firestore.firestore()
    let storage = Storage.storage()
    let signedInUser = UserDefaults.standard.object(forKey: "foodAppIsSignedInUser")
    var userList: [[String:Any]] = []
    var docIDList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        getUsersFromFirebase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}

extension NewMessageVC{
    
    func setupView(){
        view.layer.cornerRadius = 20
        usersTableView.delegate = self
        usersTableView.dataSource = self
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
    
    func presentMessageVC(_ indexPath: IndexPath) {
        print("conversation started with: \(docIDList[indexPath.row])")
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
        vc.recipientName = (userList[indexPath.row]["firstName"] as! String) + " " + (userList[indexPath.row]["lastName"] as! String)
        vc.recipientProfilePicture = UIImage(systemName: "person")!
        vc.recipientDocID = docIDList[indexPath.row]
        vc.recipientEmail = userList[indexPath.row]["email"] as! String
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension NewMessageVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentMessageVC(indexPath)
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

