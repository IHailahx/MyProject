//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by Hailah on 08/06/2019.
//  Copyright © 2019 Hailah. All rights reserved.
//
import UIKit


class PhotoCell: UICollectionViewCell {
    
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var indecator: UIActivityIndicatorView!
    
    
    var imageURL : URL!
    var photo : Images!
    
    
    
    
    func update(with image: UIImage?) {
        if let imageToDisplay = image {
            self.indecator.isHidden = true
            cellImage.image = imageToDisplay
        } else {
            self.indecator.startAnimating()
            cellImage.image = nil
        }
        
    }
    
    func setImage(_ newImage : Images){
        if photo != nil {
            return
        }
        photo = newImage
        guard let photo = photo else { return }
        if let image = photo.getImage() {
            update(with: image)
            return
        }
        guard let url = photo.imageURL else {
            return
        }
        
        self.indecator.startAnimating()
        loadImage(with: url, photo: photo)
    }
    
    func loadImage(with url : URL, photo: Images) {
        self.indecator.startAnimating()
        update(with: nil)
        guard let data = try? Data(contentsOf: photo.imageURL!) else { return }
        let image = UIImage(data: data)
        
        update(with: image)
        
        self.photo.set(image: image!)
        try? photo.managedObjectContext?.save()
    }
    
}

