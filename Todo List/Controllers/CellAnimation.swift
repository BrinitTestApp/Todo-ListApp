//
//  CellAnimation.swift
//  Todo List
//
//  Created by Brinit on 23/08/25.
//

import UIKit

class CellAnimation{
    
    
    
    private static let transformFlip = { (layer: CALayer) -> CATransform3D in
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0.0, layer.bounds.size.height/2.0, 0.0)
        transform = CATransform3DRotate(transform, CGFloat(Double.pi)/2.0, 1.0, 0.0, 0.0)
        transform = CATransform3DTranslate(transform, 0.0, layer.bounds.size.height/2.0, 0.0)
        return transform
    }
    
    public class func animate(_ cell: UITableViewCell, withDuration duration: TimeInterval) {
        let view = cell.contentView
        view.layer.opacity = 0.8
        view.layer.transform = CellAnimation.transformFlip(cell.layer)
        UIView.animate(withDuration: duration, animations: {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
        })
        
    }
    
}

