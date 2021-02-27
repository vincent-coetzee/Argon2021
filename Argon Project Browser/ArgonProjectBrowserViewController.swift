//
//  ArgonProjectBrowserViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/19.
//

import Cocoa

public class OutlinerController:NSViewController
    {
    }
    
public class FieldController:NSViewController
    {
    }
    
public class ArgonBrowserViewController: NSViewController,NSOutlineViewDataSource,NSOutlineViewDelegate
    {
    @IBOutlet var leftFieldView:FramingView!
    @IBOutlet var rightFieldView:FramingView!
    @IBOutlet var outliner:ArgonProjectOutlineView!
    @IBOutlet var containerView:FrameContainerView!
    
    private var currentController:NSViewController?
    private var popover:NSPopover?
    private var localBrowsables:[BrowsableItem] = []
    private var leftSplitView:NSSplitView = NSSplitView(frame:.zero)
    private var rightSplitView:NSSplitView = NSSplitView(frame:.zero)
    
    private var splitViewController = NSSplitViewController()

    private let paneView = PaneView(frame:.zero)
    
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
//        self.configureViews()
//        Module.initModules()
//        self.outliner.delegate = self
//        self.outliner.dataSource = self
//        self.outliner.action = #selector(onItemClicked)
//        Module.rootModule.buildSymbols()
//        self.localBrowsables = Module.rootModule.allSymbols as Array<BrowsableItem>
//        self.outliner.reloadData()
        self.containerView.removeFromSuperview()
        self.outliner.removeFromSuperview()
        self.leftFieldView.removeFromSuperview()
        self.rightFieldView.removeFromSuperview()
        self.view.addSubview(paneView)
        self.paneView.frame = self.view.bounds
        self.paneView.initDemoPanes()
        }
        
    public override func viewDidLayout()
        {
        super.viewDidLayout()
        self.paneView.frame = self.view.bounds
        }

    private func configureViews()
        {
        containerView.addChildView(Framer(self.outliner,inFrame:LayoutFrame(left:0,0,top:0,0,right:0.33,0,bottom: 1,0)))
        containerView.addChildView(Framer(self.leftFieldView,inFrame:LayoutFrame(left:0.33,0,top:0,0,right:0.66,0,bottom: 1,0)))
        containerView.addChildView(Framer(self.rightFieldView,inFrame:LayoutFrame(left:0.66,0,top:0,0,right:1,0,bottom: 1,0)))
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.blue.cgColor
        outliner.wantsLayer = true
        outliner.layer?.backgroundColor = NSColor.red.cgColor
        leftFieldView.wantsLayer = true
        leftFieldView.layer?.backgroundColor = NSColor.red.cgColor
        rightFieldView.wantsLayer = true
        rightFieldView.layer?.backgroundColor = NSColor.red.cgColor
//        outliner.translatesAutoresizingMaskIntoConstraints = false
//        outliner.widthAnchor.constraint(equalTo: self.leftFieldView.widthAnchor).isActive = true
//        outliner.widthAnchor.constraint(equalTo: self.rightFieldView.widthAnchor).isActive = true
//        leftFieldView.widthAnchor.constraint(equalTo: self.rightFieldView.widthAnchor).isActive = true
//        outliner.heightAnchor.constraint(greaterThanOrEqualToConstant: 400).isActive = true
//        outliner.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        outliner.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        leftFieldView.widthAnchor.constraint(equalTo: self.view.widthAnchor,multiplier: 0.3).isActive = true
//        leftFieldView.translatesAutoresizingMaskIntoConstraints = false
//        leftFieldView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        leftFieldView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        leftFieldView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400).isActive = true
//        rightFieldView.translatesAutoresizingMaskIntoConstraints = false
//        rightFieldView.widthAnchor.constraint(equalTo: self.view.widthAnchor,multiplier: 0.3).isActive = true
//        rightFieldView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        rightFieldView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        rightFieldView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400).isActive = true
//        splitViewController.splitView.translatesAutoresizingMaskIntoConstraints = false
//        splitViewController.splitView.dividerStyle = .paneSplitter
////        self.view.addSubview(splitViewController.splitView)
//        self.splitViewController.splitView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        self.splitViewController.splitView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        self.splitViewController.splitView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        self.splitViewController.splitView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        var controller:NSViewController = OutlinerController()
//        outliner.translatesAutoresizingMaskIntoConstraints = false
//        leftFieldView.translatesAutoresizingMaskIntoConstraints = false
//        rightFieldView.translatesAutoresizingMaskIntoConstraints = false
//        outliner.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
//        leftFieldView.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
//        rightFieldView.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
//        controller.view = outliner
//        splitViewController.splitView.addSubview(controller.view)
//        self.sizeView(outliner)
//        var item = NSSplitViewItem(viewController: controller)
//        splitViewController.addSplitViewItem(item)
//        controller = FieldController()
//        controller.view = leftFieldView
//        splitViewController.splitView.addSubview(controller.view)
//        self.sizeView(leftFieldView)
//        item = NSSplitViewItem(viewController: controller)
//        controller = FieldController()
//        controller.view = rightFieldView
//        splitViewController.splitView.addSubview(controller.view)
//        item = NSSplitViewItem(viewController: controller)
//        splitViewController.splitView.isVertical = true
//        self.sizeView(rightFieldView)
//        splitViewController.addSplitViewItem(item)
////        outliner.removeFromSuperview()
////        leftFieldView.removeFromSuperview()
////        rightFieldView.removeFromSuperview()
////        self.view.addSubview(leftSplitView)
////        self.view.addSubview(rightSplitView)
////        leftSplitView.delegate = self
////        rightSplitView.delegate = self
//        leftFieldView.wantsLayer = true
//        leftFieldView.layer?.backgroundColor = NSColor.argonLime.cgColor
//        rightFieldView.wantsLayer = true
//        rightFieldView.layer?.backgroundColor = NSColor.argonSeaGreen.cgColor
////        leftSplitView.translatesAutoresizingMaskIntoConstraints = false
////        rightSplitView.translatesAutoresizingMaskIntoConstraints = false
////        leftSplitView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
////        leftSplitView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
////        leftSplitView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
////        leftSplitView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
////        rightSplitView.isVertical = true
////        leftSplitView.addSubview(self.outliner)
////        leftSplitView.addSubview(self.leftFieldView)
////        leftSplitView.addSubview(self.rightFieldView)
////        leftSplitView.adjustSubviews()
////        leftSplitView.addArrangedSubview(rightSplitView)
////        rightSplitView.addArrangedSubview(leftFieldView)
////        rightSplitView.addArrangedSubview(rightFieldView)
        }
        
    private func sizeView(_ view:NSView)
        {
        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
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
        self.leftFieldView.contentView = editor
        editor.layout(inView:self.leftFieldView)
        leftFieldView.addSubview(editor)
        }
        
    public func outlineViewSelectionDidChange(_ notification: Notification)
        {
        let item = self.outliner.item(atRow: self.outliner.selectedRow)
        if item is Class
            {
            self.currentController = ClassSelectionViewController(nibName:"ClassSelectionViewController",bundle: nil)
            self.leftFieldView.addSubview(self.currentController!.view)
            self.currentController!.view.frame = self.leftFieldView.bounds
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

extension ArgonBrowserViewController:NSSplitViewDelegate
    {
    public func splitView(_ splitView: NSSplitView,constrainMaxCoordinate proposedMaximumPosition: CGFloat,ofSubviewAt dividerIndex: Int) -> CGFloat
        {
        return(proposedMaximumPosition)
        }
        
    public func splitView(_ splitView: NSSplitView,constrainMinCoordinate proposedMinimumPosition: CGFloat,ofSubviewAt dividerIndex: Int) -> CGFloat
        {
        return(proposedMinimumPosition)
        }
    }
