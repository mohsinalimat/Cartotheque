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
    var animationDelayBetweenCardsInStack = 0.0
    
    var stackOffset: CGFloat = 55.0
    var verticalPadding: CGFloat = 10
    var dataSource: CartothequeDataSource?
    
    lazy private var centralCardYPosition: CGFloat = {
        return (frame.height / 2) - (cards![0].frame.height / 6) * 5
    }()
    
    lazy private var bottomCardYPosition: CGFloat = {
       return (self.frame.height - cards![0].frame.height) - self.verticalPadding
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
            if !card.isTemplate {
                card.frame.origin.y = bottomCardYPosition
            }
            card.center.x = self.center.x
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
        animateCardsToStartPosition()
        animateUpToCenter(index: 0)
    }
    
    func getTemplateCard() -> CardView {
        let emptyCardWithOverlay = CardView(inFrame: frame)
        emptyCardWithOverlay.isTemplate = true
        emptyCardWithOverlay.frame.origin.y = frame.height
        return emptyCardWithOverlay
    }
    
    private func animateCardsToStartPosition() {
        guard let cards = cards else {
            return
        }
        let startIndex = currentCardIndex
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut], animations: {
            for i in 1 ..< cards.count - 1 {
                let constant = self.stackOffset * CGFloat(i - 1)
                if cards[i].isTemplate {
                    cards[i].frame.origin.y = self.frame.height
                } else {
                    cards[i].frame.origin.y = self.bottomCardYPosition + constant
                }
            }
        })
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
        templateCardUpAnimation(index: nextIndex)
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
        })
    }
    
    
    func templateCardUpAnimation(index: Int) {
        guard let cards = cards else {
            return
        }
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            if index == cards.count - 2 {
                cards[cards.count - 1].frame.origin.y = self.bottomCardYPosition
            }
            if index == cards.count - 1 {
                for i in 2...cards.count {
                    cards[cards.count - i].frame.origin.y = -(cards[cards.count - 2].frame.height) * 1.2
                }
                cards[cards.count - 1].frame.origin.y = self.verticalPadding
                cards[cards.count - 1].hideOverlay()
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
        templateCardDownAnimation(index: currentCardIndex)
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
            let theEndPositionOfCentralCard = index >= cards.count - 1 ? cards[index + 1].frame.origin.y : bottomCardYPosition
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                cards[index].frame.origin.y = theEndPositionOfCentralCard
            })
        }
    }
    
    func templateCardDownAnimation(index: Int) {
        guard let cards = cards else {
            return
        }
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            if index == cards.count - 1 {
                cards[cards.count - 1].frame.origin.y = self.bottomCardYPosition
                for i in 3...cards.count {
                    cards[cards.count - i].frame.origin.y = -(cards[index].frame.height / 6) * 5
                }
                cards[cards.count - 1].showOverlay()
                cards[cards.count - 1].frame.origin.y = self.bottomCardYPosition
            }
            if index == cards.count - 2 {
                cards[cards.count - 1].frame.origin.y = self.frame.height
            }
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
