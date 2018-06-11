//
//  Cartotheque.swift
//  Cartotheque
//
//  Created by Tim on 09.06.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit

class Cartotheque: UIView {
    
    private var currentCardIndex = 0
    var animationDuration = 1.25
    var stackOffset: CGFloat = 55.0
    var dataSource: CartothequeDataSource?
    
    
    private (set) var cards: [CardView]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setGestures()
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
            print(card.frame)
        }
    }
    
    private func setGestures() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe(_:)))
        upSwipe.direction = .up
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe(_:)))
        downSwipe.direction = .down
        addGestureRecognizer(upSwipe)
        addGestureRecognizer(downSwipe)
    }
    
    @objc private func respondToSwipe(_ swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.up:
            swipeUp()
        case UISwipeGestureRecognizerDirection.down:
            swipeDown()
        default:
            print("Error: wrong swipe direction")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cards = dataSource?.cards()
        let templateCard = getTemplateCard()
        if cards != nil {
            cards?.append(templateCard)
        }
        setupCards()
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.putCardsAtInitPosition(isUp: nil)
        }, completion: nil)
        animateUpToCenter(index: 0)
    }
    
    func getTemplateCard() -> CardView {
        let emptyCardWithOverlay = CardView(inFrame: frame)
        emptyCardWithOverlay.isTemplate = true
        emptyCardWithOverlay.frame.origin.y = frame.height
        return emptyCardWithOverlay
    }
    
    private func putCardsAtInitPosition(isUp: Bool?) {
        guard let cards = cards else {
            return
        }
        let startIndex = currentCardIndex
        for i in 1 ..< cards.count {
            let constant = isUp != nil ? stackOffset : stackOffset * CGFloat(i - 1)
            if cards[i].isTemplate {
                cards[i].frame.origin.y = frame.height
            } else {
                cards[i].frame.origin.y = (frame.height - cards[0].frame.height) + constant
            }
        }
    }
    
    func swipeUp() {
        print("Hello Up!")
        guard let cards = cards else {
            return
        }
        if currentCardIndex > 0 {
            //TODO: top card out of screen
        }
        let nextIndex = self.currentCardIndex + 1
        animateUpToCenter(index: nextIndex)
        changeCurrentIndex(by: 1)
    }
    
    fileprivate func animateUpToCenter(index: Int) {
        guard let cards = cards, index < cards.count else {
            return
        }
        let theEndPositionOfCentralCard = (frame.height / 2) - (cards[index].frame.height / 6) * 5
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            cards[index].frame.origin.y = theEndPositionOfCentralCard
        })
    }
    
    func swipeDown() {
        guard let cards = cards else {
            return
        }
        animateDownToStack(index: currentCardIndex)
        changeCurrentIndex(by: -1)
    }
    
    fileprivate func animateDownToStack(index: Int) {
        guard let cards = cards, index > 0 else {
            return
        }
        
        let theEndPositionOfCentralCard = frame.height - cards[index].frame.height + (stackOffset * CGFloat(index - 1))
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            cards[index].frame.origin.y = theEndPositionOfCentralCard
        })
    }
    
    private func changeCurrentIndex(by number: Int) {
        guard let cards = cards else {
            return
        }
        if number > 0 {
            currentCardIndex += number
            currentCardIndex = min(currentCardIndex, cards.count - 1)
        }
        if number < 0 {
            currentCardIndex += number
            currentCardIndex = max(currentCardIndex, 0)
        }
    }
    
}

protocol CartothequeDataSource {
    func cards() -> [CardView]
}
