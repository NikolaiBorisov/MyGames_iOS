//
//  MainViewController.swift
//  Snake
//
//  Created by NIKOLAI BORISOV on 04.08.2021.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    private lazy var startButton: UIButton = {
        let button =  UIButton()
        button.setTitle("START", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(onStartButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var recordButton: UIButton = {
        let button =  UIButton()
        button.setTitle("Records", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(onRecordsButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var resultLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.white.cgColor
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.isHidden = true
        view.backgroundColor = .black
        setupLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc private func onStartButtonTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else { return }
        vc.delegate = self
        //using closure
//        vc.onGameEnd = { [weak self] result in
//            self?.resultsLabel.text = "Last Result: \(result)"
//        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onRecordsButtonTapped(_ sender: UIButton) {
        let vc = RecordsTableViewController()
        //vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupLayouts() {
        [
            startButton,
            resultLabel,
            recordButton
        ]
        .forEach { view.addSubview($0) }
        
        startButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        resultLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(startButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(startButton.snp.height)
        }
        
        recordButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
}

extension MainViewController: GameViewControllerDelegate {
    func didEndGame(withResult result: Int) {
        resultLabel.isHidden = false
        resultLabel.text = "Last Result: \(result)"
    }
}
