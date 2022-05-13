import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher

class HomeViewController: UIViewController {

    @IBOutlet weak var imgNavBar: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var tblViewPlaces: UITableView!

    var ref: DatabaseReference!
    var appPlaces: [Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.navigationController?.navigationBar.isHidden = true
        configureView()
//        self.uploadPlaceToDatabase()
        self.callPlacesFromDatabase()
    }

    func configureView(){

        /*Mark: Configuring screen with all styling. */

        self.imgNavBar.layer.cornerRadius = 20

        self.tblViewPlaces.register(UINib(nibName: "PlaceCell", bundle: nil), forCellReuseIdentifier: "PlaceCell")
        self.tblViewPlaces.delegate = self
        self.tblViewPlaces.dataSource = self

    }

    func uploadPlaceToDatabase() {
        let place = self.ref.child("places").childByAutoId()
        place.setValue(["PlaceId": place.key ?? "", "PlaceName": "Hunza Valley", "PlaceDetails": "This is located in pakistan", "PlaceMainImage": "url", "Likes": 0, "MoreImages": ["url", "url2", "url3", "url4"], "Reviews": ["This is the best place to visist", "test Reivew for testing", "for testing a review section of the app"]])
    }

    func callPlacesFromDatabase(){

        /*Mark: Calling all places from firebase database. */

        Common.shared.showLoader(self)
        ref.child("places").observeSingleEvent(of: .value, with: { (snapshot) in
            Common.shared.dismissLoader()
            let value = snapshot.value as? [String: Any]
            guard let places = value else {
                return
            }

            for each in places {
                /*Mark: Parsing Data*/

                let dict = each.value as? NSMutableDictionary
                let placeId = dict?.value(forKey: "PlaceId") as? String
                let placeName = dict?.value(forKey: "PlaceName") as? String
                let placeDetails = dict?.value(forKey: "PlaceDetails") as? String
                let placeMainImage = dict?.value(forKey: "PlaceMainImage") as? String
                let moreImages = dict?.value(forKey: "MoreImages") as? [String]
                let likes = dict?.value(forKey: "Likes") as? Int
                let reviews = dict?.value(forKey: "Reviews") as? [String]
                print("test")

                let place = Place(PlaceId: placeId, PlaceName: placeName, PlaceDetails: placeDetails, placeMainImage: placeMainImage, MoreImages: moreImages, likes: likes, Reviews: reviews)
                self.appPlaces.append(place)

            }
            self.tblViewPlaces.reloadData()

        }) { (error) in
            //handle error case
            Common.shared.showAlert(withTitle: "Error", andMessage: "Something Went Wrong", andVc: self)
            return
        }
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


/*Mark: Table View Delegate functions*/

extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appPlaces.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        /*Mark: Table view delegate function for configuring cell. */

        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as? PlaceCell

        let place = self.appPlaces[indexPath.row]
        cell?.lblPlaceName.text = place.PlaceName
        cell?.lblPlaceDetail.text = place.PlaceDetails
        let url = URL(string: place.placeMainImage)
        cell?.imgPlace.kf.setImage(with: url)
//        cell?.imgPlace.roundCorner()

        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 113
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        /*Mark: Tableview delegate function called when user clicked on cell. */

        let vc = PlaceDetailViewController(nibName: "PlaceDetailViewController", bundle: nil) as PlaceDetailViewController
        vc.place = self.appPlaces[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
