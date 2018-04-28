//
//  imageFile.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 25/04/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import Foundation

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String)
    {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "kyleleeheadiconimage234567.jpg"
        
        guard let data = UIImageJPEGRepresentation(image, 0.7) else { return nil }
        self.data = data
    }
}
