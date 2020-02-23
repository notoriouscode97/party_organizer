//
//  ArrayDataSource.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import RxSwift
import RxCocoa

class _RxTableViewReactiveArrayDataSource: NSObject, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func _tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _tableView(tableView, numberOfRowsInSection: section)
    }
    
    fileprivate func _tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        rxAbstractMethod()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return _tableView(tableView, cellForRowAt: indexPath)
    }
    
    func rxAbstractMethod(message: String = "Abstract method", file: StaticString = #file, line: UInt = #line) -> Swift.Never {
        rxFatalError(message, file: file, line: line)
    }
    
    func rxFatalError(_ lastMessage: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> Swift.Never  {
        // The temptation to comment this line is great, but please don't, it's for your own good. The choice is yours.
        fatalError(lastMessage(), file: file, line: line)
    }
}


class ArrayDataSource<S: Sequence>
    : RxTableViewReactiveArrayDataSource<S.Iterator.Element>
, RxTableViewDataSourceType {
    typealias Element = S
    
    override init(cellFactory: @escaping CellFactory) {
        super.init(cellFactory: cellFactory)
    }
    
    func tableView(_ tableView: UITableView, observedEvent: Event<S>) {
        Binder(self) { tableViewDataSource, sectionModels in
            let sections = Array(sectionModels)
            tableViewDataSource.tableView(tableView, observedElements: sections)
            }.on(observedEvent)
    }
}

// Please take a look at `DelegateProxyType.swift`
class RxTableViewReactiveArrayDataSource<Element>
    : _RxTableViewReactiveArrayDataSource
, SectionedViewDataSourceType {
    typealias CellFactory = (UITableView, Int, Element) -> UITableViewCell
    
    var itemModels: [Element]? = nil
    
    func modelAtIndex(_ index: Int) -> Element? {
        return itemModels?[index]
    }
    
    func model(at indexPath: IndexPath) throws -> Any {
        precondition(indexPath.section == 0)
        guard let item = itemModels?[indexPath.item] else {
            throw RxCocoaError.itemsNotYetBound(object: self)
        }
        return item
    }
    
    let cellFactory: CellFactory
    
    init(cellFactory: @escaping CellFactory) {
        self.cellFactory = cellFactory
    }
    
    override func _tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModels?.count ?? 0
    }
    
    override func _tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFactory(tableView, indexPath.item, itemModels![indexPath.row])
    }
    
    // reactive
    
    func tableView(_ tableView: UITableView, observedElements: [Element]) {
        self.itemModels = observedElements
        
        tableView.reloadData()
    }
}
