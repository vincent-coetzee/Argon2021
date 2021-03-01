//
//  ElementalsBrowser.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/01.
//

import Cocoa

class ElementalBrowserViewController: NSViewController,NSOutlineViewDataSource,NSOutlineViewDelegate
    {
    @IBOutlet var outliner:NSOutlineView!
    @IBOutlet var selectedField:NSTextField!
    
    private var localBrowsables:[BrowsableItem] = []
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        self.outliner.delegate = self
        self.outliner.dataSource = self
        Module.initModules()
        Module.rootModule.buildSymbols()
        self.localBrowsables = Module.rootModule.allSymbols as Array<BrowsableItem>
        self.outliner.reloadData()
        (self.parent as! ArgonBrowserViewController).elementalBrowserController = self
        self.outliner.target = self
        self.outliner.action = #selector(onItemClicked)
        }
        
    @IBAction func onItemClicked(_ sender:Any?)
        {
        let clickedRow = self.outliner.clickedRow
        guard clickedRow >= 0 else
            {
            return
            }
        let item = self.outliner.item(atRow: clickedRow) as! BrowsableItem
        self.selectedField.stringValue = item.title
        let editor = item.editorCell
        }
        
    public func addBrowsableItem(_ item:BrowsableItem)
        {
        self.localBrowsables.append(item)
        self.outliner.reloadData()
        }
        
    public func outlineViewSelectionDidChange(_ notification: Notification)
        {
        let item = self.outliner.item(atRow: self.outliner.selectedRow)
        if item is Class
            {
            }
        }
        
    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
        {
        if item == nil
            {
            Module.rootModule.buildSymbols()
            return(self.localBrowsables.count)
            }
        if let item = item as? BrowsableItem
            {
            item.buildSymbols()
            return(item.childCount)
            }
        return(0)
        }
        

    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
        {
        if item == nil
            {
            return(self.localBrowsables[index])
            }
        let outlineItem = item as! BrowsableItem
        return(outlineItem.child(at:index))
        }

    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
        {
        if let outlineItem = item as? BrowsableItem
            {
            return(!outlineItem.isLeaf)
            }
        return(false)
        }

    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView?
        {
        let outlineItem = item as! BrowsableItem
        let cell = outlineItem.browserCell
        return(cell)
        }

    public func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat
        {
        if item is Slot
            {
            return(ItemBrowserCell.kSlotRowHeight)
            }
        else
            {
            return(ItemBrowserCell.kRowHeight)
            }
        }
    }
