//
//  GameViewController.swift
//  Snake
//
//  Created by NIKOLAI BORISOV on 04.08.2021.
//

import UIKit
import SpriteKit
import GameplayKit

protocol GameViewControllerDelegate: AnyObject {
    func didEndGame(withResult result: Int)
}

final class GameViewController: UIViewController {
    
    weak var delegate: GameViewControllerDelegate?
    var onGameEnd: ((Int) -> Void)?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      navigationController?.setNavigationBarHidden(false, animated: animated)
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
