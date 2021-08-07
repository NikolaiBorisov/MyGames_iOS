//
//  RecordsCaretaker.swift
//  Snake
//
//  Created by NIKOLAI BORISOV on 04.08.2021.
//

import Foundation

final class RecordsCaretaker {
    
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    static let key = "records"
    
    static func save(records: [Record]) {
        do {
            let data = try self.encoder.encode(records)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    static func retrieveRecords() -> [Record] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        do {
            return try self.decoder.decode([Record].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
    
    static func delete(row: Int) {
        guard var data = UserDefaults.standard.data(forKey: key) else { return }
        data.remove(at: row)
    }
    
}
