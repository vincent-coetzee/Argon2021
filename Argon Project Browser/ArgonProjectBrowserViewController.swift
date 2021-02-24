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
            self.compileFile(atPath: filename)
            }
        }
        
    private func compileFile(atPath path:URL)
        {
        let compiler = Compiler()
        if let source = try? String(contentsOf:path)
            {
            compiler.compile(source:source)
            self.outliner.reloadData()
                    SymbolWalker().walkSymbols(Module.rootModule)
            }
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
        Module.argonModule.initArgonModule()
        self.outliner.delegate = self
        self.outliner.dataSource = self
        self.outliner.reloadData()
        self.outliner.action = #selector(onItemClicked)
                Module.initModules()
        Module.rootModule.buildSymbols()
        let hierarchy = Module.rootModule.rootClass
        print(hierarchy)
        }

    @IBAction func onItemClicked(_ sender:Any?)
        {
        let clickedRow = self.outliner.clickedRow
        let item = self.outliner.item(atRow: clickedRow)
        let outlineItem = item as! OutlineItem
//        if outlineItem is Class
//            {
//            let view = self.outliner.view(atColumn: 0, row: clickedRow, makeIfNecessary: false)
//            let cell = view as! OutlineItemSymbolCell
//            self.popoverForType(at:cell.nameView)
//            }
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
            for item in Module.rootModule.allSymbols
                {
                print("\(item.shortName) \(Swift.type(of:item))")
                }
            return(Module.rootModule.childCount)
            }
        if let item = item as? OutlineItem
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
            return(Module.rootModule.child(at:index))
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
        
    public func popoverForType(at view:NSView)
        {
        self.popover = NSPopover()
        self.popover!.contentViewController = ClassSelectionViewController(nibName: "ClassSelectionViewController", bundle: nil)
        self.popover!.contentSize = NSSize(width:400,height:1100)
        self.popover!.show(relativeTo: view.bounds, of: view, preferredEdge: .maxX )
        }
    }
