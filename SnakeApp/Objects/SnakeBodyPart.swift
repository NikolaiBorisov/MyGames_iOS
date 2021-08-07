//
//  SnakeBodyPart.swift
//  Snake
//
//  Created by NIKOLAI BORISOV on 04.08.2021.
//


import UIKit
import SpriteKit

class SnakeBodyPart: SKShapeNode {
    
    // MARK: - Init
    
    init(atPoint point: CGPoint) {
        super.init()
        self.position = point
        self.configureUI()
        self.addPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func configureUI() {
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath
        fillColor = UIColor.green
        strokeColor = UIColor.green
        lineWidth = 10
    }
    
    private func addPhysicsBody() {
        //Создаем физическое тело
        self.physicsBody = SKPhysicsBody(circleOfRadius: 6, center: CGPoint(x: 5, y:5))
        //категория - змея
        self.physicsBody?.categoryBitMask = CollisionCategories.Snake
        //пересекается с границами экрана и яблоком
        self.physicsBody?.contactTestBitMask = CollisionCategories.EdgeBody | CollisionCategories.Apple
    }
}
