//
//  UploadViewController.swift
//  photoSharingApp
//
//  Created by Faruk CANSIZ on 14.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Kullanıcı imageView ile etkileşime geçebilir. (1)
        imageView.isUserInteractionEnabled = true
        //Jest algılayıcıyı tanımlıyoruz (2)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        //imageView'a gestureRecognizer'ı tanımlıyoruz (4)
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    //gestureRecognizer'da kullanılacak Objective-C fonksiyonu (3)
    @objc func chooseImage() {
        
        //UIImagepickerController Resim çekmek, film kaydetmek ve kullanıcının ortam kitaplığından öğe seçmek için sistem arabirimlerini yöneten bir görünüm denetleyicisi. Sörsel seçe tıklanınca aşağıdan yukarı animasyonlu bir şekilde photoLibrary gelsin (5)
        //UIImagePickerController'ı kullandığımız için class'a UIImagePickerControllerDelegate, UINavigationControllerDelegate ekledik (6)
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    //Gorsel sectikten sonra ne olacak? (7)
    //imagePickerController'ı yazdık ve bize bir any tanımlı sözlük atadı imageView.image'ı originalImage olarak atadık any dönmesin diye as? UIImage olarak tanımladık.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        //photoLibrary geldi fotoğrafı seçtik peki ya sonra? sonrasında bu seçtiğimiz fotoğrafı imageView'a atadık ve animasyonlu bir şekilde photoLibrary'i dismiss ettik
        //Info'ya gidip librarye gitmek için kullanıcıdan izin almamız gerekiyor (8)
    }
    
    
    @IBAction func clickedUploadButton(_ sender: Any) {
        
        //Firebase stroge'la contact kuruyoruz (9)
        let stroge = Storage.storage()
        //Stroge'a referans yaptırıyor yani stroge'a ulaşıyoruz
        let strogeReference = stroge.reference()
        
        //Referance ile ulaştığımız stroge'da Media isminde klasör oluşturduk.
        let mediaFolder = strogeReference.child("media")
        
        //Media klasörü içine image'ları data olarak eklememiz gerekiyor ama bunu imageView olarak yapamıyoruz bu yüzden byte dizisi gibi veriye çevirmemiz gerekiyor. (10)
        //Sıkıştırma kalitesi 0-1 arasındadır.
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            //UUID ile her upload edilen fotoğrafa kendine ait isim veriyoruz. (13)
            let uuid = UUID().uuidString
            
            
            //Media içerisine datayı ne olarak ekleyeceğimizi hazırladık.
            // Ama her fotoğraf upload edildiğinde Media.jpg ismiyle geliyor ve yeni fotoğraf geldiğinde eskisi siliniyor, bu sorunu UUID ile çözüyoruz. (12)
            
            //let imageReference = mediaFolder.child("Media.jpg")
            
            // Ve Media'yı UUID olarak değiştiriyoruz (14)
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            
            //Datayı imageReferance olarak belirlediğimiz yere koyuyoruz.
            imageReference.putData(data, metadata: nil) { (stogemetadata, error) in
                if error != nil {
                    self.errorMessage(title: "Error", message: error?.localizedDescription ?? "Try Again.")
                } else { //Upload edilen fotoğrafı bir başkası tarafından download edilmesi için:
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            //URL'yi string'e dönüştürüyor, bu url ile görseli bulup indirebilirsin. (11)
                            let imageURL = url?.absoluteString
                           
                            if let imageURL = imageURL {
                                
                                let firestoreDatabase = Firestore.firestore()
                                
                                let firestorePost = ["imageurl" : imageURL, "comment" : self.commentTextField.text!, "email" : Auth.auth().currentUser!.email, "date" : FieldValue.serverTimestamp()] as [String : Any]
                                
                                firestoreDatabase.collection("post").addDocument(data: firestorePost) { (error) in
                                    if error != nil {
                                        self.errorMessage(title: "Error", message: error?.localizedDescription ?? "Try Again!")
                                    } else {
                                        
                                        //Gorsel yükledikten sonra feed'e dön ve Upload bir sonraki yükleme için hazır hale gelsin (15)
                                        self.imageView.image = UIImage(named: "gorselSec")
                                        self.commentTextField.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                        
                                        
                                    }
                                }
                                
                            }
                            
                            
                        }
                    }
                }
            }
        }
        
    }
    
    //Error aldığımızda hata mesajını göstericek fonksiyon
    func errorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let OkButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(OkButton)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    

}
