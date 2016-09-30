//
//  WelcomeViewController.swift
//  Cast
//
//  Created by Keith Piong on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class WelcomeViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var fireBaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImage)))
        profileImageView.isUserInteractionEnabled = true
        
        usernameTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(WelcomeViewController.dismissKeyboard)))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FIRDatabase.database().reference().child("users").child(Session.currentUserUid).observeSingleEvent(of: .value, with: { snapshot in
            
            // get user information as Dictionary
            let userDictionary: [String:AnyObject]? = snapshot.value as? [String:AnyObject]
            
            // get profilePicture
            if let profileImage = userDictionary?["profilePicture"] as? String {
                
                let url = NSURL(string:profileImage)
                URLSession.shared.dataTask(with: url! as URL, completionHandler: {
                    (data, response, error) in
                    
                    if error != nil{
                        print(error)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async(execute: {
                        self.profileImageView.image = image
                    })
                    
                }).resume()
            }
           
            
        })
        
    }


    func selectProfileImage () {
        let picker = UIImagePickerController ()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }


    @IBAction func submitButton(_ sender: AnyObject) {
        
        if let username = usernameTextField.text {
            //checks if username exists
            fireBaseRef.ref.child("users").queryOrdered(byChild: "username").queryEqual(toValue: usernameTextField.text).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if  !snapshot.exists() {
                    let userDictionary = ["username": username]
                    self.fireBaseRef.child("users").child(Session.currentUserUid).updateChildValues(userDictionary) //
                    self.performSegue(withIdentifier: "welcomeSegue2", sender: self)
                
                } else {
                    
                    let controller = UIAlertController(title: "Username already in use!", message: "please choose another username", preferredStyle: .alert)
                    let dismissButton = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                    controller.addAction(dismissButton)
                    
                    self.present(controller, animated: true, completion: nil)

                
                }
            }, withCancel: nil)
        
    }
    }
    
    func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
    }

}

extension WelcomeViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            // set the profile image
            profileImageView.image = selectedImage
            let storageRef = FIRStorage.storage().reference()
            let userRef = storageRef.child("profilePicture").child(Session.currentUserUid)
            
            if let uploadData = UIImageJPEGRepresentation(selectedImage, 0.7) {
                
                userRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil{
                        print(error)
                        return
                    } else {
                        if let imageURL = metadata?.downloadURLs?.first {
                            FIRDatabase.database().reference().child("users").child(Session.currentUserUid).child("profilePicture").setValue(imageURL.absoluteString)
                            
                        }
                    }
                })
                
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    
}
