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
    var animationDelayBetweenCardsInStack = 0.15
    
    var stackOffset: CGFloat = 55.0
    var dataSource: CartothequeDataSource?
    
    lazy private var centralCardYPosition: CGFloat = {
        return (frame.height / 2) - (cards![0].frame.height / 6) * 5
    }()
    
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
            self.putCardsAtInitPosition()
        }, completion: nil)
        animateUpToCenter(index: 0)
    }
    
    func getTemplateCard() -> CardView {
        let emptyCardWithOverlay = CardView(inFrame: frame)
        emptyCardWithOverlay.isTemplate = true
        emptyCardWithOverlay.frame.origin.y = frame.height
        return emptyCardWithOverlay
    }
    
    private func putCardsAtInitPosition() {
        guard let cards = cards else {
            return
        }
        let startIndex = currentCardIndex
        for i in 1 ..< cards.count - 1 {
            let constant = stackOffset * CGFloat(i - 1)
            if cards[i].isTemplate {
                cards[i].frame.origin.y = frame.height
            } else {
                cards[i].frame.origin.y = (frame.height - cards[0].frame.height) + constant
            }
        }
    }
    
    
    private func repositionStack(isUp: Bool) {
        guard let cards = cards, currentCardIndex < cards.count - 2 else {
            return
        }
        let delta = isUp ? -1 * stackOffset : stackOffset
        let startIndex = isUp ? self.currentCardIndex + 2 : self.currentCardIndex + 1
        var delay: Double = 0.0
        for i in startIndex ..< cards.count - 1 {
            UIView.animate(withDuration: animationDuration, delay: delay, options: [.curveEaseInOut], animations: {
                cards[i].frame.origin.y += delta
            })
            delay += animationDelayBetweenCardsInStack
        }
    }
    
    func swipeUp() {
        guard let cards = cards, currentCardIndex >= 0, currentCardIndex < cards.count - 1 else {
            return
        }
        animateUpToTop(index: currentCardIndex)
        let nextIndex = currentCardIndex + 1
        animateUpToCenter(index: nextIndex)
        repositionStack(isUp: true)
        changeCurrentIndex(by: 1)
    }
    
    fileprivate func animateUpToTop(index: Int) {
        guard let cards = cards else {
            return
        }
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            cards[index].frame.origin.y = -(cards[index].frame.height / 6) * 5
        })
    }
    
    fileprivate func animateUpToCenter(index: Int) {
        guard let cards = cards, index < cards.count else {
            return
        }
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            cards[index].frame.origin.y = self.centralCardYPosition
            if index == cards.count - 2 {
                cards[cards.count - 1].frame.origin.y = self.frame.height - cards[index].frame.height
            }
            if index == cards.count - 1 {
                for i in 2...cards.count {
                    cards[cards.count - i].frame.origin.y = -cards[cards.count - 2].frame.height
                }
                cards[cards.count - 1].frame.origin.y = 0
            }
        })
        
    }
    
    func swipeDown() {
        guard let cards = cards, currentCardIndex >= 1, currentCardIndex < cards.count else {
            return
        }
        let prevIndex = currentCardIndex - 1
        animateDownToCenter(index: prevIndex)
        animateDownToStack(index: currentCardIndex)
        repositionStack(isUp: false)
        changeCurrentIndex(by: -1)
    }
    
    fileprivate func animateDownToCenter(index: Int) {
        guard let cards = cards, index >= 0 else {
            return
        }
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            cards[index].frame.origin.y = self.centralCardYPosition
        })
    }
    
    fileprivate func animateDownToStack(index: Int) {
        guard let cards = cards, index > 0 else {
            return
        }
        if index == cards.count - 1 {
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                cards[index].frame.origin.y = self.frame.origin.y
            })
        } else {
            let theEndPositionOfCentralCard = index >= cards.count - 1 ? cards[index + 1].frame.origin.y : frame.height - cards[index].frame.height
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                cards[index].frame.origin.y = theEndPositionOfCentralCard
            })
        }
        
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
