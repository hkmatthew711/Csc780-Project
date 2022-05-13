import Foundation
import UIKit

extension UIView {
    func roundCorner(){
        self.layer.cornerRadius = self.bounds.height * 0.5
    }
        
    func showShadow(){
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 1
            self.layer.shadowOffset = .zero
            self.layer.shadowRadius = 6
            
            //self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }
