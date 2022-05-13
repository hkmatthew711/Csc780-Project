import UIKit

class ReviewCell: UITableViewCell {

    
    @IBOutlet weak var viewReview: UIView!
    @IBOutlet weak var txtViewReview: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewReview.showShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
