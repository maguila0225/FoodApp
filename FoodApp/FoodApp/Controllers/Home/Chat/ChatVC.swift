//
//  ChatVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/9/22.
//

import UIKit
import Firebase
import FirebaseFirestore


class ChatVC: UIViewController {
    
    @IBOutlet weak var searchBackground: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var chatHomeTableView: UITableView!
    
    let firestoreDatabase = Firestore.firestore()
    var userDocID: String = ""
    let magnifier = UIImageView()
    let signedInUser = UserDefaults.standard.object(forKey: "foodAppIsSignedInUser") as? String
    var joinedRooms: [String] = []
    var roomMembers: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        getUserDocID()
    }
    
}

extension ChatVC{
    func setupView(){
        title = "Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchTextField.setLeftPaddingPoints(47)
        searchTextField.addSubview(magnifier)
        searchBackground.layer.cornerRadius = 15
        magnifier.frame = CGRect(x: 16, y: 13, width: 24, height: 24)
        magnifier.image = UIImage(systemName: "magnifyingglass")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(presentNewMessageVC))
    }
    
    func setupTableView(){
        chatHomeTableView.delegate = self
        chatHomeTableView.dataSource = self
        chatHomeTableView.register(ChatHomeTableViewCell.nib(), forCellReuseIdentifier: ChatHomeTableViewCell.identifier)
    }
    
    func getUserDocID(){
        let docRef = firestoreDatabase.collection("UserInfo").whereField("email", isEqualTo: signedInUser!)
        docRef.getDocuments { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else {
                print(error!.localizedDescription)
                return
            }
            for document in snapshot.documents{
                self.userDocID = document.documentID
            }
            self.getJoinedRooms()
        }
    }
    
    func getJoinedRooms(){
        let docRef = firestoreDatabase.collection("MessageRoom").document(userDocID)
        docRef.getDocument { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = snapshot.data() else { return }
            let rooms = data["rooms"] as! [String]
            self.joinedRooms = rooms
            self.chatHomeTableView.reloadData()
            self.setJoinedRooms(joinedRooms: rooms)
        }
    }
    
    func setJoinedRooms(joinedRooms: [String]){
        for i in 0...(joinedRooms.count - 1){
            UserDefaults.standard.set(true, forKey: joinedRooms[i])
            print(joinedRooms[i])
        }
    }
    
    @objc func presentNewMessageVC(){
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "NewMessageVC") as! NewMessageVC
        vc.userDocID = userDocID
        present(vc, animated: true, completion: nil)
    }
    
}

extension ChatVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRoom = self.joinedRooms[indexPath.row]
        getRoomMembers(selectedRoom)
    }
    
    fileprivate func getRoomMembers(_ selectedRoom: String) {
        let docRefRoom = firestoreDatabase.collection("Room").document(selectedRoom)
        docRefRoom.getDocument { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else {
                print(error?.localizedDescription ?? "error encountered")
                return
            }
            let data = snapshot.data()
            self.roomMembers = data!["roomMembers"] as! [String]
            self.presentMessageVC()
        }
    }
    
    fileprivate func presentMessageVC(){
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
        vc.roomMembers = self.roomMembers
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension ChatVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joinedRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatHomeTableView.dequeueReusableCell(withIdentifier: ChatHomeTableViewCell.identifier) as! ChatHomeTableViewCell
        
        DispatchQueue.main.async {
            cell.configure(roomName: self.joinedRooms[indexPath.row])
        }
        return cell
    }
    
}
