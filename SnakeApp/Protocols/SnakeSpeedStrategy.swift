//
//  SnakeSpeedStrategy.swift
//  SnakeApp
//
//  Created by NIKOLAI BORISOV on 09.08.2021.
//

import UIKit

protocol SnakeSpeedStrategy: AnyObject {
    var snake: Snake? { get set }
    var maxSpeed: Double? { get set }
    func increaseSpeedByEatingApple()
}
