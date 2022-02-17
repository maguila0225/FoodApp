//
//  MessageVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/13/22.
//

import UIKit
import Firebase

class MessageVC: UIViewController {
    
    @IBOutlet weak var messageOutlet: UITextField!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var messageTableView: UITableView!
    
    let firestoreDatabase = Firestore.firestore()
    let signedInUser = UserDefaults.standard.object(forKey: "foodAppIsSignedInUser") as! String
    var recipientProfilePicture: UIImage = UIImage(systemName: "person.circle.fill")!
    
    var userDocID: String = ""
    var userEmail: String = ""
    public var userFullName: String = ""
    var roomMembers: [String] = []
    var roomMembersDocID: [String] = []
    var roomName: String = ""
    var roomListener: ListenerRegistration?
    var messageArray: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDocID()
        getRoomMembersDocID()
        getRoomName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        setupTableView()
        messageTableView.reloadData()
        messageTableView.scrollToBottomRow()
    }
    

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        roomListener!.remove()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MessageVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkRoom()
        return true
    }
}

extension MessageVC{
    func getUserDocID(){
        let docRef = firestoreDatabase.collection("UserInfo").whereField("email", isEqualTo: signedInUser)
        docRef.getDocuments { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else {
                print(error!.localizedDescription)
                return
            }
            for document in snapshot.documents{
                self.userDocID = document.documentID
                let data = document.data()
                self.userEmail = data["email"] as! String
                self.userFullName = (data["firstName"] as! String) + " " + (data["lastName"] as! String)
            }
        }
    }
    
    func getRoomMembersDocID(){
        for i in 0...(roomMembers.count - 1){
            let docRef = firestoreDatabase.collection("UserInfo").whereField("email", isEqualTo: roomMembers[i])
            docRef.getDocuments { querySnapshot, error in
                guard let snapshot = querySnapshot, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                for document in snapshot.documents{
                    self.roomMembersDocID.append(document.documentID)
                }
            }
        }
    }
    
    func getRoomName(){
        for i in 0...(roomMembers.count - 1){
            roomName = roomName + roomMembers[i] + "_"
        }
    }
    
    func setupView(){
        messageOutlet.delegate = self
        userName.text = roomName
        self.roomListener = setupListener()
    }
    
    func setupListener() -> ListenerRegistration{
        let db = firestoreDatabase
        let listener = db.collection("Room").document(roomName)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                guard data["messages"] != nil else{ return }
                self.messageArray = []
                let messages = data["messages"] as! [String:[String]]
                for i in 0...(messages.count - 1){
                    self.messageArray.append(messages["message\(i)"]!)
                }
                print(self.messageArray)
                self.messageTableView.reloadData()
                self.messageTableView.scrollToBottomRow()
            }
        return listener
    }
    
    func setupTableView(){
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(ChatBubbleCell.nib(), forCellReuseIdentifier: ChatBubbleCell.identifier)
    }
    
    func checkRoom(){
        let roomName = roomName
        if UserDefaults.standard.bool(forKey: roomName) == true {
            getMessage(roomName: roomName)
        }
        
        else{
            UserDefaults.standard.set(true, forKey: roomName)
            UserDefaults.standard.synchronize()
            newRoomSetup(roomName: roomName)
        }
    }
    
    fileprivate func newRoomSetup(roomName: String) {
        for i in 0...(roomMembersDocID.count - 1){
            let docRef = firestoreDatabase.collection("MessageRoom").document(roomMembersDocID[i])
            updateMessageRoom(docRef: docRef, roomName: roomName)
        }
        
        let docRefRoom = firestoreDatabase.collection("Room").document(roomName)
        createRoom(docRefRoom: docRefRoom, roomName: roomName)
    }
    
    fileprivate func updateMessageRoom(docRef: DocumentReference, roomName: String) {
        docRef.getDocument { document, error in
            guard let doc = document, error == nil else { return }
            if doc.exists{
                var rooms = doc["rooms"] as! [String]
                if rooms.contains(roomName){
                    return
                }
                else{
                    rooms.append(roomName)
                    docRef.setData(["rooms":rooms], merge: true, completion: nil)
                }
            } else {
                var rooms: [String:[String]] = [:]
                rooms["rooms"] = []
                rooms["rooms"]!.append(roomName)
                docRef.setData(rooms, merge: true, completion: nil)
            }
        }
    }
    
    fileprivate func createRoom(docRefRoom: DocumentReference, roomName: String) {
        docRefRoom.setData(["roomMembers": self.roomMembers])
        getMessage(roomName: roomName)
    }
    
    fileprivate func getMessage(roomName: String){
        let docRefRoom = firestoreDatabase.collection("Room").document(roomName)
        docRefRoom.getDocument { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else { return }
            guard let data = snapshot.data() else{
                print("no data")
                return
            }
            if data["messages"] != nil {
                var messages = data["messages"] as! [String:[String]]
                let count = messages.count
                let messageTimestamp = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
                let message = self.messageOutlet.text ?? " "
                messages["message\(count)"] = [message,messageTimestamp,self.userFullName]
                self.sendMessage(messages: messages)
            }
            else {
                var messages: [String:[String]] = [:]
                let timestamp = Date()
                let messageTimestamp = timestamp.toString(format: "yyyy-MM-dd HH:mm:ss")
                let message = self.messageOutlet.text ?? " "
                messages["message0"] = [message,messageTimestamp,self.userFullName]
                self.sendMessage(messages: messages)
            }
        }
    }
    
    fileprivate func sendMessage(messages: [String:[String]]) {
        let docRefRoom = firestoreDatabase.collection("Room").document(roomName)
        docRefRoom.updateData(["messages":messages])
        clearTextField()
    }
    
    fileprivate func clearTextField(){
        messageOutlet.text = ""
        messageOutlet.resignFirstResponder()
    }
    
}

extension  MessageVC: UITableViewDelegate{
    
}

extension MessageVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: ChatBubbleCell.identifier) as! ChatBubbleCell
        DispatchQueue.main.async {
            cell.configure(sender: self.messageArray[indexPath.row][2],
                           message: self.messageArray[indexPath.row][0],
                           timestamp: self.messageArray[indexPath.row][1],
                           user: self.userFullName)
        }
        
        return cell
    }
}
