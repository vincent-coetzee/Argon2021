//
//  OutlinerViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/07.
//

import Cocoa
    
class OutlinerViewController: NSViewController,NSOutlineViewDataSource,NSOutlineViewDelegate
    {
    @IBOutlet var outliner:NSOutlineView!
    
    public var rows:Array<RowWrapper> = []
    
    public init(rows:Array<RowWrapper>)
        {
        super.init(nibName:"OutlinerViewController",bundle:nil)
        let _ = self.view
        self.rows = rows
        self.outliner.reloadData()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        outliner.dataSource = self
        outliner.delegate = self
        self.outliner.reloadData()
        }
    
    public func outlineView(_ tableView: NSOutlineView, rowViewForItem row: Any) -> NSTableRowView?
        {
        return RowView()
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
        if let wrapper = item as? RowWrapper
            {
            Swift.print("item is \(wrapper) returning child count of \(wrapper.count)")
            return(wrapper.count)
            }
        Swift.print("item is nil returning child count of \(self.rows.count)")
        return(self.rows.count)
        }
        

    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
        {
        if let wrapper = item as? RowWrapper
            {
        print("row is \(wrapper) child at \(index) is \(wrapper.child(atIndex:index))")
            return(wrapper.child(atIndex:index))
            }
        print("item is \(item) child at \(index) is \(self.rows[index])")
        return(self.rows[index])
        }

    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
        {
        let wrapper = item as! RowWrapper
        print("item is \(wrapper) and isExpandable is \(wrapper.isExpandable)")
        return(wrapper.isExpandable)
        }

    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView?
        {
        let wrapper = item as! RowWrapper
        return(wrapper.rowView())
        }

    public func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat
        {
        let wrapper = item as! RowWrapper
        return(wrapper.rowHeight)
        }
    }
