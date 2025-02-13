//
//  Note.swift
//  DoodleZip
//
//  Created by Jaehui Yu on 2/19/25.
//

import SwiftUI
import RealmSwift

class Note: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var colorHex: String = "#FFFFFF"
    @Persisted var allowsHitTesting: Bool
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var date: Date
    
    convenience init(colorHex: String, allowsHitTesting: Bool, title: String, content: String, date: Date) {
        self.init()
        self.colorHex = colorHex
        self.allowsHitTesting = allowsHitTesting
        self.title = title
        self.content = content
        self.date = date
    }
}
