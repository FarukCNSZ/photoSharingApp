//
//  ViewController.swift
//  photoSharingApp
//
//  Created by Faruk CANSIZ on 14.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func signInClicked(_ sender: Any) {
        //eğer email ve şifre boş input edilmediyse performSegue ile feedVC'ye git, eğer boşsa hata mesajı ver, FirebaseAuth'dan çektiğimiz Auth.auth() kodu ile Firebase'den kaıt olunan bilgiler çekilerek giriş yapılmasını sağlıyor; eğer bir hata verirse de aşağıda bulunan açıklamada ki işlem gerçekleşiyor.
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authdataresult, error) in
                    if error != nil {
                    //error?.localizedDescription alınan errora uygun yanıt verilmesini sağlar, normal şartlar altında error'u nil olup olmadığını kontrol ediyoruz "error?.localizedDescription ?? "Tekrar Deneyiniz"" yazmak yerine "error!.localizedDescription" yazabiliriz ama yine de uygulama çökmesin diye manuel bir yanıtta ekledik.
                    self.errorMessage(titleInput: "Error", messageInput: error?.localizedDescription ?? "Try Again")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }   else {
            self.errorMessage(titleInput: "Error", messageInput: "Enter Email ve Password.")
        }
        
    }
    
    
    //Kayıt olma işlemi
    @IBAction func signUpClicked(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authdataresult, error) in
                if error != nil {
                    //error?.localizedDescription alınan errora uygun yanıt verilmesini sağlar, normal şartlar altında error'u nil olup olmadığını kontrol ediyoruz "error?.localizedDescription ?? "Tekrar Deneyiniz"" yazmak yerine "error!.localizedDescription" yazabiliriz ama yine de uygulama çökmesin diye manuel bir yanıtta ekledik.
                    self.errorMessage(titleInput: "Error", messageInput: error?.localizedDescription ?? "Try Again")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }    
        }   else {
            self.errorMessage(titleInput: "Error", messageInput: "Enter Email ve Password.")
        }
        
    }
    
    
    
    //Kullanıcı kayıt olurken inputlardan birini eksik girerse gösterilecek uyarılar için oluşturulan fonksiyon
    func errorMessage(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    

}

