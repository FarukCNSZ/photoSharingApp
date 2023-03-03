//
//  Post.swift
//  photoSharingApp
//
//  Created by Faruk CANSIZ on 30.01.2023.
//

import Foundation

class Post {
    
    //(23) post sınıfı açarak değişkenleri farklı dizilerde tutmak yerine tek bir kodla işi tamamlayabiliriz.
    
    var comment : String
    var email : String
    var imageUrl : String
    
    init(comment: String, email: String, imageUrl: String) {
        self.comment = comment
        self.email = email
        self.imageUrl = imageUrl
    }
    
}


