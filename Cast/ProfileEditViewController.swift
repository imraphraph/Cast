//
//  ProfileEditViewController.swift
//  Cast
//
//  Created by Raphael Lim on 6/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    let profileSections : [String] = ["username", "gender", "title", "bio", "portfolio", "password reset"]
    let profileImages: [UIImage] = [UIImage(named: "users")!, UIImage(named:"gender")!, UIImage(named: "crown2")!, UIImage(named:"informationbutton")!, UIImage(named:"globe")!, UIImage(named:"mail")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        

        retrieveProfileImage()
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImage)))
        profileImageView.isUserInteractionEnabled = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func selectProfileImage () {
        let picker = UIImagePickerController ()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
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



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! profileEditCell
        let categories = self.profileSections[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = categories
        cell.cellImageView.image = profileImages[indexPath.row]
        return cell
    }
    
    
    func retrieveProfileImage (){
        
        DataService.userRef.child(Session.currentUserUid).child("profilePicture").observe(.value, with: {(snapshot) in
            
            let profileImageLink = snapshot.value as? String
            let profileImageUrl = NSURL(string: profileImageLink!)
            URLSession.shared.dataTask(with: profileImageUrl as! URL, completionHandler: {
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
        })
    }
    

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }

}
