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
            var lastModule:Module?
            var lastData:Data?
            Compiler.shared.compile(source: source)
            let modules = Compiler.shared.modules
            for module in modules
                {
                let moduleName = module.shortName
                let output = try NSKeyedArchiver.archivedData(withRootObject: module,requiringSecureCoding: false)
                lastData = output
                let fileURL = URL(fileURLWithPath: "/Users/vincent/Desktop/\(moduleName).arm")
                try output.write(to: fileURL)
                lastModule = module
                }
            let fullPath = "/Users/vincent/Desktop/Test.arp"
            let project = try ArgonProject(named: "Test.arp", at: fullPath)
            try? project.remove(atPath:fullPath)
            project.addFile(data:lastData!,at: lastModule!.shortName + ".arm")
            try project.write()
            }
        catch let error
            {
            print(error)
            }
        }
    
    func application(_ sender: NSApplication, openFiles filenames: [String])
        {
        guard filenames.count > 0 else
            {
            return
            }
        do
            {
            for name in filenames
                {
                let project = try ArgonProject(atPath: name)
                let keys = project.childFileKeys
                print(keys)
                }
            }
        catch let error
            {
            print("Error loading projects \(error)")
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

