//
//  ImagesExtension.swift
//  VirtualTourist
//
//  Created by Hailah on 08/06/2019.
//  Copyright © 2019 Hailah. All rights reserved.
//

import UIKit

extension Images {
    
    func set(image : UIImage){
        
        self.imageData = image.pngData()
    }
    
    func getImage()-> UIImage? {
        return (imageData == nil) ? nil : UIImage(data: imageData!)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
         creationDate = Date()
    }
    
    
}
