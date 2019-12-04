//
//  DetailView.swift
//  CustomTableView
//
//  Created by Peter Ent on 12/4/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    var rowIndex: Int
    
    var body: some View {
        Text("This view shows the detail of a Thing on row \(rowIndex)")
        .navigationBarTitle("Detail")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(rowIndex: 0)
    }
}
