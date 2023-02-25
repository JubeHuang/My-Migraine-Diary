//
//  AllLogInViewController.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/22.
//

import UIKit
import FacebookLogin
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class AllLogInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func LogIn(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            fbLogin()
        case 1:
            googleLogIn()
        case 2:
            break
        default:
            break
        }
    }
    
    @IBSegueAction func signUpFlow(_ coder: NSCoder) -> SignInViewController? {
        let controller = SignInViewController(coder: coder)
        controller?.greetingStr = .welcomeNewFriend
        return controller
    }
    
    @IBSegueAction func signInFlow(_ coder: NSCoder) -> SignInViewController? {
        let controller = SignInViewController(coder: coder)
        controller?.greetingStr = .welcomeBack
        return controller
    }
    
    func fbLogin() {
        let manager = LoginManager()
        manager.logIn(permissions: ["public_profile","email"], from: self, handler: { action, previewViewController in
            if action != nil {
                if let cancel = action?.isCancelled {
                    let tokenInfo = action?.token
//                    let uid = tokenInfo?.userID
//                    let tokenString = tokenInfo?.tokenString
                    if !cancel {
                        print("登入成功")
                        if let accessToken = AccessToken.current {
                            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                            Auth.auth().signIn(with: credential) { [weak self] result, error in
                                guard let self = self else { return }
                                guard error == nil else {
                                    print(error?.localizedDescription)
                                    return
                                }
                                print("firebase login ok")
                            }
                        }
                    }
                }
            } else {
                print("未知的錯誤")
            }
        })
        
        //        let manager = LoginManager()
        //        var successResult = LoginResult.cancelled
        //        manager.logIn(permissions: ["public_profile","email"], from: self) { result, error in
        //            if case let LoginResult.success(granted: _, declined: _, token: token) = successResult {
        //                print("fb login ok")
        //                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        //                Auth.auth().signIn(with: credential) { [weak self] result, error in
        //                    guard let self = self else { return }
        //                    guard error == nil else {
        //                        print(error?.localizedDescription)
        //                        return
        //                    }
        //                    print("login ok")
        //                }
        //
        //            } else {
        //                print("login fail")
        //            }
        //        }
    }
    
    func googleLogIn(){
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            guard let authentication = result?.user,
                  let idToken = authentication.idToken else {
                return
            }
            print("GoogleLogin OK")
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: authentication.accessToken.tokenString)
            Auth.auth().signIn(with: credential){ [weak self] result, error in
                guard let self = self else { return }
                guard error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                print("login ok")
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
