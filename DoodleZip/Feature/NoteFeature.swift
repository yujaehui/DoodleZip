//
//  NoteFeature.swift
//  DoodleZip
//
//  Created by Jaehui Yu on 2/19/25.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct NoteFeature: Reducer {
    struct State: Equatable {
        var notes: [Note] = []
        var filteredNotes: [Note] = []
        var selectedNote: Note? = nil
        var editedColor: Color = .white
        var editedTitle: String = ""
        var editedContent: String = ""
        var searchText: String = ""
    }
    
    enum Action: Equatable {
        case loadNotes
        case notesLoaded([Note])
        case selectNote(Note)
        case addNote
        case deleteNote(Note)
        case changeColor(String)
        case updateEditedColor(Color)
        case updateEditedTitle(String)
        case updateEditedContent(String)
        case updateNote
        case search(String)
        case closeDetail
    }
    
    @Dependency(\.realmClient) var realmClient // Reducer 내부에서 Dependency 주입
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .loadNotes:
            return .run { send in
                let notes = try await realmClient.fetchNotes()
                await send(.notesLoaded(notes))
            }
        case let .notesLoaded(loaded):
            state.notes = loaded
            state.filteredNotes = state.notes
            return .none
        case .addNote:
            let newNote = Note(colorHex: Color.gray.toHex(), allowsHitTesting: false, title: "New Note", content: "Write something...", date: Date())
            return .run { send in
                try await realmClient.addNote(newNote)
                let notes = try await realmClient.fetchNotes()
                await send(.selectNote(newNote))
                await send(.notesLoaded(notes))
            }
        case let .deleteNote(note):
            state.selectedNote = nil
            state.notes.removeAll { $0.id == note.id }
            state.filteredNotes.removeAll { $0.id == note.id }
            return .run { send in
                try await realmClient.deleteNote(note)
                let notes = try await realmClient.fetchNotes()
                await send(.notesLoaded(notes))
            }
        case let .selectNote(note):
            state.selectedNote = note
            state.editedColor = Color(hex: note.colorHex)
            state.editedTitle = note.title
            state.editedContent = note.content
            return .none
        case let .changeColor(colorHex):
            state.editedColor = Color(hex: colorHex)
            return .none
        case let .updateEditedColor(newColor):
            state.editedColor = newColor
            return .none
        case let .updateEditedTitle(newTitle):
            state.editedTitle = newTitle
            return .none
        case let .updateEditedContent(newContent):
            state.editedContent = newContent
            return .none
        case .updateNote:
            guard let selectedNote = state.selectedNote else { return .none }
            let updatedNote = Note(colorHex: state.editedColor.toHex(), allowsHitTesting: false, title: state.editedTitle, content: state.editedContent, date: Date())
            return .run { send in
                try await realmClient.updateNote(selectedNote, updatedNote)
                let notes = try await realmClient.fetchNotes()
                await send(.notesLoaded(notes))
                await send(.selectNote(selectedNote))
                await send(.closeDetail)
            }
        case let .search(text):
            if text.isEmpty {
                state.filteredNotes = state.notes
            } else {
                state.filteredNotes = state.notes.filter {
                    $0.title.localizedCaseInsensitiveContains(text) ||
                    $0.content.localizedCaseInsensitiveContains(text)
                }
            }
            return .none
        case .closeDetail:
            state.selectedNote = nil
            return .none
        }
    }
}
