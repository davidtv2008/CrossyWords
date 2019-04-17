//
//  PickerViewController.swift
//  CrossyWords
//
//  Created by Blanca Gutierrez on 4/3/19.
//  Copyright © 2019 Appility. All rights reserved.
//

import Foundation
import UIKit
import SQLite3

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()
    var selection: String = "New Puzzle"
    @IBOutlet var play: UIButton!
    
    //get the screen height to use to know when to delete buttons
    var screenSize = UIScreen.main.bounds
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    var fontSize = 0
    
    var db2:OpaquePointer? = nil
    var statement2: OpaquePointer?
    var finalDatabaseUrl2: URL!
    let databaseInMainBundleURL2 = Bundle.main.url(forResource: "puzzles", withExtension: "db")!
    
    
    override func viewDidLoad(){
        
        //first things first, determine devices screen dimensions
        //adjust buttons based on screen orientation on initial startup
        if UIDevice.current.orientation.isLandscape {
            screenSize = UIScreen.main.bounds
            screenWidth = screenSize.width
            screenHeight = screenSize.height
            
            if(screenHeight < screenWidth){
                let temp = screenHeight
                
                screenHeight = screenWidth
                screenWidth = temp
            }
            fontSize = Int(screenHeight / 55)
        } else {
            screenSize = UIScreen.main.bounds
            screenWidth = screenSize.width
            screenHeight = screenSize.height
            
            //screen mode is started in landscape mode, but is detected to be portrait
            if(screenHeight < screenWidth){
                let temp = screenHeight
                
                screenHeight = screenWidth
                screenWidth = temp
                
                fontSize = Int(screenHeight / 55)
            }
            else{
                //truly in landscape mode
                fontSize = Int(screenHeight / 55)
            }
        }
        
        play.titleLabel!.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
        
        
        
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        
        copyDatabaseIfNeeded("puzzles")
        // open database
        if sqlite3_open(finalDatabaseUrl2.path, &db2) != SQLITE_OK {
            //print("error opening db")
        }
        else{
            
        }
        
        pickerData.append("New Puzzle")
        
        //retrieve all dates from previous puzzles and add them to pickerview
        var queryStatement2 = ""
        
        queryStatement2 = "SELECT * FROM puzzle;"
        
        self.statement2 = nil
        if sqlite3_prepare_v2(self.db2,queryStatement2,-1,&self.statement2,nil) == SQLITE_OK{
            
            while(sqlite3_step(self.statement2) == SQLITE_ROW){
                let date = sqlite3_column_text(self.statement2,2)
                let comp = sqlite3_column_text(self.statement2,3)
                
                let dateString = String(cString: date!)
                let compString = String(cString: comp!)
                
                pickerData.append("\(dateString) - \(compString)")
            }
            //sqlite3_reset(self.statement2)
            sqlite3_finalize(self.statement2)
            
        }
    }
    
    func copyDatabaseIfNeeded(_ database: String) {
        
        //get users local device file path url
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return
        }
        
        //remove database file from path, then recopy the bundles version to make it up to date
        //only replace crosswords database, the puzzled.db will reside in users device to save puzzles
        //he has previously worked on
                    //this will be db url for accessing puzzles
            finalDatabaseUrl2 = documentsUrl.first!.appendingPathComponent("\(database).db")
            //do {
              //  try fileManager.removeItem(atPath: finalDatabaseUrl2.path)
            //} catch _ as NSError {
            //}
            
            if !( (try? finalDatabaseUrl2.checkResourceIsReachable()) ?? false) {
                let databaseInMainBundleURL2 = Bundle.main.resourceURL?.appendingPathComponent("\(database).db")
                
                do {
                    try fileManager.copyItem(atPath: (databaseInMainBundleURL2!.path), toPath: finalDatabaseUrl2.path)
                } catch _ as NSError {
                }
                
            } else {
                
            }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
    return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        selection = pickerData[row]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        sqlite3_close(db2)
        if segue.destination is ViewController
        {
            let vc = segue.destination as? ViewController
            vc?.selection = selection
        }
    }
    
}
