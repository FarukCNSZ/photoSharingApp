//
//  SettingsViewController.swift
//  photoSharingApp
//
//  Created by Faruk CANSIZ on 14.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutClicked(_ sender: Any) {
        
        //signOut() ile Firebase'e kullanıcının uygulamadan çıkış yaptığını, uygulamayı tekrar açarsa giriş yapması gerektiğini söylüyoruz, throws olduğu için de "do try cath" içerisinde yazdık.
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("Error")
        }
        
        
        
    }
    
    
    

}
