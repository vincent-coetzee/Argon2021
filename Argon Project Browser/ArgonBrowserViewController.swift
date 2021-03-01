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
    @IBOutlet var splitView:NSSplitView!
    @IBOutlet var elementalBrowserController:ElementalBrowserViewController!
    
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
            elementalBrowserController.addBrowsableItem(outlineItem)
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
        StylePalette.dumpAllFontNames()
        var size = 0.333 * self.view.bounds.size.width
        splitView.setPosition(size, ofDividerAt: 0)
        size = size + size
        splitView.setPosition(size, ofDividerAt: 1)
        }
    }

extension ArgonBrowserViewController:NSSplitViewDelegate
    {
    public func splitView(_ splitView: NSSplitView,constrainMaxCoordinate proposedMaximumPosition: CGFloat,ofSubviewAt dividerIndex: Int) -> CGFloat
        {
//        let viewSize = self.view.bounds.size
//        if proposedMaximumPosition > 0.66 * viewSize.width
//            {
//            return(0.66 * viewSize.width)
//            }
        return(proposedMaximumPosition)
        }
        
    public func splitView(_ splitView: NSSplitView,constrainMinCoordinate proposedMinimumPosition: CGFloat,ofSubviewAt dividerIndex: Int) -> CGFloat
        {
//        let viewSize = self.view.bounds.size
//        if proposedMinimumPosition < 0.25 * viewSize.width
        return(proposedMinimumPosition)
        }
    }
