//
//  ViewController.swift
//  Exercise2
//
//  Created by David Munoz on 02/08/2018.
//  Copyright © 2018 David Munoz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    let reuseIdentifier = "messageCell"
    var messages = [Message]()
    var selectedMessage : Message!
    @IBOutlet weak var bottomTextFieldConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        messageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
     /*   let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture)*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendTextMessage(_ sender: Any) {
        let newMessage = Message()
        newMessage.text = messageTextField.text
        newMessage.sentDate = Date()
        newMessage.sender = SenderTypes.me.rawValue
        newMessage.image = nil
        send(message: newMessage)
        messageTextField.text = ""
        sendButton.isEnabled = false
    }
    
    @IBAction func pickImageButtonPressed(_ sender: Any) {
        pickImage()
    }
    @objc func hideKeyboard(){
        messageTextField.resignFirstResponder()
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.messages.count > 2{
                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    fileprivate func send(message: Message){
        let lastRow = messages.count
        let lastRowIndex = IndexPath(item: lastRow, section: 0)
        messages.append(message)
        messagesTableView.insertRows(at: [lastRowIndex], with: UITableViewRowAnimation.right)

        self.scrollToBottom()
        //THIS IS FOR ECCHOES MESSAGES
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (_) in
            let echoeMessage = Message()
            echoeMessage.text = nil
            echoeMessage.sentDate = Date()

            echoeMessage.sender = SenderTypes.other.rawValue
            if let text = message.text {
                echoeMessage.text = text
            }else{
                echoeMessage.image = message.image!
            }
            self.messages.append(echoeMessage)
            let lastRowIndex = IndexPath(item: lastRow+1, section: 0)
            self.messagesTableView.insertRows(at: [lastRowIndex], with: UITableViewRowAnimation.left)
            self.scrollToBottom()
        }
    }
    
    @objc fileprivate func textFieldDidChange(_ sender:UITextField){
    
        sendButton.isEnabled = (sender.text?.count ?? 0) > 0 ? true : false

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            if let nextVC = segue.destination as? DetailsViewController{
                nextVC.message = selectedMessage
            }
        }
    }
}

//MARK: - Extension TableViewDelegate
extension ViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MessageTableViewCell
        let height = cell.getPreferedHeightFor(message: messages[indexPath.row])
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMessage = messages[indexPath.row]
        self.performSegue(withIdentifier: "showDetails", sender: self)
    }
}

//MARK: - Extension TableViewDataSource
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MessageTableViewCell
        cell.clipsToBounds = true
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.backgroundColor = .clear
        cell.show(message: messages[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

//MARK:- Keyboard
extension ViewController {
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        bottomTextFieldConstraint.constant = -keyboardSize.height
        view.layoutIfNeeded()
        scrollToBottom()
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        bottomTextFieldConstraint.constant = 0
    }
}


//MARK: - UIImagePickerControllerDelegate
extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func pickImage(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
        print("Button capture")
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imag.allowsEditing = false
            self.present(imag, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
         if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let newMessage = Message()
            newMessage.text = nil
            newMessage.sender = SenderTypes.me.rawValue
            newMessage.image = image
            newMessage.sentDate = Date()
            self.send(message: newMessage)
            self.dismiss(animated: true, completion: nil)
         } else{
            print("Something went wrong")
        }
    }
}
