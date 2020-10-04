//
//  LoginRouter.swift
//  LocationTracker
//
//  Created by Denis Vlaskin on 03.10.2020.
//  Copyright © 2020 Denis Vlaskin. All rights reserved.
//

import UIKit

final class LoginRouter: BaseRouter {
    func toMain() {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MainViewController.self)
        
        setAsRoot(controller)
    }

}
