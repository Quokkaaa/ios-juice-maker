//
//  JuiceMaker - JuiceMaker.swift
//  Created by Quokkaaa.
//  Copyright © yagom academy. All rights reserved.

import Foundation

struct JuiceMaker {
    typealias JuiceIngredient = Int
    
    private var fruitStore = FruitStore()
    
    enum Juice {
        case strawberryJuice
        case bananaJuice
        case kiwiJuice
        case pineappleJuice
        case strawberryBananaJuice
        case mangoJuice
        case mangoKiwiJuice
        
        var recipe: [FruitStore.Fruit: JuiceIngredient] {
            switch self {
            case .strawberryJuice:
                return [.strawberry: 16]
            case .bananaJuice:
                return [.banana: 2]
            case .kiwiJuice:
                return [.kiwi: 3]
            case .pineappleJuice:
                return [.pineapple: 2]
            case .strawberryBananaJuice:
                return [.strawberry: 2, .banana: 1]
            case .mangoJuice:
                return [.mango: 3]
            case .mangoKiwiJuice:
                return [.mango: 2, .kiwi: 1]
            }
        }
    }
    
    func orderJuice(for menu: Juice) throws {
        guard try fruitStore.isHaveEnoughStock(for: menu) else {
            throw FruitError.outOfStock
        }
        try makeJuice(for: menu)
    }
    
    func makeJuice(for menu: Juice) throws {
        for (fruitName, juiceIngredient) in menu.recipe {
        do {
            try fruitStore.changeFruitStock(fruitName: fruitName, changingNumber: juiceIngredient)
            } catch FruitError.isNotExistValue {
                print("값이 존재하지 않음!")
            }
        }
    }
}


