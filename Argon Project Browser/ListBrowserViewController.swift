//
//  ListsBrowserViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/01.
//

import Cocoa

class ListBrowserViewController: NSViewController,ElementalSink,NSOutlineViewDataSource,NSOutlineViewDelegate
    {
    @IBOutlet var inputField:NSTextField!
    @IBOutlet var outputField:NSTextField!
    @IBOutlet var outliner:NSOutlineView!
    
    private var elementals:Array<Elemental> = []
    
    public var sink:ElementalSink? = nil
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        // Do view setup here.
        self.elementals = []
        self.outliner.dataSource = self
        self.outliner.delegate = self
        self.outliner.target = self
        self.outliner.action = #selector(onItemClicked)
        }
    
    internal func setElemental(_ elemental:Elemental)
        {
        if elemental.isListable
            {
            self.inputField.stringValue = elemental.title
            self.inputField.textColor = elemental.textColor
            self.elementals = [elemental]
            self.outliner.reloadData()
            }
        }
        
        
    @IBAction func onItemClicked(_ sender:Any?)
        {
        let clickedRow = self.outliner.clickedRow
        guard clickedRow >= 0 else
            {
            return
            }
        let item = self.outliner.item(atRow: clickedRow) as! Elemental
        self.outputField.stringValue = item.title
        self.outputField.textColor = item.textColor
        self.sink?.setElemental(item)
        ArgonBrowserViewController.instance?.setSelectedElemental(item)
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
        let elemental = self.outliner.item(atRow: self.outliner.selectedRow) as! Elemental
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
            return(self.elementals[0])
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
        let cell = outlineItem.listCell
        return(cell)
        }

    public func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat
        {
        return(ItemBrowserCell.kRowHeight)
        }
    }
