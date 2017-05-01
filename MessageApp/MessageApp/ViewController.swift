//
//  ViewController.swift
//  MessageApp
//
//  Created by auston salvana on 2017-04-30.
//  Copyright © 2017 ASolo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var textViewInput: UITextView!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    var ref: FIRDatabaseReference!
    let user = "Me"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        setupFirebase()
        setupTextViewInput()
        
        let postRef = ref.child("Me")
        postRef.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper methods
    
    deinit {
        // TODO: deinit the observers
        
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupFirebase() {
        ref = FIRDatabase.database().reference()
    }
    
    func sendMessage() {
        let message = self.textViewInput.text!
        let post = Post(message: message, user: user)
        ref.child(post.user).childByAutoId().setValue(post.message)
    }
    
    func setupTextViewInput() {
        textViewInput.textContainer.maximumNumberOfLines =  8
        textViewInput.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    func clearTextViewInput() {
        textViewInput.text = ""
    }
    
    func updateTableView() {
        
    }
    
    //MARK: Keyboard
    
    func keyboardWillShow(notification: NSNotification){
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary        
        let keyboardSizeNow:CGSize = (userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey)! as AnyObject).cgRectValue.size
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottom.constant = keyboardSizeNow.height
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottom.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    //MARK: IBActions
    
    @IBAction func sendButton(_ sender: Any) {
        sendMessage()
        clearTextViewInput()
        updateTableView()
    }
    
    
    
    

}

