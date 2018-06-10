//
//  CardView.swift
//  Cartotheque
//
//  Created by Tim on 09.06.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit



class CardView: UIView {
    
    var isTemplate = false {
        didSet {
            overlay.isHidden = !isTemplate
        }
    }
    
    var textColor: UIColor {
        didSet {
            self.setTextColor(color: textColor)
        }
    }
    
    lazy var title: UILabel = {
        let l = UILabel.standard(font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.thin))
        l.text = "Card ID"
        l.textAlignment = .right
        return l
    }()
    
    lazy var number: UILabel = {
        let size: CGFloat = self.frame.width / 15 > 0 ? self.frame.width / 15 : 22
        let l = UILabel.standard(font: UIFont(name: "Courier New", size: size))
        l.text = "XXXX XXXX XXXX XXXX"
        return l
    }()
    
    lazy var cardholder: UILabel = {
        let l = UILabel.standard(font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin))
        l.text = ""
        return l
    }()
    
    lazy var expiration: UILabel = {
        let l = UILabel.standard(font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin))
        l.text = "XX/XX"
        l.textAlignment = .right
        return l
    }()
    
    lazy var dummyLabel: UILabel = {
        let l = UILabel.standard(font: UIFont.systemFont(ofSize: self.frame.width / 17, weight: UIFont.Weight.thin))
        l.text = "SWIPE UP TO ADD A NEW CARD"
        l.textAlignment = .center
        return l
    }()
    
    lazy var overlay: UIView = {
        let overlay = UIView(frame: self.frame)
        overlay.alpha = 0.8
        overlay.isHidden = true
        overlay.backgroundColor = UIColor.black
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(self.dummyLabel)
        overlay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": self.dummyLabel]))
        overlay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": self.dummyLabel]))
        return overlay
    }()
    
    var isOverlayHidden: Bool? {
        set {
            if overlay.superview != nil {
                if let newVal = newValue, newVal == true  {
                    overlay.alpha = 0.0
                } else {
                    overlay.alpha = 0.8
                }
            }
        }
        get {
            if overlay.superview != nil {
                return overlay.alpha == 0.0
            }
            return nil
        }
    }
    
    var card: CardData? {
        didSet {
            title.text = card?.title
            number.text = card?.number
            cardholder.text = card?.cardholder
            expiration.text = card?.expires
        }
    }
    
    convenience init(inFrame viewFrame: CGRect) {
        let margin: CGFloat = 10.0
        let heigth = viewFrame.width / 1.585
        let width = viewFrame.width - (margin * 2.0)
        let frame = CGRect(x: 10, y: viewFrame.height - heigth - 10, width: width, height: heigth)
        self.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        self.textColor = UIColor.white
        super.init(frame: frame)
        self.backgroundColor = UIColor.wetAsphalt()
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 4.0
        setupTitle()
        setupNumber()
        setupCardHolder()
        setupExpiration()
        setupOverlay()
    }
    
    fileprivate func setupTitle() {
        addSubview(title)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": title]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": title]))
    }
    
    fileprivate func setupNumber() {
        addSubview(number)
        
        let numberTitle = UILabel.standard(font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.ultraLight))
        numberTitle.text = "Card Number"
        
        self.addConstraint(NSLayoutConstraint(item: number, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        addSubview(numberTitle)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": number]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": numberTitle]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(10)]-10-[v1(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": numberTitle, "v1": number]))
        
    }
    
    fileprivate func setupCardHolder() {
        let cardholderTitle = UILabel.standard(font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.ultraLight))
        cardholderTitle.text = "Cardholder's name"
        addSubview(cardholderTitle)
        addSubview(cardholder)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cardholderTitle]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cardholder]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(10)]-10-[v1(30)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cardholderTitle, "v1": cardholder]))
    }
    
    fileprivate func setupExpiration() {
        let expirationTitle = UILabel.standard(font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.ultraLight))
        expirationTitle.text = "Expires on"
        expirationTitle.textAlignment = .right
        addSubview(expirationTitle)
        addSubview(expiration)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": expirationTitle]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": expiration]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(10)]-10-[v1(30)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": expirationTitle, "v1": expiration]))
    }
    
    fileprivate func setTextColor(color: UIColor) {
        self.cardholder.textColor = color
        self.dummyLabel.textColor = color
        self.expiration.textColor = color
        self.number.textColor = color
        self.title.textColor = color
    }
    
    fileprivate func setupOverlay() {
        self.addSubview(overlay)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": overlay]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": overlay]))
    }

}
