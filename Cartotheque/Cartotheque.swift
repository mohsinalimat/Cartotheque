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
    var verticalEdgePadding: CGFloat = 20
    var dataSource: CartothequeDataSource?
    
    lazy private var centralCardYPosition: CGFloat = {
        return (frame.height / 2) - (cards![0].frame.height / 6) * 5
    }()
    
    lazy private var bottomCardYPosition: CGFloat = {
       return (self.frame.height - cards![0].frame.height) - self.verticalEdgePadding
    }()
    
    lazy var title: UILabel = {
        let selectCardLabel = UILabel()
        selectCardLabel.textColor = .white
        selectCardLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.light)
        selectCardLabel.textAlignment = .center
        selectCardLabel.text = "SELECT CARD"
        selectCardLabel.frame = CGRect(x: 0, y: frame.height / 7, width: frame.width, height: 30)
        return selectCardLabel
    }()
    
    lazy var cardForm: CardForm = {
        let cardForm = CardForm(inFrame: self.frame)
        cardForm.alpha = 0
        cardForm.delegate = self
        cardForm.frame.origin.y = frame.height
        return cardForm
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
        addSubview(title)
        setupCards()
        addSubview(cardForm)
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
        animateFormUp()
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
                cards[cards.count - 1].frame.origin.y = self.verticalEdgePadding
                cards[cards.count - 1].hideOverlay()
            }
        })
    }
    
    func animateFormUp() {
        print(currentCardIndex)
        guard let cards = cards, currentCardIndex == cards.count - 2 else {
            return
        }
        
        let padding: CGFloat = 10
        self.cardForm.isHidden = false
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.cardForm.frame.origin.y = self.verticalEdgePadding + cards[0].frame.height + padding
            self.cardForm.alpha = 1
        })
    }
    
    func animateFormDown() {
        print(currentCardIndex)
        guard let cards = cards, currentCardIndex == cards.count - 1 else {
            return
        }
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.cardForm.frame.origin.y = self.frame.height
            self.cardForm.alpha = 0
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
        animateFormDown()
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

extension Cartotheque: CardFormDelegate {
    func textDidChange(text: String, type: TextFieldType) {
        guard let cards = cards else {
            return
        }
        switch type {
        case .cardholder:
            cards.last?.cardholder.text = text
        case .cardId:
            cards.last?.title.text = text
        case .expires:
            cards.last?.expiration.text = text
        case .number:
            cards.last?.number.text = text
        default:
            print("default")
        }
    }
}

protocol CartothequeDataSource {
    func cards() -> [CardView]
}
