import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var imgPlace: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgPlace.roundCorner()
    }

    
}
