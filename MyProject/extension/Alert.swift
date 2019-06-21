//
//  Alert.swift
//  VirtualTourist
//
//  Created by Hailah on 16/06/2019.
//  Copyright © 2019 Hailah. All rights reserved.
//

import UIKit

extension UIViewController  {
    
     func alertMessage(title : String , message : String ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true ,completion: nil)
    }
    
    
    func alertMessage(message : String!){
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
    NSLog("The \"OK\" alert occured.")
    }))
    self.present(alert, animated: true, completion: nil)
    }
}
