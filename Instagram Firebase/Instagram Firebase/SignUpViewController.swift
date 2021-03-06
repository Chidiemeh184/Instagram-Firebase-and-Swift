//
//  SignUpViewController.swift
//  Instagram Firebase
//
//  Created by Chidi Emeh on 6/6/17.
//  Copyright © 2017 Chidi Emeh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    var selectedImage : UIImage?
    
    @IBOutlet weak var signUpButton: UIButton!

    //First Loading Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.backgroundColor = .clear
        usernameTextField.tintColor = .white
        usernameTextField.textColor = .white
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerUsername = CALayer()
        bottomLayerUsername.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerUsername.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        usernameTextField.layer.addSublayer(bottomLayerUsername)

        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.tintColor = .white
        passwordTextField.textColor = .white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)

        profileImage.layer.cornerRadius = 10
        profileImage.clipsToBounds = true
        
        
       let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        signUpButton.isEnabled = false
        handleTextField()
    
    }

    func handleTextField(){
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: .editingChanged)
    }

    
    func textFieldDidChange(){
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                signUpButton.setTitleColor(UIColor.lightText, for: .normal)
                signUpButton.isEnabled = false
                return
            }
            signUpButton.setTitleColor(UIColor.white, for: .normal)
            signUpButton.isEnabled = true
        }
    
    
    //Enables user to select image from photo library
    func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] (user: User?, error : Error?) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            let uid = user?.uid
            let storageRef = Storage.storage().reference(forURL: "gs://instagram-firebase-e903f.appspot.com/").child("profile_image").child(uid!)
            
            
            if let profileImg = self?.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1){
                storageRef.putData(imageData, metadata: nil, completion: { [weak self] (metadata : StorageMetadata? , error : Error?) in
                    if error != nil {
                        return
                    }
                    let profileImageUrl = metadata?.downloadURL()?.absoluteString
                    
                    self?.setUserInfomation(profileImageUrl: profileImageUrl!, username: (self?.usernameTextField.text!)!, email: (self?.emailTextField.text!)!, uid: uid!)
                    
                    
                })
            }
            
        }
    }
    
    
    
    func setUserInfomation(profileImageUrl: String, username: String, email: String, uid: String){
        let ref = Database.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username" : username, "email": email, "profileImageUrl": profileImageUrl])
        self.performSegue(withIdentifier: "signUpToTabbarVC", sender: nil)
    
    }
    

}//End SignUpVc

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            profileImage.image = image
        }

        dismiss(animated: true, completion: nil)
    }
    
}

















