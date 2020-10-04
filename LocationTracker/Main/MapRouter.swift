//
//  MapRouter.swift
//  LocationTracker
//
//  Created by Denis Vlaskin on 03.10.2020.
//  Copyright © 2020 Denis Vlaskin. All rights reserved.
//

import UIKit

final class MapRouter: BaseRouter {
    func toLaunch() {
        let controller = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(LoginViewController.self)
        setAsRoot(UINavigationController(rootViewController: controller))
    }
}
