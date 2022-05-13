import Foundation
import UIKit
import JGProgressHUD
import Firebase

class Common {
    
    static let shared = Common()
    private var hud : JGProgressHUD!
    var appCurrentUser: AppUser!
    
    func showAlert(withTitle title : String, andMessage message: String, andVc vc : UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func signOut() -> Bool{
        if Auth.auth().currentUser != nil{
            do {
                try Auth.auth().signOut()
                return true
            } catch let ex {
                print("Error in logout \(ex.localizedDescription)")
                return false
            }
        } else {
            return false
        }
    }
    
    func showLoader(_ vc: UIViewController) {
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: vc.view)
    }
    
    func dismissLoader() {
        hud.dismiss()
    }
    
}


extension UIImage {
    enum PNGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: PNGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

