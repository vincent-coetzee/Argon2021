//
//  ClassSelectionViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/24.
//

import Cocoa

class ClassSelectionViewController: NSViewController,NSOutlineViewDataSource,NSOutlineViewDelegate
    {
    @IBOutlet var outliner:NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.outliner.delegate = self
        self.outliner.dataSource = self
        self.outliner.reloadData()
        // Do view setup here.
    }
        
    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
        {
        if item == nil
            {
            Module.rootModule.buildSymbols()
            return(1)
            }
        if let item = item as? OutlineItem
            {
            item.buildSymbols()
            return((item as! Symbol).allClasses.count)
            }
        return(0)
        }
        

    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
        {
        if item == nil
            {
            return(Module.rootModule.rootClass)
            }
        let outlineItem = item as! Symbol
        return(outlineItem.allClasses[index])
        }

    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
        {
        if let outlineItem = item as? OutlineItem
            {
            return(!outlineItem.isLeaf)
            }
        return(false)
        }

    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView?
        {
        let outlineItem = item as! OutlineItem
        let aClass = outlineItem.itemClass
        let symbol = outlineItem as! Symbol
        symbol.buildSymbols()
        let view = aClass.init(symbol:symbol)
        return(view)
        }

    public func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat
        {
//        let row = outlineView.row(forItem:item)
//        if let cell = outlineView.view(atColumn: 0, row: row, makeIfNecessary: false),let aCell = cell as? OutlineItemCell
//            {
//            return(32)
//            }
        return(24)
    }
    
}
