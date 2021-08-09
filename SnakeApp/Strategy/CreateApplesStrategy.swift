//
//  CreateApplesStrategy.swift
//  SnakeApp
//
//  Created by NIKOLAI BORISOV on 09.08.2021.
//

import UIKit

protocol CreateApplesStrategy {
    func createApples(in rect: CGRect) -> [Apple]
}

final class RandomCreateOneAppleStrategy: CreateApplesStrategy {
    func createApples(in rect: CGRect) -> [Apple] {
        let randX = CGFloat(arc4random_uniform(UInt32(rect.maxX - 5)) + 1)
        let randY = CGFloat(arc4random_uniform(UInt32(rect.maxY - 5)) + 1)
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        
        return [apple]
    }
}
