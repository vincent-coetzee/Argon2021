//
//  AppDelegate.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/09.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate
    {

    func applicationDidFinishLaunching(_ aNotification: Notification)
        {
        let sourceItem = SourceFolder(path:"/Users/vincent/Development/Development2021/Argon Projects/Medicine/")
        let item = sourceItem.children[0]
        let source = item.source
        do
            {
            Compiler.shared.compile(source: source)
            let modules = Compiler.shared.modules
            for module in modules
                {
                let moduleName = module.shortName
                let output = try NSKeyedArchiver.archivedData(withRootObject: module,requiringSecureCoding: false)
                let fileURL = URL(fileURLWithPath: "/Users/vincent/Desktop/\(moduleName).arm")
                try output.write(to: fileURL)
                }
            }
        catch let error
            {
            print(error)
            }
        }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction
    func onNewProjectClicked(_ sender:Any?)
        {
        print("hello")
        }

    @IBAction
    func onOpenProjectClicked(_ sender:Any?)
        {
        print("hello")
        }
    }

