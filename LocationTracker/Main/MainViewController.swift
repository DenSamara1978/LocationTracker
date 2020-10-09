//
//  MainViewController.swift
//  LocationTracker
//
//  Created by Denis Vlaskin on 03.10.2020.
//  Copyright © 2020 Denis Vlaskin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var router: MainRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showMap(_ sender: Any) {
        router.toMap()
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        router.toLaunch()
    }
    
}
