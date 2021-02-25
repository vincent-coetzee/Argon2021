//
//  ArgonProjectBrowserViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/19.
//

import Cocoa

public class ArgonBrowserViewController: NSViewController,NSOutlineViewDataSource,NSOutlineViewDelegate
    {
    @IBOutlet var fieldView:NSView!
    @IBOutlet var outliner:ArgonProjectOutlineView!
    
    private var currentController:NSViewController?
    private var popover:NSPopover?
    private var localBrowsables:[BrowsableItem] = []
    
    @IBAction func onNewFile(_ sender:Any?)
        {
        }
        
    @IBAction func onOpenFile(_ sender:Any?)
        {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["arm","arb","arp","argon"]
        let result = panel.runModal()
        guard result == .OK else
            {
            return
            }
        let filename = panel.url!
        let fileEnding =  (filename.path as NSString).pathExtension
        if fileEnding == "argon"
            {
            let outlineItem = ArgonFile(path: filename.path)
            self.localBrowsables.append(outlineItem)
            self.outliner.reloadData()
            }
        }
        
    private func compileFile(atPath path:URL)
        {

        }
        
    @IBAction func onSaveFile(_ sender:Any?)
        {
        }
        
    @IBAction func onSaveAs(_ sender:Any?)
        {
        }
        
    public override func viewDidLoad()
        {
        super.viewDidLoad()
        Module.initModules()
        self.outliner.delegate = self
        self.outliner.dataSource = self
        self.outliner.action = #selector(onItemClicked)
        Module.rootModule.buildSymbols()
        self.localBrowsables = Module.rootModule.allSymbols as Array<BrowsableItem>
        self.outliner.reloadData()
        }

    @IBAction func onItemClicked(_ sender:Any?)
        {
        let clickedRow = self.outliner.clickedRow
        guard clickedRow >= 0 else
            {
            return
            }
        let item = self.outliner.item(atRow: clickedRow)
        let outlineItem = item as! BrowsableItem
        let editor = outlineItem.editorCell
        editor.frame = self.fieldView.bounds
        fieldView.addSubview(editor)
        }
        
    public func outlineViewSelectionDidChange(_ notification: Notification)
        {
        let item = self.outliner.item(atRow: self.outliner.selectedRow)
        if item is Class
            {
            self.currentController = ClassSelectionViewController(nibName:"ClassSelectionViewController",bundle: nil)
            self.fieldView.addSubview(self.currentController!.view)
            self.currentController!.view.frame = self.fieldView.bounds
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
//        let row = outlineView.row(forItem:item)
//        if let cell = outlineView.view(atColumn: 0, row: row, makeIfNecessary: false),let aCell = cell as? OutlineItemCell
//            {
//            return(32)
//            }
        return(24)
        }
        
    public func popoverForType(at view:NSView)
        {
        self.popover = NSPopover()
        self.popover!.contentViewController = ClassSelectionViewController(nibName: "ClassSelectionViewController", bundle: nil)
        self.popover!.contentSize = NSSize(width:400,height:1100)
        self.popover!.show(relativeTo: view.bounds, of: view, preferredEdge: .maxX )
        }
    }
