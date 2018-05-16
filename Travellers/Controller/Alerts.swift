//
//  Alerts.swift
//  Travellers
//
//  Created by admin on 15.05.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

class Alerts: NSObject {
    
    class func topMostController() -> UIViewController {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController!
    }
    
    class func alert(title: String?, message:String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
        }
        alert.addAction(cancelAction)
        Alerts.topMostController().present(alert, animated: true, completion: nil);
    }
    
}
