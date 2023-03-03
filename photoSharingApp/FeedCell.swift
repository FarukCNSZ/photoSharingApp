//
//  FeedCell.swift
//  photoSharingApp
//
//  Created by Faruk CANSIZ on 26.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class FeedCell: UITableViewCell {
    
    //(16) Feed sayfasına önce bir tableView daha sonra bir cell ekledik bu cell içerisine mail yorum ve fotoğraf kısımları koyduk, upload edilen bilgiler bu feed sayfasında cell yardımıyla görünücek. FeedCell adında bir cocopods'u UItableViewCell ile açtık, main de ki cell'i FeedCell'e atadık, ve Cell'e bir identifier yazdık "Cell". Daha sonra cell de ki text ve image ı feedCell e init ettik.


    @IBOutlet weak var emailText: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    
    @IBOutlet weak var commentText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
