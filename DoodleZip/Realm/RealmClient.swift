//
//  RealmClient.swift
//  DoodleZip
//
//  Created by Jaehui Yu on 2/19/25.
//

import Foundation
import RealmSwift
import ComposableArchitecture

// Realm 관련 작업을 캡슐화한 클라이언트 정의
@MainActor
struct RealmClient {
    var fetchNotes: () async throws -> [Note]
    var addNote: (Note) async throws -> Void
    var deleteNote: (Note) async throws -> Void
    var updateNote: (Note, Note) async throws -> Void
}

// DependencyKey에 등록 (TCA Dependency 시스템 사용)
extension RealmClient: DependencyKey {
    static let liveValue = Self(
        fetchNotes: {
            let realm = try Realm()
            return Array(realm.objects(Note.self))
        },
        addNote: { note in
            let realm = try Realm()
            try realm.write {
                realm.add(note)
            }
        },
        deleteNote: { note in
            let realm = try Realm()
            try realm.write {
                realm.delete(note)
            }
        },
        updateNote: { note, updateNote in
            let realm = try Realm()
            try realm.write {
                note.colorHex = updateNote.colorHex
                note.title = updateNote.title
                note.content = updateNote.content
                note.date = updateNote.date
            }
        }
    )
}

// DependencyValues에 접근할 수 있도록 확장
extension DependencyValues {
    var realmClient: RealmClient {
        get { self[RealmClient.self] }
        set { self[RealmClient.self] = newValue }
    }
}
