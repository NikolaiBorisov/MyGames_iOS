//
//  RecordsTableViewController.swift
//  Snake
//
//  Created by NIKOLAI BORISOV on 04.08.2021.
//

import UIKit

class RecordsTableViewController: UITableViewController {
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: RecordsTableViewCell.cellIdentifier)
        setupBackButton()
    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(onBackButtonTapped(_:))
        )
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @objc private func onBackButtonTapped(_ sender: UIButton) {
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Game.shared.records.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordsTableViewCell.cellIdentifier, for: indexPath) as? RecordsTableViewCell else { return UITableViewCell() }
        let record = Game.shared.records[indexPath.row]
        cell.configure(with: record)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if case .delete = editingStyle {
            Game.shared.records.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            RecordsCaretaker.delete(row: indexPath.row)
            tableView.reloadData()
        }
    }
    
}
