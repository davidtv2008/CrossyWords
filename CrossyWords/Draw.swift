//
//  Draw.swift
//  CrossyWords
//
//  Created by Blanca Gutierrez on 3/24/19.
//  Copyright © 2019 Appility. All rights reserved.
//

import UIKit

class Draw: UIView {
    
    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
