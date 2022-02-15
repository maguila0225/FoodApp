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
    var userDocID: String = ""
    var recipientName: String = ""
    var recipientEmail: String = ""
    var recipientProfilePicture: UIImage = UIImage(systemName: "person.circle.fill")!
    var recipientDocID: String = ""
    var messageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageOutlet.delegate = self
        getUserDocID()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userName.text = recipientName
        profilePicture.image = recipientProfilePicture
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    func checkRoom(){
        let roomName = signedInUser + "_" + self.recipientEmail
        let roomName2 = self.recipientEmail + "_" + signedInUser

        if UserDefaults.standard.bool(forKey: roomName) == true ||
            UserDefaults.standard.bool(forKey: roomName2) == true{
            print("conversation exists, proceed with sending message")
            getMessageCount(roomName: roomName)
        }
        else{
            print("no conversation exists, create new conversation")
            UserDefaults.standard.set(true, forKey: roomName)
            UserDefaults.standard.synchronize()
            newRoomSetup(roomName)
        }
    }
    
    fileprivate func getMessageCount(roomName: String){
        let docRefRoom = firestoreDatabase.collection("Room").document(roomName)
        let _ = docRefRoom.getDocument { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.messageCount = snapshot.data()!["messageCount"] as! Int
        }
        sendMessage(docRefRoom)
    }
    
    fileprivate func sendMessage(_ docRefRoom: DocumentReference) {
        docRefRoom.updateData(["message\(messageCount)":["message\(messageCount)",
                                                         (messageOutlet.text ?? ""),
                                                         "timestamp",
                                                         userDocID]], completion: nil)
        docRefRoom.updateData(["messageCount":self.messageCount + 1])
    }
    
    fileprivate func newRoomSetup(_ roomName: String) {
        let docRefUser = firestoreDatabase.collection("MessageRoom").document(userDocID)
        let docRefRecipient = firestoreDatabase.collection("MessageRoom").document(recipientDocID)
        let docRefRoom = firestoreDatabase.collection("Room").document(roomName)
        docRefUser.setData([roomName:roomName])
        docRefRecipient.setData([roomName:roomName])
        docRefRoom.setData(["messageCount":0])
        getMessageCount(roomName: roomName)
    }
}

extension MessageVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkRoom()
        print("message: \(messageOutlet.text ?? "")")
        print("sender: \(userDocID)")
        print("receiver: \(recipientDocID)")
        messageOutlet.text = ""
        messageOutlet.resignFirstResponder()
        return true
    }
}
