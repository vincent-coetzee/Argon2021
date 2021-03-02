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
    
    private var elementals = Elementals()
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        self.outliner.delegate = self
        self.outliner.dataSource = self
        Module.initModules()
        self.elementals = Module.rootModule.elementals
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
        let item = self.outliner.item(atRow: clickedRow) as! Elemental
        self.selectedField.stringValue = item.title
        self.selectedField.textColor = item.elementalColor
//        let editor = item.editorCell
        }
        
    public func outlineView(_ tableView: NSOutlineView, rowViewForItem row: Any) -> NSTableRowView?
        {
        return RowView()
        }

    public func addBrowsableItem(_ item:Elemental)
        {
        self.elementals.append(item)
        self.outliner.reloadData()
        }
        
    public func outlineViewSelectionDidChange(_ notification: Notification)
        {
        let item = self.outliner.item(atRow: self.outliner.selectedRow)
        if item is Class
            {
            }
        }
        
    public func outlineView(_ outlineView: NSOutlineView,shouldEdit tableColumn: NSTableColumn?,item: Any) -> Bool
        {
        return(false)
        }
                     
    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
        {
        if item == nil
            {
            return(self.elementals.count)
            }
        if let item = item as? Elemental
            {
            return(item.childCount)
            }
        return(0)
        }
        

    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
        {
        if item == nil
            {
            return(self.elementals[index])
            }
        let outlineItem = item as! Elemental
        return(outlineItem[index])
        }

    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
        {
        if let outlineItem = item as? Elemental
            {
            return(outlineItem.isExpandable)
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
        let elemental = item as! Elemental
        if elemental.isSlot
            {
            return(ItemBrowserCell.kSlotRowHeight)
            }
        else
            {
            return(ItemBrowserCell.kRowHeight)
            }
        }
    }
