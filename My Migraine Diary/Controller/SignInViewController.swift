//
//  LohInViewController.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/2/22.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var dbCheckPassword: UITextField!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var greetingStr: Greeting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func SignIn(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextfield.text else { return }
        switch greetingStr {
        case .welcomeBack:
            if email.contains("@"), password.count >= 6 {
                signIn(email: email, password: password)
                dismiss(animated: true)
            } else {
                alert(title: "有地方填寫不正確呦！", message: "請重新確認一下帳號密碼")
            }
        case .welcomeNewFriend:
            guard let dbPassword = dbCheckPassword.text else { return }
            if email.contains("@"), password.count >= 6, dbPassword == password {
                createUser(email: email, pass: password)
                alert(title: "註冊成功", message: "歡迎加入～")
            } else {
                alert(title: "有地方填寫不正確呦！", message: "請重新確認一下帳號密碼")
            }
        case .none:
            break
        }
    }
    
    func signIn(email:String, password:String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            print("success")
        }
    }
    
    func createUser(email: String, pass: String){
        Auth.auth().createUser(withEmail: email, password: pass) { result, error in
            guard let user = result?.user,
                  error == nil else {
                print(error?.localizedDescription)
                return
            }
            print(user.email, user.uid)
        }
    }
    
    func updateUI(){
        guard let greetingStr else { return }
        greetingLabel.text = "\(greetingStr.rawValue)"
        if greetingStr == .welcomeBack {
            dbCheckPassword.isHidden = true
            caption.isHidden = true
            signInBtn.setTitle("登入", for: .normal)
        } else {
            dbCheckPassword.isHidden = false
            caption.isHidden = false
            signInBtn.setTitle("註冊", for: .normal)
        }
    }
    
    func alert(title: String, message: String){
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertC.addAction(action)
        present(alertC, animated: true)
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
