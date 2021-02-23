//
//  ArgonProjectBrowserViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/19.
//

import Cocoa

public class ArgonBrowserViewController: NSViewController,NSOutlineViewDataSource,NSOutlineViewDelegate
    {
    @IBOutlet var text:NSTextField!
    @IBOutlet var outliner:NSOutlineView!
    
    public override func viewDidLoad()
        {
        super.viewDidLoad()
        Module.argonModule.initArgonModule()
        self.outliner.delegate = self
        self.outliner.dataSource = self
        self.outliner.reloadData()
        }

    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
        {
        if item == nil
            {
            return(Module.rootModule.childCount)
            }
        if let item = item as? OutlineItem
            {
            return(item.childCount)
            }
        return(0)
        }
        

    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
        {
        if item == nil
            {
            return(Module.rootModule)
            }
        let outlineItem = item as! OutlineItem
        return(outlineItem.child(at:index))
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
        return(32)
        }
    }
