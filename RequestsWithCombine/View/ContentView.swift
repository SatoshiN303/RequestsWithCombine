//
//  ContentView.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/19.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = SampleModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText, placeholder: "Search Github")
                List (viewModel.items) { item in
                    Text(item.owner.login)
                    Text(item.fullName)
                }
            }.onDisappear {
                self.viewModel.cancel()
            }
            .navigationBarTitle(Text("Search Github Repos"), displayMode: .inline)
        }
    }
}


struct ContentView_Preiviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
