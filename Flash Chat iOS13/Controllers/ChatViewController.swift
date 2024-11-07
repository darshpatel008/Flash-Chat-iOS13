//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal


class ChatViewController: UIViewController 
{
    
   
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
  
    
    let db = Firestore.firestore()
    
    var message: [Message] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        messageTextfield.delegate = self
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(
            UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier:K.cellIdentifier )
        
        loadmessage()
    
    }
    
    func loadmessage()
    {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener {
            QuerySnapshot, error in
            
            self.message = []
            
            if let e = error
            {
                print("There was a issue in retrieving the data from firebase,\(e)")
            }
            else
            {
                if let snapshotDocument = QuerySnapshot?.documents
                {
                    for doc in snapshotDocument 
                    {
                        let data = doc.data()
                        if let messagesender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String
                        {
                            let newMessage = Message(sender: messagesender, body: messageBody)
                            self.message.append(newMessage)
                            
                            DispatchQueue.main.async {
                                // to trigger UITableViewDataSource
                                self.tableView.reloadData()
                                
                                //animation so we go to very bottom of our chat when page is open and no need to scroll while keyboard is open
                                let indexPath = IndexPath(row: self.message.count - 1, section: 0)
                                
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) 
    {
        
       if let messageBody = messageTextfield.text , let messageSender = Auth.auth().currentUser?.email
        {
           db.collection(K.FStore.collectionName).addDocument(data: [
            //key               : value
            K.FStore.senderField: messageSender,
            K.FStore.bodyField: messageBody,
            K.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
               if let e = error
               {
                   print("Issue in saving data,\(e)")
               }
                else
                {
                   print("successfully saved data")
                    
                    DispatchQueue.main.async
                    {
                        self.messageTextfield.text = ""
                    }
                   
                }
           }
       }
       
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) 
    {
        
        let firebaseAuth = Auth.auth()
        do 
        {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch let signOutError as NSError
        {
          print("Error signing out: %@", signOutError)
        }
    }
    
}


extension ChatViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
    {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        
        let message = message[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        as! MessageCellTableViewCell
        
        
        //this is message from me user
        if message.sender == Auth.auth().currentUser?.email
        {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            //messagebubble is uiview from object library
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        //this is message from you user
        else
        {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            //messagebubble is uiview from object library
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
       
        cell.label.text = message.body
        return cell
    }
    
}

//MARK: - UITEXTFIELD


extension ChatViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        messageTextfield.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if textField.text != ""
        {
            return true
        }
        else
        {
            textField.placeholder = "Type something"
            return false
        }
    }
  
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if let messagebody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email
        {
            db.collection(K.FStore.collectionName).addDocument(data:     [K.FStore.senderField : messageSender,K.FStore.bodyField : messagebody, K.FStore.dateField : Date().timeIntervalSince1970 ]){ (error) in
                if let e = error
                {
                    print("Issue in saving data,\(e)")
                }
                 else
                 {
                    print("successfully saved data")
                     
                     DispatchQueue.main.async
                     {
                         self.messageTextfield.text = ""
                     }
                    
                 }
            }
        }
    }
    
}
