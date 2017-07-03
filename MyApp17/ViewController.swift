//
//  ViewController.swift
//  MyApp17
//
//  Created by user on 2017/7/3.
//  Copyright © 2017年 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let fmgr = FileManager.default
    let docDir = NSHomeDirectory() + "/Documents"

    @IBAction func btn1(_ sender: Any) {
        let dir1 = docDir + "/dir1"
        let dir2 = docDir + "/dir2"
        
        //  要用thorw的原因是會有錯誤發生可能有空間不足權限不足....等
        do{
            if fmgr.fileExists(atPath: dir2){
                try fmgr.removeItem(atPath: dir2)
            }
            
            try fmgr.copyItem(atPath: dir1, toPath: dir2)
        }catch{
            print(error)
        }
        
    }
    
    
    @IBAction func btn2(_ sender: Any) {
        let dir2 = docDir + "//dir1/dir2"
        let dir12 = docDir + "/dir1/dir3"
        //mv與rename是一樣到動做若目錄不同則mv若目錄相同則rename
        do{
            try fmgr.moveItem(atPath: dir2, toPath: dir12)
        }catch{
            print(error)
        }
        
    }
    
    
    @IBAction func btn3(_ sender: Any) {
        let file1 = docDir + "/dir1/read"
        let file2 = docDir + "/file2"
        do{
            try fmgr.moveItem(atPath: file1, toPath: file2)
        }catch{
            print(error)
        }
        
        //所有富含data的東西都可以用轉成data如string,UIImage...等等
        
        let newfile = docDir + "/pin.txt"
        if !fmgr.fileExists(atPath: newfile){
            let cont = "QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ"
            let contData = cont.data(using: .utf8)
            if fmgr.createFile(atPath: newfile, contents: contData, attributes: nil){
                print("OK")
            }else{
                print("NG")
            }
        }
        
    }
   
    
    @IBAction func btn4(_ sender: Any) {
        //建新檔或開就檔以及append data
        let file = docDir + "/pin2.txt"
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("pin2.txt")
        
        //這裡是extision write的方法
        if let outputStream = OutputStream(url: fileURL, append: true) {
            outputStream.open()
            let text = "some text\n"
            let bytesWritten = outputStream.write(text)
            if bytesWritten < 0 { print("write failure") }
            outputStream.close()
        } else {
            print("Unable to open file")
        }
    }
       @IBAction func btn5(_ sender: Any) {
        let file2 = docDir + "/pin03.txt"
        let cont = "12345678\ndddddddd\n"
        
        do{
            try cont.write(toFile: file2, atomically: true, encoding: .utf8)
        }catch{
            print(error)
        }
        
    }
    
   //save
    @IBAction func btn6(_ sender: Any) {
        let file2 = docDir + "/pin03.txt"
        let cont = TV.text
        
        do{
            try cont!.write(toFile: file2, atomically: true, encoding: .utf8)
        }catch{
            print(error)
        }
    }
    
    //clear
    @IBAction func btn7(_ sender: Any) {
        TV.text = ""
    }
   
    //read
    @IBAction func btn8(_ sender: Any) {
        let file2 = docDir + "/pin03.txt"
        do{
             let cont = try String(contentsOfFile: file2, encoding: .utf8)
            TV.text = cont

        }catch{
            
        }
       
    }
    @IBOutlet weak var TV: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn7(self)
        TV.layer.borderColor = UIColor.blue.cgColor
        TV.layer.borderWidth = 3.0
        print(docDir)
        var dir1 = docDir + "/dir1"
        if !fmgr.fileExists(atPath: dir1){
            do{
             try fmgr.createDirectory(atPath: dir1, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print(error)
            }
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension OutputStream {
    
    /// Write `String` to `OutputStream`
    ///
    /// - parameter string:                The `String` to write.
    /// - parameter encoding:              The `String.Encoding` to use when writing the string. This will default to `.utf8`.
    /// - parameter allowLossyConversion:  Whether to permit lossy conversion when writing the string. Defaults to `false`.
    ///
    /// - returns:                         Return total number of bytes written upon success. Return `-1` upon failure.
    
    func write(_ string: String, encoding: String.Encoding = .utf8, allowLossyConversion: Bool = false) -> Int {
        
        if let data = string.data(using: encoding, allowLossyConversion: allowLossyConversion) {
            return data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Int in
                var pointer = bytes
                var bytesRemaining = data.count
                var totalBytesWritten = 0
                
                while bytesRemaining > 0 {
                    let bytesWritten = self.write(pointer, maxLength: bytesRemaining)
                    if bytesWritten < 0 {
                        return -1
                    }
                    
                    bytesRemaining -= bytesWritten
                    pointer += bytesWritten
                    totalBytesWritten += bytesWritten
                }
                
                return totalBytesWritten
            }
        }
        
        return -1
    }
    
}
