//
//  ArgonProjectBrowserViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/19.
//

import Cocoa


public protocol ElementalSink
    {
    func setElemental(_ elemental:Elemental)
    }
    
public class ArgonBrowserViewController: NSViewController
    {
    public static var instance:ArgonBrowserViewController?
    
    @IBOutlet var splitView:NSSplitView!
    @IBOutlet var elementalBrowserController:ElementalBrowserViewController!
    
    private var selectedItem:Elemental?
    
    @IBOutlet var sourceViewController:SourceViewController!
        {
        didSet
           {
           ArgonBrowserViewController.instance?.elementalBrowserController.sink = self.sourceViewController
           }
        }
    
    @IBOutlet var container1:NSView!
    
    public func setSelectedElemental(_ item:Elemental)
        {
        self.view.window?.title = "Argon [ \(item.title) ]"
        }
        
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
            outlineItem.compile()
            elementalBrowserController.addBrowsableItem(outlineItem)
            self.selectedItem = outlineItem
            }
        }
        
    private func compileFile(atPath path:URL)
        {

        }
        
    @IBAction func onImportFile(_ sender:Any?)
        {
        }
        
    @IBAction func onCompileFile(_ sender:Any?)
        {
        }
        
    @IBAction func onSaveFile(_ sender:Any?)
        {
        self.selectedItem?.update(source:sourceViewController?.source)
        self.selectedItem?.save()
        }
        
    @IBAction func onSaveAs(_ sender:Any?)
        {
        }
        
    public override func viewDidLoad()
        {
        super.viewDidLoad()
        StylePalette.dumpAllFontNames()
        var size = 0.333 * self.view.bounds.size.width
        splitView.setPosition(size, ofDividerAt: 0)
        size = size + size
        splitView.setPosition(size, ofDividerAt: 1)
        ArgonBrowserViewController.instance = self
        }
    }

extension ArgonBrowserViewController:NSSplitViewDelegate
    {
    public func splitView(_ splitView: NSSplitView,constrainMaxCoordinate proposedMaximumPosition: CGFloat,ofSubviewAt dividerIndex: Int) -> CGFloat
        {
        let viewSize = self.view.bounds.size
        if proposedMaximumPosition > 0.66 * viewSize.width
            {
            return(0.66 * viewSize.width)
            }
        return(proposedMaximumPosition)
        }
        
    public func splitView(_ splitView: NSSplitView,constrainMinCoordinate proposedMinimumPosition: CGFloat,ofSubviewAt dividerIndex: Int) -> CGFloat
        {
        let viewSize = self.view.bounds.size
        if proposedMinimumPosition < 0.25 * viewSize.width
            {
            return(0.25 * viewSize.width)
            }
        return(proposedMinimumPosition)
        }
    }
