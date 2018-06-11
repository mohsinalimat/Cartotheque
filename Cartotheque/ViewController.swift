//
//  ViewController.swift
//  Cartotheque
//
//  Created by Tim on 09.06.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class ViewController: UIViewController {
    
    let cartotheque: Cartotheque = {
        let cartotheque = Cartotheque()
        cartotheque.backgroundColor = .lightGray
        return cartotheque
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cartotheque)
        cartotheque.dataSource = self
        setupViews()
    }
    
    func setupViews() {
        cartotheque.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    func loadCardData() -> [CardData]? {
        if let path = Bundle.main.path(forResource: "credit_cards", ofType: "json"), let jsonData = NSData(contentsOf: URL(fileURLWithPath: path)) {
            do {
                let jsonArray = try JSON(data: jsonData as Data)
                let cards = jsonArray.map { CardData(json: $0.1) }
                return cards
            } catch {
                print("Error: couldn't parse JSON")
            }
        }
        return nil
    }
    
    func getCards(_ cardDataItems: [CardData]) -> [CardView] {
        guard cardDataItems.count > 0 else {
            return []
        }
        
        let f = self.view.frame
        var cardViews = [CardView]()
        var i = 1
        
        for card in cardDataItems {
            let v = CardView(inFrame: self.view.frame)
            v.card = card
            let white = CGFloat(1.0 / 10 * CGFloat(i))
            let color = UIColor(white: white, alpha: 1)
            v.backgroundColor = color
            cardViews.append(v)
            i = white > 0.8 ? 1 : i + 1
        }
        return cardViews
    }
    
    
}

extension ViewController: CartothequeDataSource {
    func cards() -> [CardView] {
        guard let cardDataItems = loadCardData() else {
            return []
        }
        return getCards(cardDataItems)
    }
    
}

