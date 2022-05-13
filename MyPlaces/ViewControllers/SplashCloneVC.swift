import UIKit
import FirebaseAuth

class SplashCloneVC: UIViewController {

    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.configureTimer()
    }
    
    func configureTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(moveToHome), userInfo: nil, repeats: false)
    }
    
    @objc func moveToHome(){
        if Auth.auth().currentUser == nil {
            let vc = SignInViewController(nibName: "SignInViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = HomeViewController(nibName: "HomeViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
