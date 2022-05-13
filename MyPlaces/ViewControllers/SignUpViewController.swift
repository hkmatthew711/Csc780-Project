import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var imgNavBar: UIImageView!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    var ref: DatabaseReference!
    var isFirstTap: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.configureView()
        self.ref = Database.database().reference()
    }
    
//    override func viewDidLayoutSubviews() {
//        self.configureView()
//    }
    override func viewWillLayoutSubviews() {
        self.imgIcon.roundCorner()
    }

    
    func configureView(){
        
        self.imgIcon.roundCorner()
        
        self.imgNavBar.layer.cornerRadius = 20
        self.viewUserName.layer.borderWidth = 2.0
        self.viewUserName.layer.borderColor = UIColor.gray.cgColor
        self.viewUserName.roundCorner()
        
        self.viewEmail.layer.borderWidth = 2.0
        self.viewEmail.layer.borderColor = UIColor.gray.cgColor
        self.viewEmail.roundCorner()
        
        self.viewPassword.layer.borderWidth = 2.0
        self.viewPassword.layer.borderColor = UIColor.gray.cgColor
        self.viewPassword.roundCorner()
        
        self.btnSignUp.roundCorner()
        self.btnSignUp.layer.shadowColor = UIColor.black.cgColor
        self.btnSignUp.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.btnSignUp.layer.shadowRadius = 5
        self.btnSignUp.layer.shadowOpacity = 1.0
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        if self.checkForValidations() {
            Common.shared.showLoader(self)
            Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { (authUser, error) in
                Common.shared.dismissLoader()
                if error != nil {
                    Common.shared.showAlert(withTitle: "Error", andMessage: error!.localizedDescription, andVc: self)
                    return
                } else {
                    self.ref.child("users").child(authUser!.user.uid).setValue(["UserId": authUser!.user.uid, "UserName": self.txtUserName.text!, "UserEmail": self.txtEmail.text!]) { (error, ref) in
                        if error != nil {
                            Common.shared.showAlert(withTitle: "Error", andMessage: error!.localizedDescription, andVc: self)
                            return
                        } else {
                            self.callUsers(authUser!.user.uid)
                            let vc = HomeViewController(nibName: "HomeViewController", bundle: nil)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        } else {
            Common.shared.showAlert(withTitle: "Error", andMessage: "Please enter the required fields", andVc: self)
        }
        
    }
    
    func callUsers(_ userId : String) {
        ref.child("users").queryOrdered(byChild: "UserId").queryEqual(toValue: userId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? [String: Any]
            guard let user = value else {
                return
            }
            for each in user {
                /*Mark: Parsing Data*/
                
                let dict = each.value as? NSMutableDictionary
                
                let userId = dict?.value(forKey: "UserId") as? String
                let userName = dict?.value(forKey: "UserName") as? String
                let userEmail = dict?.value(forKey: "UserEmail") as? String
                
                let user = AppUser(UserId: userId, UserName: userName, UserEmail: userEmail)
                Common.shared.appCurrentUser = user
            }
        }) { (error) in
            //handle error case
            Common.shared.showAlert(withTitle: "Error", andMessage: "Something Went Wrong", andVc: self)
            return
        }
    }
    
    @IBAction func btnBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true
        )
    }
    
    @IBAction func showPasswordPressed(_ sender: Any) {
        if !self.isFirstTap {
            let image = UIImage(named: "eyeUnchecked")
            self.btnShowPassword.setImage(image, for: .normal)
            self.txtPassword.isSecureTextEntry = false
            self.isFirstTap = true
        } else {
            let image = UIImage(named: "eyechecked")
            self.btnShowPassword.setImage(image, for: .normal)
            self.txtPassword.isSecureTextEntry = true
            self.isFirstTap = false
        }
    }
    
    func checkForValidations() -> Bool {
        if self.txtEmail.text == "" || self.txtUserName.text == "" || self.txtPassword.text == "" {
            return false
        } else {
            return true
        }
    }
    
}
