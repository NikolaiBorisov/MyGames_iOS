//
//  Game.swift
//  Snake
//
//  Created by NIKOLAI BORISOV on 04.08.2021.
//

import Foundation

final class Game {
    
    private let recordsCaretaker = RecordsCaretaker()
    static let shared = Game()
    var records: [Record] {
        didSet {
            RecordsCaretaker.save(records: self.records)
        }
    }
    private init() {
        self.records = RecordsCaretaker.retrieveRecords()
    }
    
    func addRecord(_ record: Record) {
        self.records.append(record)
    }
    
    func clearRecords() {
        self.records = []
    }
    
}
