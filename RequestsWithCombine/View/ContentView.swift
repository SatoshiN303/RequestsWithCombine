//
//  ContentView.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/19.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: SampleModel = .init()
    
    var body: some View {
            NavigationView {
                VStack {
                    SearchBar("input repos name", text: $viewModel.searchText)
                    List (viewModel.items) { item in
                        Text(item.owner.login)
                        Text(item.fullName)
                    }.onDisappear {
                        self.viewModel.cancel()
                    }
                .navigationBarTitle(Text("Search Github Repos"), displayMode: .inline)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
