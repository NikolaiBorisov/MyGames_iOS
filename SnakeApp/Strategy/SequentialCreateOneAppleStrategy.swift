//
//  SequentialCreateOneAppleStrategy.swift
//  SnakeApp
//
//  Created by NIKOLAI BORISOV on 09.08.2021.
//

import UIKit

final class SequentialCreateOneAppleStrategy: CreateApplesStrategy {
    
    private let positions = [
        CGPoint(x: 210, y: 210),
        CGPoint(x: 250, y: 250),
        CGPoint(x: 150, y: 250),
        CGPoint(x: 250, y: 300),
        CGPoint(x: 210, y: 210),
        CGPoint(x: 200, y: 210),
        CGPoint(x: 200, y: 250),
        CGPoint(x: 100, y: 200),
        CGPoint(x: 150, y: 300),
        CGPoint(x: 150, y: 250)
    ]
    
    private var lastUsedPositionIndex = -1
    
    func createApples(in rect: CGRect) -> [Apple] {
        self.lastUsedPositionIndex += 1
        if self.lastUsedPositionIndex >= self.positions.count {
            self.lastUsedPositionIndex = 0
        }
        let position = self.positions[self.lastUsedPositionIndex]
        let apple = Apple(position: position)
        
        return [apple]
    }
}
