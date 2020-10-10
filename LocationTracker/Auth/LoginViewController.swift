//
//  LoginViewController.swift
//  LocationTracker
//
//  Created by Denis Vlaskin on 03.10.2020.
//  Copyright © 2020 Denis Vlaskin. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    
    @IBOutlet weak var loginTextEdit: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var router: LoginRouter!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "isLogin")
        configureLoginBindings()
    }

    func configureLoginBindings() {
        _ = Observable.combineLatest(loginTextEdit.rx.text, passwordTextField.rx.text)
                .map { login, password in
                    return !(login ?? "").isEmpty && !(password ?? "").isEmpty
                }
                .bind { [weak loginButton, weak registerButton] inputFilled in
                    loginButton?.isEnabled = inputFilled
                    registerButton?.isEnabled = inputFilled
            }
        }
    
    @IBAction func login(_ sender: Any) {
        guard let user = userByLoginOrPassword() else { return }
        guard let realmUser = loadRealmUser(login: user.login) else {
            showIncorrectLoginPasswordAlert()
            return
        }
        if realmUser.password == user.password {
            UserDefaults.standard.set(true, forKey: "isLogin")
            router.toMain()
        } else {
            showIncorrectLoginPasswordAlert()
        }
    }
    
    @IBAction func register(_ sender: Any) {
        guard let user = userByLoginOrPassword() else { return }
        let realmUser = loadRealmUser(login: user.login)
        if let realmUser = realmUser {
            removeRealmUser(user: realmUser)
        }
        saveRealmUser(user: user)
        UserDefaults.standard.set(true, forKey: "isLogin")
        router.toMain()
    }
    
    private func userByLoginOrPassword () -> User? {
        if let login = loginTextEdit.text, let password = passwordTextField.text {
            if (login.isEmpty || password.isEmpty) {
                showEmptyLoginPasswordAlert()
            } else {
                return User(_login: login, _password: password)
            }
        } else {
            showEmptyLoginPasswordAlert()
        }
        return nil
    }
    
    private func showIncorrectLoginPasswordAlert() {
        let alert = UIAlertController(title: "Внимание!", message: "Неверная пара логин/пароль!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Продолжить", style: .default) { (action) in }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showEmptyLoginPasswordAlert() {
        let alert = UIAlertController(title: "Внимание!", message: "Логин и пароль не должны быть пустыми!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Продолжить", style: .default) { (action) in }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func loadRealmUser(login: String) -> User? {
        do {
            let realm = try Realm()
            let user = realm.object(ofType: User.self, forPrimaryKey: login)
            return user
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func removeRealmUser(user: User) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(user)
            try realm.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func saveRealmUser(user: User) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(user)
            try realm.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
    }
}
