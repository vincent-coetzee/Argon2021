//
//  ArgonProjectBrowserViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/19.
//

import Cocoa

class ArgonProjectBrowserViewController: NSViewController
    {
    @IBOutlet var browser:NSBrowser!
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        self.browser.setCellClass(IconTitleCell.self)
        self.browser.delegate = self
        }
    }
    
extension ArgonProjectBrowserViewController:NSBrowserDelegate
    {
    func rootItem(for: NSBrowser) -> Any?
        {
        Module.initModules()
        return(Module.rootModule)
        }
        
    func browser(_ browser: NSBrowser, numberOfChildrenOfItem item: Any?) -> Int
        {
        if item == nil
            {
            return(1)
            }
        else
            {
            let browserItem = item as! BrowserItem
            return(browserItem.childCount)
            }
        }
    func browser(_ browser:NSBrowser,willDisplayCell cell:Any, atRow row:Int,column:Int)
        {
        let item = browser.item(atRow: row, inColumn: column) as! BrowserItem
        let theCell = cell as! IconTitleCell
        theCell.image = item.image.resized(to: NSSize(width:64,height:64))
        theCell.stringValue = item.title
        }

    func browser(_ browser: NSBrowser, child index: Int, ofItem item: Any?) -> Any
        {
        if let browserItem = item as? BrowserItem
            {
            guard index < browserItem.childCount else
                {
                fatalError()
                }
            return(browserItem.child(at:index))
            }
        fatalError()
        }

    
    func browser(_ browser: NSBrowser, isLeafItem item: Any?) -> Bool
        {
        guard let browserItem = item as? BrowserItem else
            {
            fatalError()
            }
        return(browserItem.isLeaf)
        }

    

    func browser(_ browser: NSBrowser, objectValueForItem item: Any?) -> Any?
        {
        return((item as? BrowserItem)?.title)
        }

    func browser(_ browser: NSBrowser, heightOfRow row: Int, inColumn columnIndex: Int) -> CGFloat
        {
        return(64.0)
        }
    }
