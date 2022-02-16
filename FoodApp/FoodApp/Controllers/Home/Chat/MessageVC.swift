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
    
    
    var recipientName: String = ""
    var recipientEmail: String = ""
    var recipientProfilePicture: UIImage = UIImage(systemName: "person.circle.fill")!
    var recipientDocID: String = ""
    
    var userDocID: String = ""
    var roomMembers: [String] = []
    var roomMembersDocID: [String] = []
    var roomName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageOutlet.delegate = self
        getUserDocID()
        getRoomMembersDocID()
        getRoomName()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func checkRoom(){
        let roomName = roomName
        if UserDefaults.standard.bool(forKey: roomName) == true {
            print("conversation exists, proceed with sending message")
            getMessage(roomName: roomName)
        }
        
        else{
            print("no conversation exists, create new conversation")
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
                docRef.updateData([roomName:roomName])
            } else {
                docRef.setData([roomName:roomName])
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
            print(data["messages"] ?? "data[messages] is nil")
            
            if data["messages"] != nil {
                var messages = data["messages"] as! [String:[String]]
                let count = messages.count
                let timestamp = Date()
                let messageTimestamp = timestamp.toString(format: "yyyy-MM-dd HH:mm:ss")
                let message = self.messageOutlet.text ?? " "
                messages["message\(count)"] = [message,messageTimestamp,self.userDocID]
                self.sendMessage(messages: messages)
            }
            else {
                var messages: [String:[String]] = [:]
                let timestamp = Date()
                let messageTimestamp = timestamp.toString(format: "yyyy-MM-dd HH:mm:ss")
                let message = self.messageOutlet.text ?? " "
                messages["message0"] = [message,messageTimestamp,self.userDocID]
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

