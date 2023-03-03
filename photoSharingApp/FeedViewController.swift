//
//  FeedViewController.swift
//  photoSharingApp
//
//  Created by Faruk CANSIZ on 14.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import SDWebImage
//(21) gorseli firebaseden çekebilmek için sdwebimage kütüphanesini import ettik, bu kütüphane firebase de url ile firebaseden download etmemize yarıyor

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //(16) Feed sayfasına önce bir tableView daha sonra bir cell ekledik bu cell içerisine mail yorum ve fotoğraf kısımları koyduk, upload edilen bilgiler bu feed sayfasında cell yardımıyla görünücek. FeedCell adında bir cocopods'u UItableViewCell ile açtık, main de ki cell'i FeedCell'e atadık, ve Cell'e bir identifier yazdık "Cell". Daha sonra cell de ki text ve image ı feedCell e init ettik.
    //(17) FeedViewController'da main kısmında tableView olduğu için tableView'a uygun class ları ekledik. ovveride func içinde self döndürülür.

    @IBOutlet weak var tableView: UITableView!
    
    //(23) post sınıfı açarak değişkenleri farklı dizilerde tutmak yerine tek bir kodla işi tamamlayabiliriz. Oluşturduğumuz postu burası için oluşturduk.
    
    var postArray = [Post]()
    
    /*
    //(19)
    var emailDizisi = [String]()
    var yorumDizisi = [String]()
    var gorselDizisi = [String]()
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getFirbaseData()
        
        
    }
    
    //(18) Verileri firabase den çekmek için fonksiyon
    func getFirbaseData() {
        
        //(22)order by ekleyerek akışta tarihe görse sıralama yaptık.
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Post").order(by: "date", descending: true).addSnapshotListener { ( snapshot, error ) in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                         
                    /*
                    //(21) sdwebimage dan sonraki değişiklikler
                    self.emailDizisi.removeAll(keepingCapacity: false)
                    self.yorumDizisi.removeAll(keepingCapacity: false)
                    self.gorselDizisi.removeAll(keepingCapacity: false)
                     */
                    
                    //(23) post sınıfı açarak değişkenleri farklı dizilerde tutmak yerine tek bir kodla işi tamamlayabiliriz.
                    self.postArray.removeAll(keepingCapacity: false)
  
                    
                    for document in snapshot!.documents {
                        
                        
                        //(23) post sınıfı açarak değişkenleri farklı dizilerde tutmak yerine tek bir kodla işi tamamlayabiliriz.
                        if let imageUrl = document.get("imageurl") as? String {
                            //self.gorselDizisi.append(gorselUrl)
                            
                            if let comment = document.get("comment") as? String {
                                //self.yorumDizisi.append(yorum)
                                
                                if let email = document.get("email") as? String {
                                    //self.emailDizisi.append(email)
                                    
                                    let post = Post(comment: comment, email: email, imageUrl: imageUrl)
                                    self.postArray.append(post)
                                    
                                }
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }

    //(20) değişiklikler
    //Klasik tableView fonksiyonu
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    //(20) değişiklikler
    //(21) sdwebimage dan sonraki değişiklikler
    //(23) post sınıfı açarak değişkenleri farklı dizilerde tutmak yerine tek bir kodla işi tamamlayabiliriz.
    //TableViewdaki Cell içerisinde neler gösterilecek fonksiyonu
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.emailText.text = postArray[indexPath.row].email
        cell.commentText.text = postArray[indexPath.row].email
        cell.postImageView.sd_setImage(with: URL(string: self.postArray[indexPath.row].imageUrl))
        return cell
    }
   

}
