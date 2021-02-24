//
//  NewArgonClassWindowController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/24.
//

import Cocoa

class NewArgonClassWindowController: NSWindowController
    {
    @IBOutlet var nameField:NSTextField!
    @IBOutlet var customView:NSView!
    
    override func windowDidLoad()
        {
        super.windowDidLoad()
        let controller = ClassSelectionViewController(nibName:"ClassSelectionViewController",bundle:nil)
        controller.view.frame = self.customView.bounds
        customView.addSubview(controller.view)
        }
        
    func runModal(in window:NSWindow)
        {
        self.window?.makeKeyAndOrderFront(self)
        let session = NSApp.beginModalSession(for: self.window!)
        var result = NSApplication.ModalResponse.continue
        while (result == NSApplication.ModalResponse.continue)
            {
            result = NSApp.runModalSession(session)
            RunLoop.current.limitDate(forMode: RunLoop.Mode.default)
            }
        NSApp.endModalSession(session)
        }
    
}
