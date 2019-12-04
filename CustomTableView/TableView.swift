//
//  TableView.swift
//  CustomTableView
//
//  Created by Peter Ent on 12/4/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import SwiftUI

protocol TableViewDataSource {
    func count() -> Int
    func itemForRow(row: Int) -> String
}

struct TableView: UIViewRepresentable {
        
    var dataSource: TableViewDataSource
    var onScroll: ((Bool) -> Void)?
    var onAppear: ((Int) -> Void)?
    var onTapped: (Int) -> Void
    
    let tableView = UITableView()
    
    func makeCoordinator() -> TableView.Coordinator {
        Coordinator(self, onScroll: self.onScroll, onAppear: onAppear, onTapped: onTapped)
    }
    
    func makeUIView(context: Context) -> UITableView {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 60))
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        //
        uiView.delegate = context.coordinator
        uiView.dataSource = context.coordinator
        
        if context.coordinator.updateData(newData: self.dataSource) {
            uiView.reloadData()
        }
    }
    
    //MARK: - Coordinator
    
    class Coordinator: NSObject, UITableViewDelegate, UITableViewDataSource {
        
        var parent: TableView

        var mydata: TableViewDataSource?
        var onScroll: ((Bool) -> Void)?
        var onAppear: ((Int) -> Void)?
        var onTapped: (Int) -> Void
        
        var previousCount = 0
        
        init(_ parent: TableView, onScroll: ((Bool)->Void)?, onAppear: ((Int)->Void)?, onTapped: @escaping (Int)->Void) {
            self.parent = parent
            self.onScroll = onScroll
            self.onAppear = onAppear
            self.onTapped = onTapped
        }
        
        // This function determines if the table should refresh. It keeps track of the count of items and
        // returns true if the new data has a different count. Ideally, you'd compare the count but also
        // compare the items. This is crucial to avoid redrawing the screen whenever it scrolls.
        func updateData(newData: TableViewDataSource) -> Bool {
            if newData.count() != previousCount {
                mydata = newData
                previousCount = newData.count()
                return true
            }
            return false
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return mydata?.count() ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
            if let dataSource = mydata {
                cell.textLabel?.text = dataSource.itemForRow(row: indexPath.row)
                cell.accessoryType = .disclosureIndicator
                onAppear?(indexPath.row)
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            onTapped(indexPath.row)
        }
                
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            self.onScroll?(true)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            self.onScroll?(false)
        }
    }
}
