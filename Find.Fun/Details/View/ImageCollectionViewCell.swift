//
//  ImageCollectionViewCell.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 25.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import UIKit

internal class ImageCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    var dimensions: (width: Int, height: Int) = (0, 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: dimensions.width,
                      height: max(dimensions.height, Int(size.height)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        let (imageViewFrame, _) = contentView.bounds.divided(atDistance: CGFloat(dimensions.height),
                                                             from: .minYEdge)
        imageView.frame = imageViewFrame
    }
}
