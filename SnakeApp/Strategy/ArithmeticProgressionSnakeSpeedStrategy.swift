//
//  ArithmeticProgressionSnakeSpeedStrategy.swift
//  SnakeApp
//
//  Created by NIKOLAI BORISOV on 09.08.2021.
//

import Foundation

final class ArithmeticProgressionSnakeSpeedStrategy: SnakeSpeedStrategy {
   
    var snake: Snake?
    var maxSpeed: Double?
    private let diff = 10.0
    func increaseSpeedByEatingApple() {
        guard let snake = snake else { return }
        snake.moveSpeed.value += self.diff
        if let maxSpeed = maxSpeed {
            if snake.moveSpeed.value > maxSpeed {
                snake.moveSpeed.value = maxSpeed
            }
        }
    }
    
}
