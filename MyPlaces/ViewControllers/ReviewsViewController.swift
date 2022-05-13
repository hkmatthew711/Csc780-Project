import UIKit
import FirebaseDatabase

class ReviewsViewController: UIViewController {

    @IBOutlet weak var tblViewReviews: UITableView!
    @IBOutlet weak var imgNavBar: UIImageView!
    @IBOutlet weak var btnWriteAReview: UIButton!
    
    var reviews: [String] = []
    var place : Place!
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.ref = Database.database().reference()
        self.getReviews()
        self.configureView()
    }
    
    func configureView(){
        
        /*Mark: configuring screen. */
        
        self.imgNavBar.layer.cornerRadius = 20
        self.btnWriteAReview.roundCorner()
        
        /*Mark: configuring tableview reviews*/
        
        self.tblViewReviews.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        self.tblViewReviews.delegate = self
        self.tblViewReviews.dataSource = self
        
    }
    
    func getReviews(){
        
        /*Mark: Calling reviews from firebase database. */
        
        Common.shared.showLoader(self)
        self.ref.child("places").child(self.place.PlaceId).child("Reviews").observe(.value) { (snapshot) in
            Common.shared.dismissLoader()
            if let value = snapshot.value as? [String] {
                print(value)
                self.reviews = value
                self.tblViewReviews.reloadData()
            }
            
        }
    }
    
    func saveAReview(){
        
        /*Mark: Save reviews to firebase database. */
        
        self.ref.child("places").child(self.place.PlaceId).updateChildValues(["Reviews": self.reviews])
        self.getReviews()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func writeAReviewPressed(_ sender: Any) {
        
        /*Mark: Write a review button action */
        
        self.alertControllerWithText()
    }
    
    func alertControllerWithText(){
        
        /*Mark: Review alert calling with text field. */
        
        let alert = UIAlertController(title: "Review", message: "Write your review.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.reviews.append((textField?.text)!)
            self.saveAReview()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

/*Mark: Tableview delegate functions. */
extension ReviewsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell
        
        let review = self.reviews[indexPath.row]
        cell?.txtViewReview.text = review
        cell?.txtViewReview.isEditable = false
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 127.0
    }
    
}
