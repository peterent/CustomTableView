//
//  ContentView.swift
//  CustomTableView
//
//  Created by Peter Ent on 12/4/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import SwiftUI


class MyData: TableViewDataSource, ObservableObject {
    @Published var mutableData = [String]()
    
    func count() -> Int {
        return mutableData.count
    }
    func titleForRow(row: Int) -> String {
        return mutableData[row]
    }
    func subtitleForRow(row: Int) -> String? {
        return "Something - Something"
    }
    init(_ someData: [String]) {
        mutableData.append(contentsOf: someData)
    }
    func append(contentsOf data: [String]) {
        mutableData.append(contentsOf: data)
    }
    func append(_ single: String) {
        mutableData.append(single)
    }
}

struct ContentView: View, TableViewDelegate {
    
    @ObservedObject var mutableData = MyData(["Apples", "Oranges", "Grapes", "Bananas"])
    @State var inputField: String = ""
    @State var isScrolling: Bool = false
    
    @State var detailViewActive = false
    @State var detailViewRow = 0
    @State var isLoading = false
        
    let total = 100
    
    func supplyMoreData() {
        isLoading = true
        var temp = [String]()
        for i in 0..<20 {
            temp.append("New Item \(mutableData.count() + i)")
        }
        mutableData.append(contentsOf: temp)
        isLoading = false
    }
        
    var body: some View {
        NavigationView {
            ZStack {
                
                NavigationLink(destination: DetailView(rowIndex: self.detailViewRow), isActive: self.$detailViewActive) {
                    EmptyView()
                }
                .frame(width: 0, height: 0)
                .disabled(true)
                .hidden()
                
                VStack {
                    TextField("Anything", text: Binding(get: {
                        return self.inputField
                    }, set: { (newValue) in
                        self.inputField = newValue
                        self.mutableData.append(newValue)
                    }))
                    
                    Divider()
                    
                    TableView(dataSource: self.mutableData as TableViewDataSource, delegate: self )
                }
                .padding()
                .edgesIgnoringSafeArea(.bottom)
                
                GeometryReader { proxy in
                    VStack {
                        Spacer()
                        Button("Select") {
                            // does nothing
                        }
                        .padding()
                        .frame(width: proxy.size.width - 32)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .shadow(radius: 14.0)
                        .opacity(self.isScrolling ? 0 : 1.0)
                    }
                }
            }.navigationBarTitle("UITableView")
        }
    }
    
    //MARK: - TableViewDelegate Functions
    
    func onScroll(_ tableView: TableView, isScrolling: Bool) {
        withAnimation {
            self.isScrolling = isScrolling
        }
    }
    
    func onAppear(_ tableView: TableView, at index: Int) {
        if index+5 > self.mutableData.count() && self.mutableData.count() < self.total && !self.isLoading {
            print("*** NEED TO SUPPLY MORE DATA ***")
            self.supplyMoreData()
        }
    }
    
    func onTapped(_ tableView: TableView, at index: Int) {
        print("Tapped on record \(index)")
        self.detailViewRow = index
        self.detailViewActive.toggle()
    }
    
    // this could be a view modifier but I do not think there is a way to read the view modifier
    // from a UIViewRepresentable (yet).
    func heightForRow(_ tableView: TableView, at index: Int) -> CGFloat {
        return 64.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
