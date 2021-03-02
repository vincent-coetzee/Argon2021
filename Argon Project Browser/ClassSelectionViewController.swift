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
            return(Module.rootModule.rootElementals.count)
            }
        if let item = item as? Elemental
            {
            return((item as! Symbol).allClasses.count)
            }
        return(0)
        }


    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
        {
        if item == nil
            {
            return(Module.rootModule.rootElementals[index])
            }
        let outlineItem = item as! Symbol
        return(outlineItem.allClasses[index])
        }

    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
        {
        if let outlineItem = item as? Elemental
            {
            return(!outlineItem.isExpandable)
            }
        return(false)
        }

    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView?
        {
        let outlineItem = item as! Elemental
        let cell = outlineItem.browserCell
        return(cell)
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
