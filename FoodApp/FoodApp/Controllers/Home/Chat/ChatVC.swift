//
//  ChatVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/9/22.
//

import UIKit

class ChatVC: UIViewController {
    
    @IBOutlet weak var searchBackground: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var chatHomeTableView: UITableView!
    
    let magnifier = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(pushToNewMessageVC))
    }
    
    func setupTableView(){
        chatHomeTableView.delegate = self
        chatHomeTableView.dataSource = self
        chatHomeTableView.register(ChatHomeTableViewCell.nib(), forCellReuseIdentifier: ChatHomeTableViewCell.identifier)
    }
    
    @objc func pushToNewMessageVC(){
        
    }

}

extension ChatVC: UITableViewDelegate{
    
}

extension ChatVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatHomeTableView.dequeueReusableCell(withIdentifier: ChatHomeTableViewCell.identifier) as! ChatHomeTableViewCell
        
        return cell
    }
    
    
}
