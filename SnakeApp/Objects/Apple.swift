//
//  Apple.swift
//  Snake
//
//  Created by NIKOLAI BORISOV on 04.08.2021.
//

import UIKit
import SpriteKit

//Яблоко
final class Apple: SKShapeNode {
    
    //определяем как оно будет рисоваться
    convenience init(position: CGPoint) {
        self.init()
        self.position = position
        self.configureUI()
        self.addPhysicsBody()
    }
    
    private func configureUI() {
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath
        fillColor = UIColor.red
        strokeColor = UIColor.red
        lineWidth = 5
    }
    
    private func addPhysicsBody() {
        //Добавялем физическое тело совпадающее с изображением яблока
        self.physicsBody = SKPhysicsBody(circleOfRadius: 10.0, center:CGPoint(x:5, y:5))
        //категория - яблоко
        self.physicsBody?.categoryBitMask = CollisionCategories.Apple
    }
}

