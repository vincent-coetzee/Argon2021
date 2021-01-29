//
//  AppDelegate.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/09.
//

import Cocoa
import BinaryCoding
@main
class AppDelegate: NSObject, NSApplicationDelegate
    {

    func applicationDidFinishLaunching(_ aNotification: Notification)
        {
        let sourceItem = SourceFolder(path:"/Users/vincent/Development/Development2021/Argon Projects/Medicine/")
        let item = sourceItem.children[0]
        let source = item.source
//        self.tokenStream.reset(source:source)
        Compiler.shared.compile(source: source)
        for module in Compiler.shared.modules
            {
            let encoder = BinaryEncoder()
            let encodedData = try! encoder.encode(module)
            let data = Data(encodedData.bytes)
            let fileURL = URL(fileURLWithPath: "/Users/vincent/Desktop/\(module.shortName).argonm")
            try! data.write(to: fileURL)
            }
        print("SUCCESSFULLY ENCODED AND WROTE OUT MODULE")
        Compiler.shared.modules = []
        let input = try! Data(contentsOf: URL(fileURLWithPath: "/Users/vincent/Desktop/Location.argonm"))
        let decoder = BinaryDecoder()
        let module = try! decoder.decode(Module.self, from: EncodedData(bytes: Array(input)))
        let symbols = module.symbolsKeyedById()
        module.relinkSymbolsUsingIds(symbols: symbols)
        print(module)
//        if let controller = NSStoryboard.main?.instantiateController(withIdentifier:"ArgonClassBrowserControllerID") as? NSWindowController
//            {
//            controller.showWindow(self)
//            }
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

