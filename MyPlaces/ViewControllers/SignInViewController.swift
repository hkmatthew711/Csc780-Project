import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {

    @IBOutlet weak var imgNavBar: UIImageView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnCreateOne: UIButton!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    var ref : DatabaseReference!
    var isFirstTap: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.navigationController?.navigationBar.isHidden = true
        self.configureView()
    }
    
//    override func viewDidLayoutSubviews() {
//        self.configureView()
//    }
    
    override func viewWillLayoutSubviews() {
        self.imgIcon.roundCorner()
    }
    
    func configureView(){
        self.imgNavBar.layer.cornerRadius = 20
        self.viewEmail.layer.borderWidth = 2.0
        self.viewEmail.layer.borderColor = UIColor.gray.cgColor
        self.viewEmail.roundCorner()
        
        self.viewPassword.layer.borderWidth = 2.0
        self.viewPassword.layer.borderColor = UIColor.gray.cgColor
        self.viewPassword.roundCorner()
        
        self.btnLogin.roundCorner()
        self.imgIcon.roundCorner()
        
        self.btnLogin.layer.shadowColor = UIColor.black.cgColor
        self.btnLogin.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.btnLogin.layer.shadowRadius = 5
        self.btnLogin.layer.shadowOpacity = 1.0
        
        self.btnCreateOne.titleLabel?.attributedText = NSAttributedString(string: "Create One", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if self.checkForValidation(){
            Common.shared.showLoader(self)
            Auth.auth().signIn(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { (authResult, error) in
                Common.shared.dismissLoader()
                if error != nil {
                    Common.shared.showAlert(withTitle: "Error", andMessage: error!.localizedDescription, andVc: self)
                    return
                } else {
                    self.callUsers((authResult?.user.uid)!)
                    let vc = HomeViewController(nibName: "HomeViewController", bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            Common.shared.showAlert(withTitle: "Error", andMessage: "Please enter all the required fields", andVc: self)
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
    
    @IBAction func createOnePressed(_ sender: Any) {
        let vc = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnShowPasswordPressed(_ sender: Any) {
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
    
    func checkForValidation() -> Bool{
        if self.txtEmail.text == "" || self.txtPassword.text == "" {
            return false
        } else {
            return true
        }
    }
    
}
