//
//  Snake.swift
//  Snake
//
//  Created by NIKOLAI BORISOV on 04.08.2021.
//

import UIKit
import SpriteKit

/// Змея
class Snake: SKShapeNode {
    
    /// Скорость перемещения
    var moveSpeed = Observable<Double>(125.0)
    
    /// Угол необходимый для расчета направления
    var angle: CGFloat = 0.0
    
    /// Массив где хранятся части змеи
    var body = [SnakeBodyPart]()
    
    // MARK: - Init
    
    convenience init(atPoint point: CGPoint) {
        self.init()
        self.createHead(at: point)
    }
    
    // MARK: - Methods
    
    /// Добавляет еще один сегмент змеи
    func addBodyPart() {
        let point = CGPoint(x: body[0].position.x, y: body[0].position.y)
        let newBodyPart = SnakeBodyPart(atPoint: point)
        body.append(newBodyPart)
        addChild(newBodyPart)
    }
    
    /// Перемещает змейку
    func move() {
        guard !body.isEmpty else { return }
        
        //перемещаем голову
        let head = body[0]
        moveHead(head)
        
        //перемещаем все сегменты тела
        for index in (0..<body.count) where index > 0 {
            moveBodyPart(body[index], to: body[index-1])
        }
    }
    
    /// Сделать поворот по часовой стрелке
    func moveClockwise(){
        //смещаем угол на 45 градусов
        angle += CGFloat(Double.pi/2)
    }
    
    /// Сделать поворот против часовой стрелки
    func moveCounterClockwise(){
        angle -= CGFloat(Double.pi/2)
    }
    
    // MARK: - Private
    
    private func createHead(at point: CGPoint) {
        let head = SnakeHead(atPoint: point)
        body.append(head)
        addChild(head)
    }

    
    private func moveHead(_ head: SnakeBodyPart) {
        //расчитываем смещение точки
        let dx = CGFloat(moveSpeed.value) * sin(angle);
        let dy = CGFloat(moveSpeed.value) * cos(angle);
        //смещаем точку назначения головы
        let nextPosition = CGPoint(x: head.position.x + dx, y: head.position.y + dy)
        //действие перемещения головы
        let moveAction = SKAction.move(to: nextPosition, duration: 1.0)
        head.run(moveAction)
    }
    
    private func moveBodyPart(_ bodyPart: SnakeBodyPart, to toBodyPart: SnakeBodyPart) {
        //перемещаем текущий элемент к предыдущему
        let moveAction = SKAction.move(to: CGPoint(x: toBodyPart.position.x, y: toBodyPart.position.y), duration: 0.1)
        bodyPart.run(moveAction)
    }
}
