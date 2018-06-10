//
//  CardForm.swift
//  DUI002 Credit Card
//
//  Created by Tim on 19.06.17.
//  Copyright © 2017 Tim. All rights reserved.
//

import UIKit

class CardForm: UIView {
    
    var delegate: CardFormDelegate?
    
    private lazy var cardholder: UITextField = {
        let textField = UITextField.cardField(placeholderText: "NAME")
        textField.tag = 0 // to determin wich textField it is
        textField.addTarget(self, action: #selector(CardForm.textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var number: UITextField = {
        let textField = UITextField.cardField(placeholderText: "XXXX-XXXX-XXXX-XXXX")
        textField.tag = 1
        textField.delegate = FALTextFieldMask.getInstance()
        textField.textMask = "NNNN-NNNN-NNNN-NNNN"
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(CardForm.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        return textField
    }()
    
    private lazy var expires: UITextField = {
        let textField = UITextField.cardField(placeholderText: "XX/XX")
        textField.tag = 2
        textField.delegate = FALTextFieldMask.getInstance()
        textField.textMask = "NN/NN"
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(CardForm.textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var ccv: UITextField = {
        let textField = UITextField.cardField(placeholderText: "XXX")
        textField.tag = 3
        textField.textMask = "NNN"
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(CardForm.textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var cardId: UITextField = {
        let textField = UITextField.cardField(placeholderText: "CARD ID")
        textField.tag = 4
        textField.addTarget(self, action: #selector(CardForm.textFieldDidChange(_:)), for: .editingChanged)
        textField.autocapitalizationType = .words
        return textField
    }()
    
    private var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.textColor = UIColor.black
        button.setTitle("DONE", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var type: TextFieldType
        switch textField.tag {
        case 0:
            type = TextFieldType.cardholder
        case 1:
            type = TextFieldType.number
        case 2:
            type = TextFieldType.expires
        case 3:
            type = TextFieldType.ccv
        case 4:
            type = TextFieldType.cardId
        default:
            type = TextFieldType.cardholder
        }
        if let text = textField.text {
            delegate?.textDidChange(text: text, type: type)
        }
    }
    
    func setUpViews() {
        addSubview(number)
        addSubview(cardholder)
        addSubview(expires)
        addSubview(cardId)
        addSubview(doneButton)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cardholder]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": number]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": expires]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cardId]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": doneButton]))
        
        self.addConstraint(NSLayoutConstraint(item: number, attribute: .leading, relatedBy: .equal, toItem: cardholder, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v1(40)]-10-[v3(40)]-5-[v5(40)]-5-[v7(40)]-10-[v8(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1": cardholder, "v3": number, "v5": expires, "v7": cardId, "v8": doneButton]))
    }
    
    convenience init(inFrame viewFrame: CGRect) {
        let margin: CGFloat = 10.0
        let heigth = viewFrame.width / 1.3
        let width = viewFrame.width - (margin * 2.0)
        let frame = CGRect(x: 10, y: viewFrame.height, width: width, height: heigth)
        self.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


protocol CardFormDelegate {
    func textDidChange(text: String, type: TextFieldType)
}

enum TextFieldType {
    case cardholder
    case number
    case expires
    case ccv
    case cardId
}

extension UITextField {
    static func cardField(placeholderText: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .allCharacters
        textField.textColor = .white
        let placeholderColor = UIColor(white: 1, alpha: 0.7)
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: 36, width: 500, height: 1)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
        return textField
    }
}
