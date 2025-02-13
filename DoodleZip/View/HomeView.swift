//
//  HomeView.swift
//  DoodleZip
//
//  Created by Jaehui Yu on 2/19/25.
//

import SwiftUI
import RealmSwift
import ComposableArchitecture

struct HomeView: View {
    let store: StoreOf<NoteFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    searchBar(viewStore: viewStore)
                    cardListView(viewStore: viewStore)
                }
            }
            .safeAreaPadding(15)
            .overlay {
                if viewStore.selectedNote != nil {
                    detailView(viewStore: viewStore)
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                bottomBar(viewStore: viewStore)
            }
            .onAppear {
                viewStore.send(.loadNotes)
            }
            .onChange(of: viewStore.selectedNote) { _, newValue in
                guard let note = newValue else { return }
                viewStore.send(.changeColor(note.colorHex))
            }
            .animation(noteAnimation, value: viewStore.selectedNote != nil)
        }
    }
    
    @ViewBuilder
    func searchBar(viewStore: ViewStore<NoteFeature.State, NoteFeature.Action>) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: viewStore.binding(
                get: \.searchText,
                send: NoteFeature.Action.search
            ))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color.primary.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
    }
    
    @ViewBuilder
    func cardListView(viewStore: ViewStore<NoteFeature.State, NoteFeature.Action>) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
            ForEach(viewStore.filteredNotes, id: \.id) { note in
                cardView(note: note)
                    .frame(height: 160)
                    .onTapGesture { viewStore.send(.selectNote(note)) }
            }
        }
    }
    
    @ViewBuilder
    func cardView(note: Note) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: note.colorHex).gradient)
            VStack(alignment: .leading, spacing: 10) {
                Text(note.title)
                    .font(.title)
                Text(note.content)
                    .lineLimit(2)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func detailView(viewStore: ViewStore<NoteFeature.State, NoteFeature.Action>) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(hex: viewStore.editedColor.toHex()).gradient)
                .transition(.offset(y: 1))
            VStack(alignment: .leading, spacing: 10) {
                TextField("Title", text: viewStore.binding(
                    get: \.editedTitle,
                    send: NoteFeature.Action.updateEditedTitle
                ))
                .font(.title)
                
                Rectangle()
                    .frame(height: 0.5)
                    .background(Color.primary.colorInvert())
                
                TextEditor(text: viewStore.binding(
                    get: \.editedContent,
                    send: NoteFeature.Action.updateEditedContent
                ))
                .scrollContentBackground(.hidden)
                
                Text(DateFormatterManager.shared.formatDate(viewStore.selectedNote?.date ?? Date()))
                    .foregroundStyle(Color.secondary)
            }
            .padding(.top, 80)
            .padding(.bottom, 120)
            .padding(.horizontal, 15)
        }
        .ignoresSafeArea()
    }
    
    
    @ViewBuilder
    func bottomBar(viewStore: ViewStore<NoteFeature.State, NoteFeature.Action>) -> some View {
        HStack(spacing: 15) {
            Button {
                if let selectedNote = viewStore.selectedNote {
                    viewStore.send(.deleteNote(selectedNote))
                } else {
                    viewStore.send(.addNote)
                }
            } label: {
                Image(systemName: viewStore.selectedNote == nil ? "plus.circle.fill" : "trash.fill")
                    .foregroundStyle(viewStore.selectedNote == nil ? Color.primary : Color.red)
                    .font(.title2)
            }
            
            Spacer()
            
            if viewStore.selectedNote != nil {
                ColorPicker("", selection: viewStore.binding(
                    get: \.editedColor,
                    send: NoteFeature.Action.updateEditedColor
                ))
                .transition(.opacity)
                
                Spacer()
                
                Button {
                    viewStore.send(.updateNote)
                } label: {
                    Image(systemName: "square.grid.2x2.fill")
                        .foregroundStyle(Color.primary)
                        .font(.title2)
                }
                .transition(.opacity)
            }
        }
        .padding(15)
        .background(.bar)
        .animation(noteAnimation, value: viewStore.selectedNote != nil)
    }
}
