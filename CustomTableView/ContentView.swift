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
    func itemForRow(row: Int) -> String {
        return mutableData[row]
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

struct ContentView: View {
    
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
    
    func handleScroll(isScrolling: Bool) {
        withAnimation {
            self.isScrolling = isScrolling
        }
    }
    
    func loadIfNeeded(index: Int) {
        if index+5 > self.mutableData.count() && self.mutableData.count() < self.total && !self.isLoading {
            print("*** NEED TO SUPPLY MORE DATA ***")
            self.supplyMoreData()
        }
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
                    
                    TableView(dataSource: self.mutableData as TableViewDataSource, onScroll: self.handleScroll(isScrolling:), onAppear: self.loadIfNeeded(index:)) { (index) in
                        print("Tapped on record \(index)")
                        self.detailViewRow = index
                        self.detailViewActive.toggle()
                    }
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
