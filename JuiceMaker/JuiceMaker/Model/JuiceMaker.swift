//
//  JuiceMaker - JuiceMaker.swift
//  Created by Quokkaaa.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

struct JuiceMaker {
    typealias JuiceIngredient = Int
    
    var fruitStore = FruitStore()
    
    enum Juice {
        case strawberryJuice
        case bananaJuice
        case kiwiJuice
        case pineappleJuice
        case strawberryBananaJuice
        case mangoJuice
        case mangoKiwiJuice

        fileprivate var recipe: [FruitStore.Fruit: JuiceIngredient] {
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
    
    func makeJuice(for menu: Juice) {
        var count: Int = 0
        let juiceIngredientCount: Int = menu.recipe.count
        
        for (fruitName, juiceIngredient) in menu.recipe {
            guard (try? fruitStore.isHaveEnoughStock(fruitName: fruitName, juiceIngredient: juiceIngredient)) != nil else {
                break
            }
            count += 1
            guard count == juiceIngredientCount,
                  (try? fruitStore.changeFruitStock(fruitName: fruitName, changingNumber: juiceIngredient)) != nil else {
                continue
            }
        }
    }
}
