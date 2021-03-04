//
//  GameViewController.swift
//  GameFlight
//
//  Created by NIKOLAI BORISOV on 18.02.2021.
//

//import UIKit //основная библиотека отвечает за взаимодействие между пользователем и приложением
//import QuartzCore // работа с функциями анимации

import SceneKit

class GameViewController: UIViewController {
    
    // MARK: - Outlets
    let button = UIButton()
    let label = UILabel()
    
    // MARK: - Stored Properties
    var duration: TimeInterval = 5
    var score = 0 {
        didSet {
            label.text = "Score: \(score)"
            label.textColor = .white
        }
    }
    var ship: SCNNode!
    var scene: SCNScene!
    var scnView: SCNView!
    
    // MARK: - Methods
    /// Adds a button to the scene view
    func addButton() {
        // Button coordinates
        let midX = scnView.frame.midX
        let midY = scnView.frame.midY
        let width: CGFloat = 200
        let height = CGFloat(100)
        button.frame = CGRect(x: midX - width / 2, y: midY - height / 2, width: width, height: height)
        
        // Configure button
        button.backgroundColor = .systemTeal
        button.isHidden = true
        button.layer.cornerRadius = 15
        button.setTitle("Restart", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        
        // Add action to the button
        button.addTarget(self, action: #selector(newGame), for: .touchUpInside)
        
        // Add button to the scene
        scnView.addSubview(button)
    }
    
    /// Adds label to the scene view
    func addLabel() {
        label.font = UIFont.systemFont(ofSize: 30)
        label.frame = CGRect(x: 0, y: 0, width: scnView.frame.width, height: 100)
        label.numberOfLines = 2
        label.textAlignment = .center
        scnView.addSubview(label)
        score = 0
    }
    
    func addShip() {
        scene.rootNode.addChildNode(ship)
    }
    
    /// Clones new ship from the scene
    /// - Returns: SCNNode with the new ship
    func getShip() -> SCNNode {
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        ship = scene.rootNode.childNode(withName: "ship", recursively: true)!.clone()
        
        // Move ship far away
        let x = Int.random(in: -25 ... 25)
        let y = Int.random(in: -25 ... 25)
        let z = -105
        ship.position = SCNVector3(x, y, z)
        ship.look(at: SCNVector3(2 * x, 2 * y, 2 * z))
        
        // Add animation to move the ship to origin
        ship.runAction(.move(to: SCNVector3(), duration: duration)) {
            self.ship.removeFromParentNode()
            DispatchQueue.main.async {
                self.button.isHidden = false
                self.label.text = "Game Over\nScore: \(self.score)"
            }
        }
        
        return ship
    }
    
    @objc func newGame() {
        button.isHidden = true
        duration = 5
        score = 0
        ship = getShip()
        addShip()
    }
    
    /// Finds and removes the ship from the scene
    func removeShip() {
        scene.rootNode.childNode(withName: "ship", recursively: true)?.removeFromParentNode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // remove the ship
        removeShip()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        //        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        //        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        // animate the 3d object
        //        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        scnView = self.view as? SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        // Add ship to the scene
        ship = getShip()
        addShip()
        
        // Add button and label
        addButton()
        addLabel()
    }
    
    // MARK: - Actions
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.2
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                self.duration *= 0.9
                self.score += 1
                self.ship.removeFromParentNode()
                self.ship = self.getShip()
                self.addShip()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    // MARK: - Computed Properties
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
}

//import SceneKit //3d библиотека включает в себя UIKit и QuartzCore
//
//class GameViewController: UIViewController { // класс - сущность определяющая свойства и действия объекта. Наследование - возможность использования свойств и методов родителя, которые в нем определены
//
//    var newPlane = false
//
//    var duration: TimeInterval = 5 {
//        didSet {
//
//        }
//    } //продолжтительность анимации
//
//    let scoreLabel = UILabel() //создаем лейбл для очков
//
//    var score: Int = 0 {
//        didSet {
//            scoreLabel.text = "Score: \(score)"
//        }
//    }
//
//    var ship: SCNNode?
//
//    //Add ship to the scene
//    func addShip() {
//        //Get a scene with the ship
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        //Find the ship in the scene
//        ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
//
//        //Set ship coordinates
//        let x = Int.random(in: -25...25)
//        let y = Int.random(in: -25...25)
//        let z = -105
//
//        ship?.position = SCNVector3(x, y, z)
//        ship?.look(at: SCNVector3(2 * x, 2 * y, 2 * z))
//
//        //MARK:- Game Over
//        //Make the ship fly from far to the origin
//        ship?.runAction(SCNAction.move(to: SCNVector3(), duration: duration)) {
//            DispatchQueue.main.async {
//                self.scoreLabel.text = "GAME OVER\nFinal Score: \(self.score)"
//            }
//
//            self.ship?.removeFromParentNode()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                self.duration = 5
//                self.score = 0 //повторяем вызов функции через 3 секунды после удалления корабля со сцены
//                self.addShip()
//            }
//        }
//
//        //Get the scene
//        let scnView = self.view as! SCNView
//
//        // Add ship to the scene
//        if let ship = self.ship {
//            scnView.scene?.rootNode.addChildNode(ship)
//        }
//
//    }
//
//    func setupUI() {
//        score = 0
//        scoreLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
//        scoreLabel.numberOfLines = 2
//        scoreLabel.textAlignment = .center //лейбл по центру экрана
//        scoreLabel.font = UIFont.systemFont(ofSize: 30)
//        scoreLabel.textColor = .white
//        view.addSubview(scoreLabel)
//    }
//
//    override func viewDidLoad() { //запускается когда наш вью контроллер загрузился в память.
//        super.viewDidLoad()
//
//        // create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // create and add a camera to the scene
//        let cameraNode = SCNNode() //node - узел, основной элемент 3d  сцены
//        cameraNode.camera = SCNCamera() //устанавливаем свойство "Камера"
//        scene.rootNode.addChildNode(cameraNode) //добавляем на сцену (rootNode-корневой узел), addChildNode добавляет cameraNode  к rootNode
//
//        // place the camera
//        //cameraNode.position = SCNVector3(x: 0, y: 0, z: 15) //
//
//        // create and add a light to the scene
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light!.type = .omni //точечный источник света
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//        scene.rootNode.addChildNode(lightNode) // добавлянм на сцену
//
//        // create and add an ambient light to the scene
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light!.type = .ambient //общий источник света
//        ambientLightNode.light!.color = UIColor.darkGray
//        scene.rootNode.addChildNode(ambientLightNode)
//
//        // retrieve the ship node
//        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!//childNode - ищет на сцене ноды
//        ship.removeFromParentNode()
//
//
//        // retrieve the SCNView
//        let scnView = self.view as! SCNView
//
//        // set the scene to the view
//        scnView.scene = scene //отображение/присваивание scvView сцены
//
//        // allows the user to manipulate the camera
//        scnView.allowsCameraControl = false //доступ к управлению камерой
//
//        // show statistics such as fps and timing information
//        scnView.showsStatistics = true //кадров секунду frames per second
//
//        // configure the view
//        scnView.backgroundColor = UIColor.black
//
//        // add a tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        scnView.addGestureRecognizer(tapGesture)
//
//        //Add the ship to the scene
//        addShip()
//
//        setupUI()
//    }
//
//    @objc
//    func handleTap(_ gestureRecognize: UIGestureRecognizer) { //срабатывает по нажатию
//        // retrieve the SCNView
//        let scnView = self.view as! SCNView //получаем сцену
//
//        // check what nodes are tapped
//        let p = gestureRecognize.location(in: scnView) //создаем двухмерную точку для нажатия по экрану
//        let hitResults = scnView.hitTest(p, options: [:]) //возвращает массив результатов
//        // check that we clicked on at least one object
//        if hitResults.count > 0 { //проверяем кол-во элементов в массиве
//            // retrieved the first clicked object
//            let result = hitResults[0] // получаем доступ к первому элементу массива
//
//            // get its material
//            let material = result.node.geometry!.firstMaterial! //
//
//            // highlight it
//            SCNTransaction.begin() //начинаем транзакцию
//            SCNTransaction.animationDuration = 0.2 // покраснение объекта
//
//            //MARK: Kill the plane
//            // on completion - unhighlight
//            SCNTransaction.completionBlock = {
//                self.duration *= 0.9
//                self.score += 1 // увеличиваем счетчик на единицу
//                self.ship?.removeFromParentNode() //  Cбиваем самолет
//                self.addShip() //добавляем самолет снова
//            }
//            material.emission.contents = UIColor.red // делаем самолет красным при нажатии
//
//            SCNTransaction.commit()
//        }
//    }
//
//    override var shouldAutorotate: Bool {
//        return true
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
//
//}
