//
//  Cartotheque.swift
//  Cartotheque
//
//  Created by Tim on 09.06.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit

class Cartotheque: UIView {
    
    var cards: [CardView]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCards()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCards() {
        guard let cards = cards else {
            return
        }
        for card in cards {
            self.addSubview(card)
        }
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe(_:)))
        upSwipe.direction = .up
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe(_:)))
        downSwipe.direction = .down
        addGestureRecognizer(upSwipe)
        addGestureRecognizer(downSwipe)
        
    }
    
    @objc fileprivate func respondToSwipe(_ swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.up:
            print("1")
        case UISwipeGestureRecognizerDirection.down:
            print("2")
        default:
            print("Error: wrong swipe direction")
        }
    }
    
}
