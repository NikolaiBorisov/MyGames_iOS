//
//  GameViewController.swift
//  Snake
//
//  Created by NIKOLAI BORISOV on 04.08.2021.
//

import UIKit
import SpriteKit
import GameplayKit
import SnapKit

protocol GameViewControllerDelegate: AnyObject {
    func didEndGame(withResult result: Int)
}

final class GameViewController: UIViewController {
    
    weak var delegate: GameViewControllerDelegate?
    var difficulty: Difficulty = .medium
    private var createAppleStrategy: CreateApplesStrategy {
        switch self.difficulty {
        case .easy: return SequentialCreateOneAppleStrategy()
        case .medium, .hard, .insane: return RandomCreateOneAppleStrategy()
        }
    }
    private var snakeSpeedStrategy: SnakeSpeedStrategy {
        switch self.difficulty {
        case .easy, .medium: return NotIncreaseSnakeSpeedStrategy()
        case .hard:
            let strategy = ArithmeticProgressionSnakeSpeedStrategy()
            strategy.maxSpeed = 350.0
            return strategy
        case .insane: return GeometricProgressionSnakeSpeedStrategy()
        }
    }
    // using closure
    //var onGameEnd: ((Int) -> Void)?
    
    private lazy var speedLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        
        return label
    }()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        let scene = GameScene(size: view.bounds.size,
                              createApplesStrategy: self.createAppleStrategy,
                              snakeSpeedStrategy: self.snakeSpeedStrategy)
        scene.gameDelegate = self
        // using closure
        //        scene.onGameEnd = { [weak self] result in
        //            self?.onGameEnd?(result)
        //            self?.navigationController?.popViewController(animated: true)
        //        }
        scene.scaleMode = .resizeFill
        guard let skView = view as? SKView else { return }
        skView.showsFPS = true //включаем отображение fps (количество кадров в секунду)
        skView.showsNodeCount = true //показывать количество объектов на экране
        skView.ignoresSiblingOrder = true //включаем произволный порядок рендеринга объектов в узле
        skView.presentScene(scene)
        scene.snake?.moveSpeed.addObserver(self, options: [.new, .initial], closure: { [weak self] (moveSpeed, _) in
            self?.speedLabel.text = "Snake speed: \(moveSpeed)"
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupLayouts() {
        view.addSubview(speedLabel)
        speedLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    // MARK: - UIViewController
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: GameSceneDelegate {
    
    func didEndGame(withResult result: Int) {
        self.delegate?.didEndGame(withResult: result)
        self.navigationController?.popViewController(animated: true)
    }
}
