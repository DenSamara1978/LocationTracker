//
//  BaseRouter.swift
//  LocationTracker
//
//  Created by Denis Vlaskin on 03.10.2020.
//  Copyright © 2020 Denis Vlaskin. All rights reserved.
//

import UIKit

class BaseRouter: NSObject {
    @IBOutlet weak var controller: UIViewController!
    
    func show(_ controller: UIViewController) {
        self.controller.show(controller, sender: nil)
    }
    
    func present(_ controller: UIViewController) {
        self.controller.present(controller, animated: true)
    }
    
    func setAsRoot(_ controller: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController = controller
    }

}
