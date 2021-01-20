//
//  SearchBar.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/19.
//

import Foundation
import SwiftUI

struct SearchBar: UIViewRepresentable {

    private var delegate: SearchBarControl!

    var title: String?

    init(_ title: String?, text: Binding<String>) {
        self.title = title
        self.delegate = SearchBarControl(text)
    }

    func makeUIView(context: Context) -> UISearchBar  {
        let view = UISearchBar(frame: .zero)
        view.placeholder = self.title
        view.delegate = self.delegate
        return view
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
    }

    private class SearchBarControl: NSObject, UISearchBarDelegate {

        var text: Binding<String>

        init(_ text: Binding<String>) {
            self.text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.text.wrappedValue = searchBar.text ?? ""
        }
    }
}
