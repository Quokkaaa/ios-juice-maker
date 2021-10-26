//
//  JuiceMaker - FruitStore.swift
//  Created by yeha.
//  Copyright © yagom academy. All rights reserved.

import Foundation

class FruitStore {
    typealias FruitStock = Int
    
    enum Fruit: CaseIterable {
        case strawberry
        case banana
        case kiwi
        case pineapple
        case mango
    }
    private var fruitStockList: [Fruit: FruitStock] = [:]
    
    init(initialFruitStock: FruitStock = 10) {
        for fruitName in Fruit.allCases {
            fruitStockList[fruitName] = initialFruitStock
        }
    }
    
    func changeFruitStock(fruitName: Fruit, changingNumber: Int) throws {
        guard let currentFruitStock = fruitStockList[fruitName] else {
            throw FruitError.isNotExistValue
        }
        fruitStockList[fruitName] = (currentFruitStock + changingNumber)
    }
    func isHaveEnoughStock(for menu: JuiceMaker.Juice) throws -> Bool {
        for (fruitName, juiceIngredient) in menu.recipe {
            guard let fruitStock = fruitStockList[fruitName] else {
                throw FruitError.outOfStock
            }
            guard fruitStock >= juiceIngredient else {
                throw FruitError.outOfStock
            }
            
        }
        return true
    }
}
