//
//  RecordsTableViewCell.swift
//  Snake
//
//  Created by NIKOLAI BORISOV on 04.08.2021.
//

import UIKit
import SnapKit

final class RecordsTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "cell"
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    
    private lazy var dateLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Title"
        
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Detail"
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Record) {
        dateLabel.text = dateFormatter.string(from: model.date)
        scoreLabel.text = String(model.score)
    }
    
    private func setupLayouts() {
        [
            dateLabel,
            scoreLabel
        ]
        .forEach { contentView.addSubview($0) }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
}
