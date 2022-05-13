import UIKit
import Kingfisher
import FirebaseDatabase

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var imgMainPlace: UIImageView!
    @IBOutlet weak var txtPlaceDetails: UITextView!
    @IBOutlet weak var collectionViewMoreImages: UICollectionView!
    @IBOutlet weak var imgNavBar: UIImageView!
    @IBOutlet weak var btnLikes: UIButton!
    @IBOutlet weak var lblLikesCount: UILabel!
    
    
    var place: Place!
    var likes: Int = 0
    var ref: DatabaseReference!
    var isLiked : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.configureCollectionView()
        self.configureView()
        self.ref = Database.database().reference()
        self.getLikes()
    }
    
    func configureCollectionView(){
        
        /*Mark: Configuring collectionview.*/
        
        self.collectionViewMoreImages.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        self.collectionViewMoreImages.delegate = self
        self.collectionViewMoreImages.dataSource = self
        if let flowLayout = self.collectionViewMoreImages?.collectionViewLayout as? UICollectionViewFlowLayout {
            //flowLayout.estimatedItemSize = CGSize(width: 100, height: 100)
            flowLayout.scrollDirection = .horizontal
        }
    }
    
    func getLikes(){
        
        /*Mark: Calling place likes from firebase database. */
        
        self.ref.child("places").child(self.place.PlaceId).child("Likes").observe(.value) { (snapshot) in
            let value = snapshot.value as? Int
            print(value)
            self.lblLikesCount.text = String(value!)
            self.likes = value!
        }
    }

    func configureView(){
        
        /*Mark: Configuring screen with all styling. */
        
        self.imgNavBar.layer.cornerRadius = 20
        self.imgMainPlace.layer.cornerRadius = 24
        
        self.lblPlaceName.text = self.place.PlaceName
        self.txtPlaceDetails.text = self.place.PlaceDetails
        let url = URL(string: self.place.placeMainImage)
        self.imgMainPlace.kf.setImage(with: url)
        self.lblLikesCount.text = String(self.place.likes)
        self.likes = self.place.likes
        self.txtPlaceDetails.isEditable = false
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
    }
    
    @IBAction func likePressed(_ sender: Any) {
        
        /*Mark: Like button action, saving likes in firebase database. */
        
        if !self.isLiked {
            self.likes += 1
            self.ref.child("places").child(self.place.PlaceId).updateChildValues(["Likes": self.likes])
            self.lblLikesCount.text = String(self.likes)
            self.isLiked = true
            self.btnLikes.isEnabled = false
        }
        
    }
    
    @IBAction func btnReviewsPressed(_ sender: Any) {
        
        /*Mark: Reviews button action.*/
        
        let vc = ReviewsViewController(nibName: "ReviewsViewController", bundle: nil)
        vc.place = self.place
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        
        /*Mark: Signout button action. */
        
        let signOut = Common.shared.signOut()
        if signOut {
            for item in self.navigationController!.viewControllers{
                if item.isKind(of: SignInViewController.self) {
                    self.navigationController?.popToViewController(item, animated: true)
                    return
                }
            }
            let vc = SignInViewController(nibName: "SignInViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

/*Mark: Collectionview delegate function. */
extension PlaceDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.place.MoreImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
        
        let url = URL(string: self.place.MoreImages[indexPath.row])
        cell?.imgPlace.kf.setImage(with: url)
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2.5)
        return CGSize(width: 120, height: 120)
    }
    
    
}
