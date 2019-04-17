//
//  ViewController.swift
//  midtermExam
//
//  Created by David Toledo on 3/20/19.
//  Copyright © 2019 Appility. All rights reserved.
//

import UIKit
import QuartzCore
import SQLite3
import AVFoundation

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var gridView: UIView!
    var prevCenterx: CGFloat = 0.0
    var prevCentery: CGFloat = 0.0
    @IBOutlet weak var letterStack: UIStackView!
    
    var selection: String = ""
    var paused: Bool = false
    @IBOutlet var mainMenuButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var giveUpButton: UIButton!
    @IBOutlet var resumeButton: UIButton!
    
    //var newPuzzleSolution: String = ""
    var solutionString: String = ""
    var puzzleString: String = ""
    @IBOutlet var statusLabel: UILabel!
    
    var drawing = Draw()
    var cells: [[UIButton]] = []
    var inputLetters: [UIButton] = []
    var activeCell: UIButton?
    var nextCell: UIButton?
    var indexy: Int = 0
    var indexx: Int = 0
    var nextIndex: [Int] = [0,0]
    var alreadyBlockedIndex: [Int] = []
    var timesSelected: Int = 0
    var direction: String = "r"
    var lastSender: UIButton!
    
    //reveal the answer timer
    var revealTimer: Timer!
    var timeSpent: Timer!
    var time: Int = 0
    @IBOutlet var timeLabel: UILabel!
    var found: Bool = false

    
    //get the screen height to use to know when to delete buttons
    var screenSize = UIScreen.main.bounds
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    var buttonSize: CGFloat = 0
    //fontSize based on screenHeight
    var fontSize = 0
    
    //locater, zoom back to original size
    
    //timerIndexes
    var ty = 0
    var tx = 0
    var ts = 0

    
    //database pointers
    var db:OpaquePointer? = nil
    var statement: OpaquePointer?
    //finalDatabaseURL is used to reference db
    var finalDatabaseUrl: URL!
    //dictionary db file location
    let databaseInMainBundleURL = Bundle.main.url(forResource: "crossywords", withExtension: "db")!
    
    var db2:OpaquePointer? = nil
    var statement2: OpaquePointer?
    
    var finalDatabaseUrl2: URL!
    let databaseInMainBundleURL2 = Bundle.main.url(forResource: "puzzles", withExtension: "db")!
    
    //store words query results here
    var words: [[String]] = []
    var definitions: [[String]] = []
    var wordLength: Int = 11
    var puzzleWordsToUse: [String] = []
    var puzzleWordsDefinitionToUse: [String] = []
    var duplicatedWords: [String] = []
    var solution: [String] = []
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var defLabel: UILabel!
    @IBOutlet var locButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    
    //grid of 5 columns x 5 rows
    @IBOutlet var r0c0: UIButton!
    @IBOutlet var r0c1: UIButton!
    @IBOutlet var r0c2: UIButton!
    @IBOutlet var r0c3: UIButton!
    @IBOutlet var r0c4: UIButton!
    @IBOutlet var r0c5: UIButton!
    @IBOutlet var r0c6: UIButton!
    @IBOutlet var r0c7: UIButton!
    @IBOutlet var r0c8: UIButton!
    @IBOutlet var r0c9: UIButton!
    @IBOutlet var r0c10: UIButton!
    @IBOutlet var r0c11: UIButton!
    @IBOutlet var r0c12: UIButton!
    
    
    @IBOutlet var r1c0: UIButton!
    @IBOutlet var r1c1: UIButton!
    @IBOutlet var r1c2: UIButton!
    @IBOutlet var r1c3: UIButton!
    @IBOutlet var r1c4: UIButton!
    @IBOutlet var r1c5: UIButton!
    @IBOutlet var r1c6: UIButton!
    @IBOutlet var r1c7: UIButton!
    @IBOutlet var r1c8: UIButton!
    @IBOutlet var r1c9: UIButton!
    @IBOutlet var r1c10: UIButton!
    @IBOutlet var r1c11: UIButton!
    @IBOutlet var r1c12: UIButton!
    
    
    @IBOutlet var r2c0: UIButton!
    @IBOutlet var r2c1: UIButton!
    @IBOutlet var r2c2: UIButton!
    @IBOutlet var r2c3: UIButton!
    @IBOutlet var r2c4: UIButton!
    @IBOutlet var r2c5: UIButton!
    @IBOutlet var r2c6: UIButton!
    @IBOutlet var r2c7: UIButton!
    @IBOutlet var r2c8: UIButton!
    @IBOutlet var r2c9: UIButton!
    @IBOutlet var r2c10: UIButton!
    @IBOutlet var r2c11: UIButton!
    @IBOutlet var r2c12: UIButton!
    
    @IBOutlet var r3c0: UIButton!
    @IBOutlet var r3c1: UIButton!
    @IBOutlet var r3c2: UIButton!
    @IBOutlet var r3c3: UIButton!
    @IBOutlet var r3c4: UIButton!
    @IBOutlet var r3c5: UIButton!
    @IBOutlet var r3c6: UIButton!
    @IBOutlet var r3c7: UIButton!
    @IBOutlet var r3c8: UIButton!
    @IBOutlet var r3c9: UIButton!
    @IBOutlet var r3c10: UIButton!
    @IBOutlet var r3c11: UIButton!
    @IBOutlet var r3c12: UIButton!
    
    @IBOutlet var r4c0: UIButton!
    @IBOutlet var r4c1: UIButton!
    @IBOutlet var r4c2: UIButton!
    @IBOutlet var r4c3: UIButton!
    @IBOutlet var r4c4: UIButton!
    @IBOutlet var r4c5: UIButton!
    @IBOutlet var r4c6: UIButton!
    @IBOutlet var r4c7: UIButton!
    @IBOutlet var r4c8: UIButton!
    @IBOutlet var r4c9: UIButton!
    @IBOutlet var r4c10: UIButton!
    @IBOutlet var r4c11: UIButton!
    @IBOutlet var r4c12: UIButton!
    
    @IBOutlet var r5c0: UIButton!
    @IBOutlet var r5c1: UIButton!
    @IBOutlet var r5c2: UIButton!
    @IBOutlet var r5c3: UIButton!
    @IBOutlet var r5c4: UIButton!
    @IBOutlet var r5c5: UIButton!
    @IBOutlet var r5c6: UIButton!
    @IBOutlet var r5c7: UIButton!
    @IBOutlet var r5c8: UIButton!
    @IBOutlet var r5c9: UIButton!
    @IBOutlet var r5c10: UIButton!
    @IBOutlet var r5c11: UIButton!
    @IBOutlet var r5c12: UIButton!
    
    @IBOutlet var r6c0: UIButton!
    @IBOutlet var r6c1: UIButton!
    @IBOutlet var r6c2: UIButton!
    @IBOutlet var r6c3: UIButton!
    @IBOutlet var r6c4: UIButton!
    @IBOutlet var r6c5: UIButton!
    @IBOutlet var r6c6: UIButton!
    @IBOutlet var r6c7: UIButton!
    @IBOutlet var r6c8: UIButton!
    @IBOutlet var r6c9: UIButton!
    @IBOutlet var r6c10: UIButton!
    @IBOutlet var r6c11: UIButton!
    @IBOutlet var r6c12: UIButton!
    
    @IBOutlet var r7c0: UIButton!
    @IBOutlet var r7c1: UIButton!
    @IBOutlet var r7c2: UIButton!
    @IBOutlet var r7c3: UIButton!
    @IBOutlet var r7c4: UIButton!
    @IBOutlet var r7c5: UIButton!
    @IBOutlet var r7c6: UIButton!
    @IBOutlet var r7c7: UIButton!
    @IBOutlet var r7c8: UIButton!
    @IBOutlet var r7c9: UIButton!
    @IBOutlet var r7c10: UIButton!
    @IBOutlet var r7c11: UIButton!
    @IBOutlet var r7c12: UIButton!
    
    @IBOutlet var r8c0: UIButton!
    @IBOutlet var r8c1: UIButton!
    @IBOutlet var r8c2: UIButton!
    @IBOutlet var r8c3: UIButton!
    @IBOutlet var r8c4: UIButton!
    @IBOutlet var r8c5: UIButton!
    @IBOutlet var r8c6: UIButton!
    @IBOutlet var r8c7: UIButton!
    @IBOutlet var r8c8: UIButton!
    @IBOutlet var r8c9: UIButton!
    @IBOutlet var r8c10: UIButton!
    @IBOutlet var r8c11: UIButton!
    @IBOutlet var r8c12: UIButton!
    
    @IBOutlet var r9c0: UIButton!
    @IBOutlet var r9c1: UIButton!
    @IBOutlet var r9c2: UIButton!
    @IBOutlet var r9c3: UIButton!
    @IBOutlet var r9c4: UIButton!
    @IBOutlet var r9c5: UIButton!
    @IBOutlet var r9c6: UIButton!
    @IBOutlet var r9c7: UIButton!
    @IBOutlet var r9c8: UIButton!
    @IBOutlet var r9c9: UIButton!
    @IBOutlet var r9c10: UIButton!
    @IBOutlet var r9c11: UIButton!
    @IBOutlet var r9c12: UIButton!
    
    @IBOutlet var r10c0: UIButton!
    @IBOutlet var r10c1: UIButton!
    @IBOutlet var r10c2: UIButton!
    @IBOutlet var r10c3: UIButton!
    @IBOutlet var r10c4: UIButton!
    @IBOutlet var r10c5: UIButton!
    @IBOutlet var r10c6: UIButton!
    @IBOutlet var r10c7: UIButton!
    @IBOutlet var r10c8: UIButton!
    @IBOutlet var r10c9: UIButton!
    @IBOutlet var r10c10: UIButton!
    @IBOutlet var r10c11: UIButton!
    @IBOutlet var r10c12: UIButton!
    
    @IBOutlet var r11c0: UIButton!
    @IBOutlet var r11c1: UIButton!
    @IBOutlet var r11c2: UIButton!
    @IBOutlet var r11c3: UIButton!
    @IBOutlet var r11c4: UIButton!
    @IBOutlet var r11c5: UIButton!
    @IBOutlet var r11c6: UIButton!
    @IBOutlet var r11c7: UIButton!
    @IBOutlet var r11c8: UIButton!
    @IBOutlet var r11c9: UIButton!
    @IBOutlet var r11c10: UIButton!
    @IBOutlet var r11c11: UIButton!
    @IBOutlet var r11c12: UIButton!
    
    @IBOutlet var r12c0: UIButton!
    @IBOutlet var r12c1: UIButton!
    @IBOutlet var r12c2: UIButton!
    @IBOutlet var r12c3: UIButton!
    @IBOutlet var r12c4: UIButton!
    @IBOutlet var r12c5: UIButton!
    @IBOutlet var r12c6: UIButton!
    @IBOutlet var r12c7: UIButton!
    @IBOutlet var r12c8: UIButton!
    @IBOutlet var r12c9: UIButton!
    @IBOutlet var r12c10: UIButton!
    @IBOutlet var r12c11: UIButton!
    @IBOutlet var r12c12: UIButton!
    
    @IBOutlet var a: UIButton!
    @IBOutlet var b: UIButton!
    @IBOutlet var c: UIButton!
    @IBOutlet var d: UIButton!
    @IBOutlet var e: UIButton!
    @IBOutlet var f: UIButton!
    @IBOutlet var g: UIButton!
    @IBOutlet var h: UIButton!
    @IBOutlet var i: UIButton!
    @IBOutlet var j: UIButton!
    @IBOutlet var k: UIButton!
    @IBOutlet var l: UIButton!
    @IBOutlet var m: UIButton!
    @IBOutlet var n: UIButton!
    @IBOutlet var o: UIButton!
    @IBOutlet var p: UIButton!
    @IBOutlet var q: UIButton!
    @IBOutlet var r: UIButton!
    @IBOutlet var s: UIButton!
    @IBOutlet var t: UIButton!
    @IBOutlet var u: UIButton!
    @IBOutlet var v: UIButton!
    @IBOutlet var w: UIButton!
    @IBOutlet var x: UIButton!
    @IBOutlet var y: UIButton!
    @IBOutlet var z: UIButton!
    @IBOutlet var del: UIButton!
    @IBOutlet var menu: UIButton!
    
    
    var solutionWordIndex: [String: Int] = [:]
    var index: Int = 0
    
    var pickerData: [String] = [String]()
    var queryTable: String = "simpleWordList"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(selection)
        
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
            //determine sizes based on screen
            buttonSize = CGFloat(Int(screenWidth) / 6)
            
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
                //determine sizes based on screen
                buttonSize = CGFloat(Int(screenWidth) / 6)
                
            }
            else{
                //truly in landscape mode
                fontSize = Int(screenHeight / 55)
                //determine sizes based on screen
                buttonSize = CGFloat(Int(screenWidth) / 6)
            }
        }
        
        gridView.isUserInteractionEnabled = true
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        view.addGestureRecognizer(pinchGesture)
        
        let moveGesture = UIPanGestureRecognizer(target: self, action: #selector(self.moveGesture))
        view.addGestureRecognizer(moveGesture)
        //moveGesture.delegate = self
        
        //since I am making no use of auto layouts
        //i will assign everything a potision
        let viewRect = view.frame
        
        gridView.frame = CGRect(x: 0, y: 0, width: viewRect.width, height: viewRect.height)
        

        defLabel.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
        locButton.titleLabel!.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
        menuButton.titleLabel!.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
        mainMenuButton.titleLabel!.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
        saveButton.titleLabel!.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
        giveUpButton.titleLabel!.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
        resumeButton.titleLabel!.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
        
        
        //defLabel.textColor = UIColor.white
        
        
        //make sure the device contains our bundled dictionary db from which all words will be
        //used to build the puzzle
        copyDatabaseIfNeeded("crossywords")
        // open database
        if sqlite3_open(finalDatabaseUrl.path, &db) != SQLITE_OK {
            //debugLabel.text = "error opening db"
        }
        else{
            
        }
        
        copyDatabaseIfNeeded("puzzles")
        // open database
        if sqlite3_open(finalDatabaseUrl2.path, &db2) != SQLITE_OK {
            //debugLabel.text = "error opening db"
        }
        else{
            
        }
        
        //load all buttons into array to easily control access them
        appendTextFields()
        //print(selection)
        if(selection == "New Puzzle"){
            //print("new puzzle")
            queryTable = "commonWords"
            wordsToUse()
        }
        else{
            //print("load puzzle")
            loadSavedPuzzle()
        }
        
        //determine what words will be used in the puzzle
        //wordsToUse()
        
        //make it preety
        prepareGrid()
        
        //store the solution to verify at end of game
        if(selection == "New Puzzle"){
            storeSolution()
            clearAllWords()
        }
        
        //clear all text from grid, to start game
        
        
        //make first cell active in case user doesnt select any cells
        //and simply clicks on a letter on initial game launch
        cells[nextIndex[0]][nextIndex[1]].isSelected = true
        lastSender = cells[nextIndex[0]][nextIndex[1]]
        //directionLabel.text = "r"
        
        let indexLookup = solutionWordIndex["00r"]
        
        if (indexLookup == nil){
            defLabel.text = "No word in this direction"
            
        }
        else{
            defLabel.text = puzzleWordsDefinitionToUse[indexLookup!]
            
            
        }
        
        //change color of all columns to the right to indicate direction in which the player is typing
        var j = 0
        while(j < cells.count){
            if(cells[0][j].isEnabled){
                cells[0][j].backgroundColor = UIColor.green
                
            }
            else{
                break;
            }
            j += 1
        }
        
        gridView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        //make sure menu is
        mainMenuButton.alpha = 0
        saveButton.alpha = 0
        giveUpButton.alpha = 0
        resumeButton.alpha = 0
        
        timeLabel.text = String(time)
        
        //start the user timer
        timeSpent = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeTrack), userInfo: nil, repeats: true)
    }
    
    func loadSavedPuzzle(){
        
        //_ = ""
        solutionString = ""
        var puzzleResult = ""
        
        var queryStatement2 = ""
        
        selection = String(selection.prefix(10))
        
        //print(selection)
        
        queryStatement2 = "SELECT * FROM puzzle WHERE dateCreated = '\(selection)';"
        
        self.statement2 = nil
        if sqlite3_prepare_v2(self.db2,queryStatement2,-1,&self.statement2,nil) == SQLITE_OK{
            
            if(sqlite3_step(self.statement2) == SQLITE_ROW){
                let sol = sqlite3_column_text(self.statement2,0)
                let puz = sqlite3_column_text(self.statement2,1)
                //let date = sqlite3_column_text(self.statement2,3)
                let timeSpent = sqlite3_column_int(self.statement2,4)

                
                solutionString = String(cString: sol!)
                puzzleResult = String(cString: puz!)
                time = Int(timeSpent)
            }
        }
        
        sqlite3_reset(self.statement2)
        sqlite3_finalize(self.statement2)
        
        
        //retrieve all keyvalues pairs
        solutionWordIndex.removeAll()
        queryStatement2 = "SELECT * FROM keyvalue WHERE date = '\(selection)';"
        
        self.statement2 = nil
        if sqlite3_prepare_v2(self.db2,queryStatement2,-1,&self.statement2,nil) == SQLITE_OK{
            
            while(sqlite3_step(self.statement2) == SQLITE_ROW){
                let key = sqlite3_column_text(self.statement2,0)
                let val = sqlite3_column_int(self.statement2,1)
                //print("key: \(key!) value: \(val)")
                solutionWordIndex[String(cString: key!)] = Int(val)
            }
        }
        
        sqlite3_reset(self.statement2)
        sqlite3_finalize(self.statement2)
        
        
        
        //retrieve all definitions pairs
        puzzleWordsDefinitionToUse.removeAll()
        var tempDefs: [String] = []
        var tempDefsInd: [Int] = []
        
        queryStatement2 = "SELECT * FROM definition WHERE date = '\(selection)';"
        
        self.statement2 = nil
        if sqlite3_prepare_v2(self.db2,queryStatement2,-1,&self.statement2,nil) == SQLITE_OK{
            
            while(sqlite3_step(self.statement2) == SQLITE_ROW){
                let def = sqlite3_column_text(self.statement2,0)
                let val = sqlite3_column_int(self.statement2,1)
                tempDefs.append(String(cString: def!))
                tempDefsInd.append(Int(val))
                //puzzleWordsDefinitionToUse.append(String(cString: def!))
                //solutionWordIndex[String(cString: key!)] = Int(val)
            }
        }
        
        puzzleWordsDefinitionToUse = tempDefs
        
        for i in tempDefsInd{
            puzzleWordsDefinitionToUse[i] = tempDefs[i]
        }
        
        
        sqlite3_reset(self.statement2)
        sqlite3_finalize(self.statement2)
        
        //print(puzzleWordsDefinitionToUse)
        //print(solutionWordIndex)
        
        if(solutionString == puzzleResult){
            statusLabel.textColor = UIColor.green
            statusLabel.text = "Complete!"
            
        }
        //place solution in each cell
        var charSolution = Array(solutionString)
        
        //give all cells a rounded shape and shadow effect
        var i = 0
        var j = 0
        var k = 0
        while(i < cells.count){
            while(j < cells.count){
                //print("characters in solution: \(charSolution.count) k: \(k) i: \(i) j: \(j)")
                if(String(charSolution[k]) == "_"){
                    cells[i][j].setTitle("",for: .normal)
                    cells[i][j].isEnabled = false
                    cells[i][j].alpha = 0
                    solution.append(String(charSolution[k]))
                }else{
                    cells[i][j].setTitle(String(charSolution[k]), for: .normal)
                    cells[i][j].isEnabled = true
                    solution.append(String(charSolution[k]))
                }
                j += 1
                k += 1
            }
            i += 1
            j = 0
        }
        
        
        var lastState = Array(puzzleResult)
        //print(lastState.count)
        //print(solutionResult.count)
        //restore previously entered characters from last game attemp
        i = 0
        j = 0
        k = 0
        while(i < cells.count){
            while(j < cells.count){
                //print("characters from last state: \(lastState[k]) k: \(k) i: \(i) j: \(j)")
                cells[i][j].setTitle(String(lastState[k]), for: .normal)
                j += 1
                k += 1
            }
            i += 1
            j = 0
        }
        
        //sqlite3_close(db2)
    }
    
    @objc func timeTrack(){
        time += 1
        timeLabel.text = String(time)
    }
    
    @objc func pinchGesture(sender: UIPinchGestureRecognizer){
        //print(paused)
        if(!paused){
            gridView.transform = (gridView.transform.scaledBy(x: sender.scale, y: sender.scale))
            sender.scale = 1
        }
    }
    
    @objc func moveGesture(gestureRecognizer: UIPanGestureRecognizer) {
        if(!paused){
            if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
                let translation = gestureRecognizer.translation(in: self.view)
                gridView.center = CGPoint(x: gridView.center.x + translation.x, y: gridView.center.y + translation.y)
                
                //gridView.center = CGPoint(x: gridView.center.x + translation.x, y: gridView.center.y + translation.y)
                gestureRecognizer.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
            }
            
        }
        
    }
    
    @IBAction func savePuzzle(){
        
        var key: [String] = []
        var value: [Int] = []
        
        for (_, element) in solutionWordIndex.enumerated(){
            key.append(element.key)
            value.append(element.value)
        }
        
        if sqlite3_open(finalDatabaseUrl2.path, &db2) != SQLITE_OK {
            //debugLabel.text = "error opening db"
        }
        else{
            
        }
    
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy"
        let formattedDate = format.string(from: date)
        //print(formattedDate)
        
        
        //check if a puzzle already exists with the current date, if so update it, replacing
        //previous puzzle saved, only 1 puzzle save per day.
        
        var exists = false
        var queryStatement2 = ""
        
        if(selection == "New Puzzle"){
            queryStatement2 = "SELECT * FROM puzzle WHERE dateCreated = '\(formattedDate)';"
        }
        else{
            selection = String(selection.prefix(10))
            queryStatement2 = "SELECT * FROM puzzle WHERE dateCreated = '\(selection)';"
        }
        
        self.statement2 = nil
        if sqlite3_prepare_v2(self.db2,queryStatement2,-1,&self.statement2,nil) == SQLITE_OK{
            
            if(sqlite3_step(self.statement2) == SQLITE_ROW){
                exists = true
            }
        }
        
        sqlite3_reset(self.statement2)
        sqlite3_finalize(self.statement2)
        
        //get the timer the puzzle has been worked on so far
        //store the current state of the puzzle in a string
        //store the answer puzzle as a string
        //store the date the puzzle was played
        //1 puzzle per day
        puzzleString = ""
        var rw = 0
        var co = 0
        while (rw < cells.count){
            while(co < cells.count){
                if(!cells[rw][co].isEnabled){
                    //print("row: \(rw) col: \(co)")
                    puzzleString += "_"
                }
                else{
                    //print("row: \(rw) col: \(co)")
                    puzzleString += cells[rw][co].title(for: UIControl.State.normal)!
                }
                co += 1
            }
            rw += 1
            co = 0
        }
        
        //print(puzzleString.count)
        //print(puzzleString)
        
        /*for x in cells{
            for y in x{
                if(!y.isEnabled){
                    puzzleString += "_"
                }
                else{
                    puzzleString += y.title(for: UIControl.State.normal)!
                }
            }
        }*/
        
        solutionString = ""
        for x in solution{
            solutionString += x
        }
        
        //print(solutionString.count)
        //print(solutionString)
        
        
        //check if puzzle is completed
        var completed = "Pending"
        if(solutionString == puzzleString){
            statusLabel.textColor = UIColor.green
            statusLabel.text = "Complete!"
            completed = "Completed"
        }
        
        queryStatement2 = ""
        
        if(exists){
            
            if(selection == "New Puzzle"){
                queryStatement2 = "UPDATE puzzle SET solution = '\(solutionString)', puzzleString = '\(puzzleString)', completed = '\(completed)', time = '\(self.time)' WHERE dateCreated = '\(formattedDate)';"
            }
            else{
                queryStatement2 = "UPDATE puzzle SET solution = '\(solutionString)', puzzleString = '\(puzzleString)', completed = '\(completed)', time = '\(self.time)' WHERE dateCreated = '\(selection)';"
            }
            
            self.statement2 = nil
            if sqlite3_prepare_v2(self.db2,queryStatement2,-1,&self.statement2,nil) == SQLITE_OK{
                if(sqlite3_step(self.statement2) == SQLITE_DONE){
                    //print("sqlite done saving puzzle solution and string")
                    //sqlite3_finalize(self.statement)
                }
                else{
                    //print("Trouble saving puzzle")
                    //sqlite3_finalize(self.statement)
                }
            }
            else{
                //print("test")
            }
            
            sqlite3_reset(self.statement2)
            sqlite3_finalize(self.statement2)
            
            queryStatement2 = ""
            
            if(selection == "New Puzzle"){
                queryStatement2 = "DELETE FROM keyvalue WHERE date = '\(formattedDate)';"
            }
            else{
                queryStatement2 = "DELETE FROM keyvalue WHERE date = '\(selection)';"
            }
            
            self.statement2 = nil
            if sqlite3_prepare_v2(self.db2,queryStatement2,-1,&self.statement2,nil) == SQLITE_OK{
                if(sqlite3_step(self.statement2) == SQLITE_DONE){
                    //print("sqlite done removing keyvalue and definitions")
                    //sqlite3_finalize(self.statement)
                }
                else{
                    //print("Trouble saving puzzle")
                    //sqlite3_finalize(self.statement)
                }
            }
            else{
                //print("error deleting keyvalues")
            }
            
            sqlite3_reset(self.statement2)
            sqlite3_finalize(self.statement2)
            
            queryStatement2 = ""
            
            queryStatement2 = "DELETE FROM definition WHERE date = ?;"
            
            self.statement2 = nil
            if sqlite3_prepare_v2(self.db2,queryStatement2,-1,&self.statement2,nil) == SQLITE_OK{
                
                if(selection == "New Puzzle"){
                    sqlite3_bind_text(self.statement2,1,formattedDate,-1,nil)
                }
                else{
                    sqlite3_bind_text(self.statement2,1,selection,-1,nil)
                }
                
                if(sqlite3_step(self.statement2) == SQLITE_DONE){
                    //print("sqlite done removing definitions")
                    //sqlite3_finalize(self.statement)
                }
                else{
                    //print("Trouble saving puzzle")
                    //sqlite3_finalize(self.statement)
                }
            }
            else{
                //print("error deleting definitions")
            }
            
            var i = 0
            for x in key{
                sqlite3_reset(self.statement2)
                sqlite3_finalize(self.statement2)
                
                queryStatement2 = ""
                
                if(selection == "New Puzzle"){
                    queryStatement2 = "INSERT INTO keyvalue VALUES('\(x)','\(value[i])','\(formattedDate)');"
                }
                else{
                    queryStatement2 = "INSERT INTO keyvalue VALUES('\(x)','\(value[i])','\(selection)');"
                }
                
                self.statement2 = nil
                if sqlite3_prepare_v2(self.db2,queryStatement2,-1,&self.statement2,nil) == SQLITE_OK{
                    
                    if(sqlite3_step(self.statement2) == SQLITE_DONE){
                        //print("sqlite done saving puzzle")
                        //sqlite3_finalize(self.statement)
                    }
                    else{
                        //print("Trouble saving puzzle")
                        //sqlite3_finalize(self.statement)
                    }
                }
                else{
                    //print("test")
                }
                i += 1
            }
            
            
            i = 0
            for y in puzzleWordsDefinitionToUse{
                sqlite3_reset(self.statement2)
                sqlite3_finalize(self.statement2)
                
                queryStatement2 = ""
                
                //queryStatement2 = "INSERT INTO definition VALUES('\(y)','\(i)','\(formattedDate)');"
                queryStatement2 = "INSERT INTO definition(def,ind,date) VALUES(?,?,?);"
                
                self.statement2 = nil
                if sqlite3_prepare_v2(self.db2,queryStatement2,-1,&self.statement2,nil) == SQLITE_OK{
                    
                    let def: NSString = y as NSString
                    
                    sqlite3_bind_text(self.statement2,1,def.utf8String,-1,nil)
                    //print("binding \(y)")
                    sqlite3_bind_int(self.statement2, 2, Int32(i))
                    
                    if(selection == "New Puzzle"){
                        sqlite3_bind_text(self.statement2,3,formattedDate,-1,nil)
                        
                    }
                    else{
                        sqlite3_bind_text(self.statement2,3,selection,-1,nil)
                        
                    }
                    
                    if(sqlite3_step(self.statement2) == SQLITE_DONE){
                        //print("sqlite done saving puzzle")
                        //sqlite3_finalize(self.statement)
                    }
                    else{
                        //print("Trouble saving puzzle")
                        //sqlite3_finalize(self.statement)
                    }
                }
                else{
                    //print("test")
                }
                i += 1
            }
        }
        else{ //new puzzle, do not update only insert
            if(selection == "New Puzzle"){
                queryStatement2 = "INSERT INTO puzzle VALUES('\(solutionString)','\(puzzleString)','\(formattedDate)','\(completed)','\(self.time)');"
                
            }
            else{
                queryStatement2 = "INSERT INTO puzzle VALUES('\(solutionString)','\(puzzleString)','\(selection)','\(completed)','\(self.time)');"
                
            }
            
            self.statement2 = nil
            if sqlite3_prepare_v2(self.db2,queryStatement2,-1,&self.statement2,nil) == SQLITE_OK{
                
                if(sqlite3_step(self.statement2) == SQLITE_DONE){
                    //print("sqlite done saving puzzle")
                    //sqlite3_finalize(self.statement)
                }
                else{
                    //print("Trouble saving puzzle")
                    //sqlite3_finalize(self.statement)
                }
            }
            else{
                //print("test")
            }
        
            sqlite3_reset(self.statement2)
            sqlite3_finalize(self.statement2)
            
            var i = 0
            for x in key{
            
            queryStatement2 = ""
            
                if(selection == "New Puzzle"){
                    queryStatement2 = "INSERT INTO keyvalue VALUES('\(x)','\(value[i])','\(formattedDate)');"
                    
                }
                else{
                    queryStatement2 = "INSERT INTO keyvalue VALUES('\(x)','\(value[i])','\(selection)');"
                    
                }
            
            self.statement2 = nil
            if sqlite3_prepare_v2(self.db2,queryStatement2,-1,&self.statement2,nil) == SQLITE_OK{
                
                if(sqlite3_step(self.statement2) == SQLITE_DONE){
                    //print("sqlite done saving puzzle")
                    //sqlite3_finalize(self.statement)
                }
                else{
                    //print("Trouble saving puzzle")
                    //sqlite3_finalize(self.statement)
                }
            }
            else{
                //print("test")
            }
                i += 1
                sqlite3_reset(self.statement2)
                sqlite3_finalize(self.statement2)
            }
            
            
            i = 0
            var defsToInsert: [String] = []
            for y in puzzleWordsDefinitionToUse{
                defsToInsert.append(y)
            }
            
            for z in defsToInsert{
                
                
                queryStatement2 = ""
                self.statement2 = nil
                
                queryStatement2 = "INSERT INTO definition(def,ind,date) VALUES(?,?,?);"
                //print(y)
                
                if sqlite3_prepare_v2(self.db2,queryStatement2,-1,&self.statement2,nil) == SQLITE_OK{
                    let def: NSString = z as NSString
                    sqlite3_bind_text(self.statement2,1,def.utf8String,-1,nil)
                    sqlite3_bind_int(self.statement2,2,Int32(i))
                    
                    if(selection == "New Puzzle"){
                        sqlite3_bind_text(self.statement2,3,formattedDate,-1,nil)
                        
                    }
                    else{
                        sqlite3_bind_text(self.statement2,3,selection,-1,nil)
                        
                    }
                    
                    
                    if(sqlite3_step(self.statement2) == SQLITE_DONE){
                        //print("sqlite done saving puzzle")
                        //sqlite3_finalize(self.statement)
                    }
                    else{
                        //print("Trouble saving puzzle")
                        //sqlite3_finalize(self.statement)
                    }
                }
                else{
                    //print("test insert into definitions")
                }
                i += 1
                
                sqlite3_reset(self.statement2)
                sqlite3_finalize(self.statement2)
            }
        }
        
        //sqlite3_reset(self.statement2)
        ///sqlite3_finalize(self.statement2)
        
        //close database if moving to another view
        //sqlite3_close(db)
        //sqlite3_close(db2)
        defLabel.text = "Puzzle saved"
        
        
        
        resumeAfterSave()
        
        
    }
    
    func resumeAfterSave(){
        if(paused){
            
            //start the user timer
            timeSpent = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeTrack), userInfo: nil, repeats: true)
            
            //if currently paused, unpause and reveal all blocks
            
            paused = false
            for x in cells{
                for y in x{
                    if(y.isEnabled){
                        y.alpha = 1
                    }
                    
                }
            }
            
            defLabel.alpha = 0.7
            mainMenuButton.alpha = 0
            saveButton.alpha = 0
            giveUpButton.alpha = 0
            resumeButton.alpha = 0
        }
    }
    
    @IBAction func mainMenu(){
        
        sqlite3_close(db)
        sqlite3_close(db2)
        //switch to main menu view
        performSegue(withIdentifier: "mainMenuSegue", sender: nil)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return nil
        //return imgPhoto
    }
    
    @IBAction func showHint(){
        if(!paused){
            if(defLabel.alpha >= 0.6){
                defLabel.alpha = 0
            }
            else if(defLabel.alpha <= 0){
                defLabel.alpha = 0.7
            }
            
        }
        
    }
    
    @IBAction func solvePuzzleAction(){
        solvePuzzleTimer()
    }
    
    func solvePuzzleTimer(){
        
        //reset the timer index for revealing the answers 1 letter at a time
        ty = 0
        tx = 0
        ts = 0
        
        revealTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(reveal), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func reveal(){
        
        //if(cells[ty][tx].isEnabled){
            cells[ty][tx].setTitle(solution[ts], for: .normal)
            ts += 1
        //}
        
        tx += 1
        
        if(tx == cells.count){
            ty += 1
            tx = 0
            
            if(ty == cells.count){
                //stop and remove the timer
                revealTimer.invalidate()
                
            }
        }
    }
    
    @IBAction func pauseMenu(){
        if(paused){
            
            //start the user timer
            timeSpent = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeTrack), userInfo: nil, repeats: true)
            
            //if currently paused, unpause and reveal all blocks
            
            paused = false
            for x in cells{
                for y in x{
                    if(y.isEnabled){
                            y.alpha = 1
                    }
                    
                }
            }
            
            defLabel.alpha = 0.7
            mainMenuButton.alpha = 0
            saveButton.alpha = 0
            giveUpButton.alpha = 0
            resumeButton.alpha = 0
        }
        else{
            //if not paused, pause it and remove all blocks
            timeSpent.invalidate()
            paused = true
            for x in cells{
                for y in x{
                    if(y.isEnabled){
                        y.alpha = 0.2
                    }
 //                   y.alpha = 0.2
                }
            }
            defLabel.alpha = 0.2
            mainMenuButton.alpha = 0.7
            saveButton.alpha = 0.7
            resumeButton.alpha = 0.7
            //giveUpButton.alpha = 0.7
            
        }
        
    
    }
    
    func clearAllWords(){
        var i = 0
        var j = 0
        while(i < cells.count){
            while(j < cells.count){
                cells[i][j].setTitle(" ", for: .normal)
                j += 1
            }
            i += 1
            j = 0
        }
    }
    
    func storeSolution(){
        
        var i = 0
        var j = 0
        while(j < cells.count){
            while(j < cells.count){
                if(cells[i][j].isEnabled){
//                    solution.append(cells[i][j].title(for: UIControl.State.normal) ?? "_")
                }
                solution.append(cells[i][j].title(for: UIControl.State.normal) ?? "_")
                j += 1
            }
            i += 1
            j = 0
            if(i == cells.count){
                break
            }
        }
        
        for x in solution{
            solutionString += x
        }
        //print(solutionString)
    }
    
    
    @IBAction func locate(){
        if(!paused){
            gridView.center = view.center
            gridView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
        }
        
    }
    
    //handle the screenrotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            
            screenSize = UIScreen.main.bounds
            screenWidth = screenSize.width
            screenHeight = screenSize.height
            
            if(screenHeight < screenWidth){
                let temp = screenHeight
                
                screenHeight = screenWidth
                screenWidth = temp
                
                
                //gridView.frame = CGRect(x: 0, y: 0, width: screenHeight, height:  screenWidth)
            }
            else{
                //gridView.frame = CGRect(x: 0, y: 0, width: screenHeight, height:  screenWidth)
            }
            
            //fontSize = Int(screenHeight / 55)
            
            var i = 0
            var j = 0
            while(i < cells.count){
                while(j < cells.count){
                    cells[i][j].titleLabel!.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
                    j += 1
                }
                i += 1
                j = 0
            }
            
            
            
            
            defLabel.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
            
            
            for x in inputLetters{
                x.titleLabel!.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
            }
            
            //gridView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            
            
            //locate()
            //gridView.center = view.center
            //gridView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            //gridView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            
        } else {
            
            //gridView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            //fontSize = Int(screenHeight / 55)
            
            
            var i = 0
            var j = 0
            while(i < cells.count){
                while(j < cells.count){
                    cells[i][j].titleLabel!.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
                    
                    j += 1
                }
                i += 1
                j = 0
            }
            
            
            for x in inputLetters{
                x.titleLabel!.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
            }
            
            defLabel.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
            
            //gridView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            
            
            //locate()
            //gridView.center = view.center
            //gridView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
        }
            
    }
    
    
    func wordsToUse(){
        
        
        //FILL IN WORDS OF RANDOM LENGTH HORIZONTALLY
        //MAKE OUR WAY DOWN TO EVEN ROWS
        //ROWS: 0, 2, 4, 6, 8, 10***************************************************
        var i = 0
        var j = 0
        var limit = 0
        //var next = 0
        //var position = 0
        var previous = 0
        
        //go down through each even row
        while(i < cells.count){
            
            
            //print("i index: \(i) j index: \(j) limit: \(limit)")
            //find the limit of what our character length can be
            while(limit < cells.count - previous){
                if(cells[i][limit].isEnabled == false){
                    break
                }
                limit += 1
                if(limit == cells.count){
                    //limit -= 1
                    break
                }
            }
            
            //print("limit spaces available: \(limit)")
            var wordLength = 0
            if(limit == 2){
                wordLength = 2
            }
            else if(limit > 11 && selection == "New Puzzle"){
                wordLength = Int.random(in: 11 ..< 14)
            }
            else{
                wordLength = Int.random(in: 11 ..< 14)
            }
            
            //get a word of random length
            //and insert into cells up to the limit slot
            var queryStatement = ""
            
            queryStatement = "SELECT * FROM \(queryTable) WHERE LENGTH(word) = ? COLLATE NOCASE;"
            
            
            var wordQuery = ""
            var defQuery = ""
            self.statement = nil
            if sqlite3_prepare_v2(self.db,queryStatement,-1,&self.statement,nil) == SQLITE_OK{
            
                sqlite3_bind_int(self.statement,1,Int32(wordLength))
            
                found = false
                while(sqlite3_step(self.statement) == SQLITE_ROW){
                    found = true
                    let word = sqlite3_column_text(self.statement,0)
                    let def = sqlite3_column_text(self.statement,1)
                
                    let wordFound = String(cString: word!).uppercased()
                    wordQuery = wordFound
                    //print(wordQuery)
                    let defFound = String(cString: def!)
                    //print(wordFound)
                    words[wordLength - 1].append(wordFound)
                    duplicatedWords.append(wordFound)
                    definitions[wordLength - 1].append(defFound)
            }
            if(found){
                //print("words found: \(words[wordLength - 1].count) i: \(i) j: \(j)")
                var randomWordIndex = 0
                if(words[wordLength - 1].count == 1){
                    randomWordIndex = 0
                }
                else{
                    randomWordIndex = Int.random(in: 0 ..< words[wordLength - 1].count - 1)
                }
                wordQuery = words[wordLength - 1][randomWordIndex]
                defQuery = definitions[wordLength - 1][randomWordIndex]
                
                //print("word to be used")
            
            var lookEnd = 0
            if(words[wordLength - 1].count > 1){
                while(puzzleWordsToUse.contains(wordQuery)){
                    randomWordIndex = Int.random(in: 0 ..< words[wordLength - 1].count - 1)
                    wordQuery = words[wordLength - 1][randomWordIndex]
                    defQuery = definitions[wordLength - 1][randomWordIndex]
                    lookEnd += 1
                    if(lookEnd == 10){
                        break;
                    }
                }
            }
            
            //print("wordQuery: \(wordQuery)")
            puzzleWordsToUse.append(wordQuery)
            puzzleWordsDefinitionToUse.append(defQuery)
            words[wordLength - 1].removeAll()
            definitions[wordLength - 1].removeAll()
            }
        }
        sqlite3_finalize(self.statement)
        self.statement = nil
        
        if(found == true){
            
            var wordChars = Array(wordQuery)
            var cellx = j
            let celly = i
            
            var insertIndex = 0
            while(insertIndex < wordChars.count){
                cells[celly][cellx].setTitle(String(wordChars[insertIndex]),for: .normal)
                ///print(cells[celly][cellx].title(for: UIControl.State.normal)!)
                cells[celly][cellx].isEnabled = true
                
                //add keyvalue pair of solution word based on where the word was insert
                let sy = String(celly)
                let sx = String(cellx)
                let dir = "r"
                let id = sy + sx + dir
                
                solutionWordIndex[id] = index
                
                //after inserting a word, remove the preceding block
                if(insertIndex == wordChars.count - 1){
                    let k = cellx + 1
                    if(k < cells.count){
                        cells[celly][k].isEnabled = false
                        cells[celly][k].alpha = 0
                    }
                }
                insertIndex += 1
                cellx += 1
            }
            index += 1
            j = cellx + 1
            previous = j
            
            if(j >= cells.count - 1){
                if(j == cells.count - 1){
                    cells[celly][j].isEnabled = false
                    cells[celly][j].alpha = 0
                }
                i += 2
                previous = 0
                j = 0
            }
            limit = 0
        }
        
            //if not word fuund do this
            found = false
        
    }
        
        
        
        
        //FILL IN WORDS VERTICALLY THAT CONTAIN ALL OF THE LETTERS THAT ARE ALREADY ON GRID
        //EXAMPLE: A_P_E, USING MYSQL QUERY 'SELECT FROM ENTRIES WHERE WORD LIKE "A_P_E",
        //SHOULD RETURN ALL WORDS THAT MATCH THIS CRITERIA, EXAMPLE HERE WOULD RETURN APPLE.
        //IF NO RETURN RESULT, ADJUST THE EXPRESSION BY SHORTENING BY 2 CHARS EACH TIME NO MATCH IS FOUND
        //A_P AND SO ON ...
        //MAKE OUR WAY RIGHT TO EVEN ROWS AND REPEAT PROCEDURE
        //COLUMNS: 0, 2, 4, 6, 8, 10***************************************************
        
        i = 0
        j = 0
        limit = 0
        //next = 0
        var start = 0
        var end = cells.count - 1
        //position = 0
        previous = 0
        
        var possibleWord = ""
        var defQuery = ""
        
        while( i < cells.count){
            
        possibleWord = ""
        start = i
        //create the word up too the end position
        while(start < end + 1){
            if(cells[start][j].title(for: UIControl.State.normal) == ""){
                possibleWord += "_"
            }
            else if(cells[start][j].isEnabled == false){
                possibleWord += "-"
            }
            else{
                possibleWord += cells[start][j].title(for: UIControl.State.normal) ?? "_"
            }
            start += 1
            if(start == cells.count){
                break;
            }
        }
        
        //query to see if the possibleWord is found, if not shorten the expression
        var queryStatement = ""
        
        queryStatement = "SELECT * FROM \(queryTable) WHERE word like ? COLLATE NOCASE;"
            
            
            
        var wordQuery = ""
        self.statement = nil
        if sqlite3_prepare_v2(self.db,queryStatement,-1,&self.statement,nil) == SQLITE_OK{
            
            sqlite3_bind_text(self.statement,1,possibleWord,-1,nil)
            
            found = false
            while(sqlite3_step(self.statement) == SQLITE_ROW){
                found = true
                let word = sqlite3_column_text(self.statement,0)
                let def = sqlite3_column_text(self.statement,1)
                
                let wordFound = String(cString: word!).uppercased()
                wordQuery = wordFound
                let defFound = String(cString: def!)
                wordLength = wordFound.count
                words[wordLength - 1].append(wordFound)
                definitions[wordLength - 1].append(defFound)
                
            }
            if(found){
                var randomWordIndex = 0
                if(words[wordLength - 1].count == 1){
                    randomWordIndex = 0
                }
                else{
                    randomWordIndex = Int.random(in: 0 ..< words[wordLength - 1].count - 1)
                }
                wordQuery = words[wordLength - 1][randomWordIndex]
                defQuery = definitions[wordLength - 1][randomWordIndex]
                
                //break the loop after 10 attempts to find a unique word
                //it may not exist, oh well, must use duplicate word
                var lookEnd = 0
                if(words[wordLength - 1].count > 1){
                    while(puzzleWordsToUse.contains(wordQuery)){
                        randomWordIndex = Int.random(in: 0 ..< words[wordLength - 1].count)
                        wordQuery = words[wordLength - 1][randomWordIndex]
                        defQuery = definitions[wordLength - 1][randomWordIndex]
                        lookEnd += 1
                        if(lookEnd == 10){
                            break;
                        }
                    }
                }
                
                
                puzzleWordsToUse.append(wordQuery)
                puzzleWordsDefinitionToUse.append(defQuery)
                words[wordLength - 1].removeAll()
                definitions[wordLength - 1].removeAll()
            }
            else{
                wordQuery = ""
            }
            
        }
        sqlite3_finalize(self.statement)
        self.statement = nil
        
        if(found == false){
            if(end - 1 <= i){
                i = end + 1
                if(i >= cells.count){
                    
                }
            }
            else if(cells[end - 1][j].isEnabled == false){
                end -= 1
                if(end - 1 <= i){
                    //done, move to next position
                    i = end + 1
                    if(i >= cells.count){
                    }
                }
            }
            else{
                end -= 2
                if(end - 1 <= i){
                    //done move to next position
                    
                    i = end + 2
                    end = cells.count - 1
                }
            }
        }
        else{
            //word is found, insert the word
            
            //insert the word into the grid
            var k = i
            let foundWord = Array(wordQuery)
            for x in foundWord{
                cells[k][j].setTitle(String(x), for: .normal)
                
                //add keyvalue pair of solution word based on where the word was insert
                let sy = String(k)
                let sx = String(j)
                let dir = "d"
                let id = sy + sx + dir
                //print("key: \(id) value: \(index)")
                
                solutionWordIndex[id] = index
                
                k += 1
            }
            index += 1
            i = end + 2
            end = cells.count - 1
            
        }
            if(i >= 11){
                i = 0
                j += 2
                
                if(j >= cells.count){
                    break;
                }
            }
        }
        
        
        //ONCE ALL EVEN ROWS AND COLUMNS HAVE WORDS PLACED,
        //GO THROUGH ALL ODD COLUMNS AND ODD ROWS, STARTING POINT IS 1,1. TRY TO FIND A POSSIBLE WORD TO FIT
        //LOOK AT 2 LETTERS ON TOP, LOOK AT LEFT, LOOK AT RIGHT, LOOK BELOW 2 LETTERS
        //FROM A REG EXPRESSION WITH THE LETTER ON TOP, AND THE LETTER BELOW, AS LONG AS IT DOES NOT CONTAIN
        //CHARACTERS 2 LETTERS UP AND 2 DOWN.
        i = 1
        j = 1
        var left = 0
        var charLeft = ""
        var left2x = 0
        var right = 0
        var charRight = ""
        var right2x = 0
        var down = 0
        var down2x = 0
        var charDown2x = ""
        var up = 0
        var charUp = ""
        var up2x = 0
        var charUp2x = ""
        
        while(i < cells.count){
            
        while(j < cells.count){
            
            left = j - 1
            left2x = j - 2
            right = j + 1
            right2x = j + 2
            down = i + 1
            down2x = i + 2
            up = i - 1
            up2x = i - 2
        
            if(i == 1){
                up2x = i - 1
            }
            if(i == cells.count - 2){
                down2x = i + 1
            }
            if(j == 1){
                left2x = j - 1
            }
            if(j == cells.count - 2){
                right2x = j + 1
            }
            
            charDown2x = cells[down2x][j].title(for: UIControl.State.normal) ?? ""
            charUp2x = cells[up2x][j].title(for: UIControl.State.normal) ?? ""
            if(i == 1){
                charUp2x = ""
            }
            charLeft = cells[i][left].title(for: UIControl.State.normal) ?? ""
            charRight = cells[i][right].title(for: UIControl.State.normal) ?? ""
            
        
            if(charLeft == "" && charRight == "" && charDown2x == "" && charUp2x == ""){
                //query to find a 3 letter word to fit in
                let char1 = cells[up][j].title(for: UIControl.State.normal) ?? "-"
                let char2 = "_"
                let char3 = cells[down][j].title(for: UIControl.State.normal) ?? "-"
                
                var queryNewWord = ""
                
                
                if(char1 != "-"){
                    queryNewWord += char1
                }
                queryNewWord += char2
                if(char3 != "-"){
                    queryNewWord += char3
                }
                
                if(char1 == "-" && char3 == "-"){
                    queryNewWord = ""
                }
                
                if(queryNewWord.count > 0){
                    //query to see if the possibleWord is found
                    var queryStatement = ""
                    
                    queryStatement = "SELECT * FROM \(queryTable) WHERE word like ? COLLATE NOCASE;"
                    
                    
                    var wordQuery = ""
                    self.statement = nil
                    if sqlite3_prepare_v2(self.db,queryStatement,-1,&self.statement,nil) == SQLITE_OK{
                    
                    sqlite3_bind_text(self.statement,1,queryNewWord,-1,nil)
                    
                    found = false
                    while(sqlite3_step(self.statement) == SQLITE_ROW){
                        found = true
                        let word = sqlite3_column_text(self.statement,0)
                        let def = sqlite3_column_text(self.statement,1)
                        
                        let wordFound = String(cString: word!).uppercased()
                        wordQuery = wordFound
                        let defFound = String(cString: def!)
                        wordLength = wordFound.count
                        words[wordLength - 1].append(wordFound)
                        definitions[wordLength - 1].append(defFound)
                        
                    }
                    if(found){
                        var randomWordIndex = 0
                        if(words[wordLength - 1].count == 1){
                            randomWordIndex = 0
                        }
                        else{
                            randomWordIndex = Int.random(in: 0 ..< words[wordLength - 1].count - 1)
                        }
                        wordQuery = words[wordLength - 1][randomWordIndex]
                        defQuery = definitions[wordLength - 1][randomWordIndex]
                        
                        //break the loop after 10 attempts to find a unique word
                        //it may not exist, oh well, must use duplicate word
                        var lookEnd = 0
                        if(words[wordLength - 1].count > 1){
                            while(puzzleWordsToUse.contains(wordQuery)){
                                randomWordIndex = Int.random(in: 0 ..< words[wordLength - 1].count)
                                wordQuery = words[wordLength - 1][randomWordIndex]
                                defQuery = definitions[wordLength - 1][randomWordIndex]
                                lookEnd += 1
                                if(lookEnd == 10){
                                    break;
                                }
                            }
                        }
                        
                        puzzleWordsToUse.append(wordQuery)
                        puzzleWordsDefinitionToUse.append(defQuery)
                        words[wordLength - 1].removeAll()
                        definitions[wordLength - 1].removeAll()
                        
                        var queryArray = Array(wordQuery)
                        
                        var p = 0
                        var pos = 0
                        
                        if(cells[up][j].isEnabled == false){
                                p = 1
                        }
                        
                        
                        while(p < wordLength){
                            cells[up + p][j].setTitle(String(queryArray[pos]),for: .normal)
                            
                            //add keyvalue pair of solution word based on where the word was insert
                            let sy = String(up + p)
                            let sx = String(j)
                            let dir = "d"
                            let id = sy + sx + dir
                            //print("key: \(id) value: \(index)")
                            
                            solutionWordIndex[id] = index
                            
                            //cells[up + p][j].backgroundColor = UIColor.red
                            pos += 1
                            p += 1
                        }
                        index += 1
                    }
                    else{
                        wordQuery = ""
                    }
                    
                }
                sqlite3_finalize(self.statement)
                self.statement = nil
            }
                
            }
            j += 2
            if(j >= cells.count){
                i += 2
                if(i >= cells.count){
                    break
                }
                j = 1
            }
        }
        }
        
        
        //ONCE ALL EVEN ROWS AND COLUMNS HAVE WORDS PLACED,
        //GO THROUGH ALL ODD COLUMNS AND ODD ROWS, STARTING POINT IS 1,1. TRY TO FIND A POSSIBLE WORD TO FIT
        //LOOK AT 2 LETTERS ON TOP, LOOK AT LEFT, LOOK AT RIGHT, LOOK BELOW 2 LETTERS
        //FROM A REG EXPRESSION WITH THE LETTER ON TOP, AND THE LETTER BELOW, AS LONG AS IT DOES NOT CONTAIN
        //CHARACTERS 2 LETTERS UP AND 2 DOWN.
        i = 1
        j = 1
        left = 0
        charLeft = ""
        var charLeft2x = ""
        //var charLeftTop = ""
        left2x = 0
        right = 0
        charRight = ""
        //var charRightTop = ""
        var charRight2x = ""
        right2x = 0
        down = 0
        down2x = 0
        var charDown = ""
        //var charDownLeft = ""
        charDown2x = ""
        up = 0
        charUp = ""
        //var charDownRight = ""
        up2x = 0
        charUp2x = ""
        
        while(i < cells.count){
            
            while(j < cells.count){
                
                left = j - 1
                left2x = j - 2
                right = j + 1
                right2x = j + 2
                down = i + 1
                down2x = i + 2
                up = i - 1
                up2x = i - 2
                
                if(i == 1){
                    up2x = i - 1
                }
                if(i == cells.count - 2){
                    down2x = i + 1
                }
                if(j == 1){
                    left2x = j - 1
                }
                if(j == cells.count - 2){
                    right2x = j + 1
                }
                
                charLeft2x = cells[i][left2x].title(for: UIControl.State.normal) ?? ""
                charRight2x = cells[i][right2x].title(for: UIControl.State.normal) ?? ""
                
                if(i == 1){
                    charLeft2x = ""
                }
                charUp = cells[up][j].title(for: UIControl.State.normal) ?? ""
                charDown = cells[down][j].title(for: UIControl.State.normal) ?? ""
                
                
                if(charUp == "" && charDown == "" && charLeft2x == "" && charRight2x == ""){
                    //query to find a 3 letter word to fit in
                    let char1 = cells[i][left].title(for: UIControl.State.normal) ?? "-"
                    let char2 = "_"
                    let char3 = cells[i][right].title(for: UIControl.State.normal) ?? "-"
                    
                    var queryNewWord = ""
                    
                    
                    if(char1 != "-"){
                        queryNewWord += char1
                    }
                    queryNewWord += char2
                    if(char3 != "-"){
                        queryNewWord += char3
                    }
                    
                    if(char1 == "-" && char3 == "-"){
                        queryNewWord = ""
                    }
                    
                    if(queryNewWord.count > 0){
                        //query to see if the possibleWord is found
                        var queryStatement = ""
                        
                        queryStatement = "SELECT * FROM \(queryTable) WHERE word like ? COLLATE NOCASE;"
                        
                        
                        var wordQuery = ""
                        self.statement = nil
                        if sqlite3_prepare_v2(self.db,queryStatement,-1,&self.statement,nil) == SQLITE_OK{
                            
                            sqlite3_bind_text(self.statement,1,queryNewWord,-1,nil)
                            
                            var found = false
                            while(sqlite3_step(self.statement) == SQLITE_ROW){
                                found = true
                                let word = sqlite3_column_text(self.statement,0)
                                let def = sqlite3_column_text(self.statement,1)
                                
                                let wordFound = String(cString: word!).uppercased()
                                wordQuery = wordFound
                                let defFound = String(cString: def!)
                                wordLength = wordFound.count
                                words[wordLength - 1].append(wordFound)
                                definitions[wordLength - 1].append(defFound)
                                
                            }
                            if(found){
                                var randomWordIndex = 0
                                if(words[wordLength - 1].count == 1){
                                    randomWordIndex = 0
                                }
                                else{
                                    randomWordIndex = Int.random(in: 0 ..< words[wordLength - 1].count - 1)
                                }
                                wordQuery = words[wordLength - 1][randomWordIndex]
                                defQuery = definitions[wordLength - 1][randomWordIndex]
                                
                                //break the loop after 10 attempts to find a unique word
                                //it may not exist, oh well, must use duplicate word
                                var lookEnd = 0
                                if(words[wordLength - 1].count > 1){
                                    while(puzzleWordsToUse.contains(wordQuery)){
                                        randomWordIndex = Int.random(in: 0 ..< words[wordLength - 1].count)
                                        wordQuery = words[wordLength - 1][randomWordIndex]
                                        defQuery = definitions[wordLength - 1][randomWordIndex]
                                        lookEnd += 1
                                        if(lookEnd == 10){
                                            break;
                                        }
                                    }
                                }
                                
                                puzzleWordsToUse.append(wordQuery)
                                puzzleWordsDefinitionToUse.append(defQuery)
                                words[wordLength - 1].removeAll()
                                definitions[wordLength - 1].removeAll()
                                
                                
                                var queryArray = Array(wordQuery)
                                
                                var p = 0
                                var pos = 0
                                
                                if(cells[i][left].isEnabled == false){
                                    p = 1
                                }
                                
                                
                                while(p < wordLength){
                                    cells[i][left + p].setTitle(String(queryArray[pos]),for: .normal)
                                    //cells[up + p][j].backgroundColor = UIColor.red
                                    //add keyvalue pair of solution word based on where the word was insert
                                    
                                    let sy = String(i)
                                    let sx = String(left + p)
                                    let dir = "r"
                                    let id = sy + sx + dir
                                    //print("key: \(id) value: \(index)")
                                    
                                    solutionWordIndex[id] = index
                                    
                                    pos += 1
                                    p += 1
                                }
                                index += 1
                            }
                            else{
                                wordQuery = ""
                            }
                            
                        }
                        sqlite3_finalize(self.statement)
                        self.statement = nil
                    }
                    
                }
                j += 2
                if(j >= cells.count){
                    i += 2
                    if(i >= cells.count){
                        break
                    }
                    j = 1
                }
            }
        }
        
        //disable and remove all blank remaining cells
        
         var x = 0
         var y = 0
         while(y < cells.count){
         while(x < cells.count){
            let charFound = cells[y][x].title(for: UIControl.State.normal) ?? "_"
         if(charFound == "" || charFound == "_"){
         cells[y][x].isEnabled = false
         cells[y][x].alpha = 0
         }
         x += 1
         }
         y += 1
         x = 0
        }
        
        //close database if moving to another view
        //sqlite3_close(db)
        //sqlite3_close(db2)
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
        if(database == "crossywords"){
            
            //this will be db url for accessing dictionary database
            finalDatabaseUrl = documentsUrl.first!.appendingPathComponent("\(database).db")
            do {
                try fileManager.removeItem(atPath: finalDatabaseUrl.path)
            } catch _ as NSError {
            }
            finalDatabaseUrl = documentsUrl.first!.appendingPathComponent("\(database).db")
            
            if !( (try? finalDatabaseUrl.checkResourceIsReachable()) ?? false) {
                let databaseInMainBundleURL = Bundle.main.resourceURL?.appendingPathComponent("\(database).db")
                
                do {
                    try fileManager.copyItem(atPath: (databaseInMainBundleURL!.path), toPath: finalDatabaseUrl.path)
                } catch _ as NSError {
                }
                
            } else {
                
            }
            
            
            
        }else{
            //this will be db url for accessing puzzles
            finalDatabaseUrl2 = documentsUrl.first!.appendingPathComponent("\(database).db")
            //do {
                //try fileManager.removeItem(atPath: finalDatabaseUrl2.path)
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
        //print(finalDatabaseUrl2)
    }
    
    func prepareGrid(){
        
        
        //give all cells a rounded shape and shadow effect
        var i = 0
        var j = 0
        while(i < cells.count){
            while(j < cells.count){
                cells[i][j].layer.cornerRadius = CGFloat(5)
                cells[i][j].layer.borderWidth = CGFloat(1)
                let black = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                let white = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                cells[i][j].layer.borderColor = black.cgColor
                cells[i][j].layer.shadowRadius = 5
                cells[i][j].layer.shadowOpacity = 0.3
                cells[i][j].layer.shadowColor = white.cgColor
                cells[i][j].layer.shadowOffset = CGSize(width: 20.0,height: 22.0)
                cells[i][j].titleLabel!.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
                
                if(cells[i][j].isEnabled){
                    cells[i][j].alpha = 0.9
                    
                }
                
                j += 1
            }
            i += 1
            j = 0
        }
        
        //setup the input characters
        for x in inputLetters{
            x.layer.cornerRadius = CGFloat(5)
            x.layer.borderWidth = CGFloat(1)
            let black = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            x.layer.borderColor = black.cgColor
            x.layer.shadowRadius = 30
            x.layer.shadowOpacity = 1
            x.layer.shadowColor = black.cgColor
            x.layer.shadowOffset = CGSize(width: 22.0,height: 22.0)
            x.titleLabel!.font = UIFont(name: "ArialHebrew", size: CGFloat(fontSize + 6))
        }
        
    }
    
    func appendTextFields(){
        
        inputLetters.append(a)
        inputLetters.append(b)
        inputLetters.append(c)
        inputLetters.append(d)
        inputLetters.append(e)
        inputLetters.append(f)
        inputLetters.append(g)
        inputLetters.append(h)
        inputLetters.append(i)
        inputLetters.append(j)
        inputLetters.append(k)
        inputLetters.append(l)
        inputLetters.append(m)
        inputLetters.append(n)
        inputLetters.append(o)
        inputLetters.append(p)
        inputLetters.append(q)
        inputLetters.append(r)
        inputLetters.append(s)
        inputLetters.append(t)
        inputLetters.append(u)
        inputLetters.append(v)
        inputLetters.append(w)
        inputLetters.append(x)
        inputLetters.append(y)
        inputLetters.append(z)
        inputLetters.append(del)
        inputLetters.append(menu)
        
        cells.append([])
        cells[0].append(r0c0)
        cells[0].append(r0c1)
        cells[0].append(r0c2)
        cells[0].append(r0c3)
        cells[0].append(r0c4)
        cells[0].append(r0c5)
        cells[0].append(r0c6)
        cells[0].append(r0c7)
        cells[0].append(r0c8)
        cells[0].append(r0c9)
        cells[0].append(r0c10)
        cells[0].append(r0c11)
        cells[0].append(r0c12)
        
        cells.append([])
        cells[1].append(r1c0)
        cells[1].append(r1c1)
        cells[1].append(r1c2)
        cells[1].append(r1c3)
        cells[1].append(r1c4)
        cells[1].append(r1c5)
        cells[1].append(r1c6)
        cells[1].append(r1c7)
        cells[1].append(r1c8)
        cells[1].append(r1c9)
        cells[1].append(r1c10)
        cells[1].append(r1c11)
        cells[1].append(r1c12)
        
        
        cells.append([])
        cells[2].append(r2c0)
        cells[2].append(r2c1)
        cells[2].append(r2c2)
        cells[2].append(r2c3)
        cells[2].append(r2c4)
        cells[2].append(r2c5)
        cells[2].append(r2c6)
        cells[2].append(r2c7)
        cells[2].append(r2c8)
        cells[2].append(r2c9)
        cells[2].append(r2c10)
        cells[2].append(r2c11)
        cells[2].append(r2c12)
        
        cells.append([])
        cells[3].append(r3c0)
        cells[3].append(r3c1)
        cells[3].append(r3c2)
        cells[3].append(r3c3)
        cells[3].append(r3c4)
        cells[3].append(r3c5)
        cells[3].append(r3c6)
        cells[3].append(r3c7)
        cells[3].append(r3c8)
        cells[3].append(r3c9)
        cells[3].append(r3c10)
        cells[3].append(r3c11)
        cells[3].append(r3c12)
        
        cells.append([])
        cells[4].append(r4c0)
        cells[4].append(r4c1)
        cells[4].append(r4c2)
        cells[4].append(r4c3)
        cells[4].append(r4c4)
        cells[4].append(r4c5)
        cells[4].append(r4c6)
        cells[4].append(r4c7)
        cells[4].append(r4c8)
        cells[4].append(r4c9)
        cells[4].append(r4c10)
        cells[4].append(r4c11)
        cells[4].append(r4c12)
        
        cells.append([])
        cells[5].append(r5c0)
        cells[5].append(r5c1)
        cells[5].append(r5c2)
        cells[5].append(r5c3)
        cells[5].append(r5c4)
        cells[5].append(r5c5)
        cells[5].append(r5c6)
        cells[5].append(r5c7)
        cells[5].append(r5c8)
        cells[5].append(r5c9)
        cells[5].append(r5c10)
        cells[5].append(r5c11)
        cells[5].append(r5c12)
        
        cells.append([])
        cells[6].append(r6c0)
        cells[6].append(r6c1)
        cells[6].append(r6c2)
        cells[6].append(r6c3)
        cells[6].append(r6c4)
        cells[6].append(r6c5)
        cells[6].append(r6c6)
        cells[6].append(r6c7)
        cells[6].append(r6c8)
        cells[6].append(r6c9)
        cells[6].append(r6c10)
        cells[6].append(r6c11)
        cells[6].append(r6c12)
        
        cells.append([])
        cells[7].append(r7c0)
        cells[7].append(r7c1)
        cells[7].append(r7c2)
        cells[7].append(r7c3)
        cells[7].append(r7c4)
        cells[7].append(r7c5)
        cells[7].append(r7c6)
        cells[7].append(r7c7)
        cells[7].append(r7c8)
        cells[7].append(r7c9)
        cells[7].append(r7c10)
        cells[7].append(r7c11)
        cells[7].append(r7c12)
        
        cells.append([])
        cells[8].append(r8c0)
        cells[8].append(r8c1)
        cells[8].append(r8c2)
        cells[8].append(r8c3)
        cells[8].append(r8c4)
        cells[8].append(r8c5)
        cells[8].append(r8c6)
        cells[8].append(r8c7)
        cells[8].append(r8c8)
        cells[8].append(r8c9)
        cells[8].append(r8c10)
        cells[8].append(r8c11)
        cells[8].append(r8c12)
        
        cells.append([])
        cells[9].append(r9c0)
        cells[9].append(r9c1)
        cells[9].append(r9c2)
        cells[9].append(r9c3)
        cells[9].append(r9c4)
        cells[9].append(r9c5)
        cells[9].append(r9c6)
        cells[9].append(r9c7)
        cells[9].append(r9c8)
        cells[9].append(r9c9)
        cells[9].append(r9c10)
        cells[9].append(r9c11)
        cells[9].append(r9c12)
        
        cells.append([])
        cells[10].append(r10c0)
        cells[10].append(r10c1)
        cells[10].append(r10c2)
        cells[10].append(r10c3)
        cells[10].append(r10c4)
        cells[10].append(r10c5)
        cells[10].append(r10c6)
        cells[10].append(r10c7)
        cells[10].append(r10c8)
        cells[10].append(r10c9)
        cells[10].append(r10c10)
        cells[10].append(r10c11)
        cells[10].append(r10c12)
        
        cells.append([])
        cells[11].append(r11c0)
        cells[11].append(r11c1)
        cells[11].append(r11c2)
        cells[11].append(r11c3)
        cells[11].append(r11c4)
        cells[11].append(r11c5)
        cells[11].append(r11c6)
        cells[11].append(r11c7)
        cells[11].append(r11c8)
        cells[11].append(r11c9)
        cells[11].append(r11c10)
        cells[11].append(r11c11)
        cells[11].append(r11c12)
        
        cells.append([])
        cells[12].append(r12c0)
        cells[12].append(r12c1)
        cells[12].append(r12c2)
        cells[12].append(r12c3)
        cells[12].append(r12c4)
        cells[12].append(r12c5)
        cells[12].append(r12c6)
        cells[12].append(r12c7)
        cells[12].append(r12c8)
        cells[12].append(r12c9)
        cells[12].append(r12c10)
        cells[12].append(r12c11)
        cells[12].append(r12c12)
        
        //create 13 word arrays to hold words of different lenghts
        //from 1 letter to 13 letters
        words.append([])
        words.append([])
        words.append([])
        words.append([])
        words.append([])
        words.append([])
        words.append([])
        words.append([])
        words.append([])
        words.append([])
        words.append([])
        words.append([])
        words.append([])
        
        definitions.append([])
        definitions.append([])
        definitions.append([])
        definitions.append([])
        definitions.append([])
        definitions.append([])
        definitions.append([])
        definitions.append([])
        definitions.append([])
        definitions.append([])
        definitions.append([])
        definitions.append([])
        definitions.append([])
        
    }
    
    @IBAction func setActive(sender: UIButton){
        if(!paused){
            //if the user has clicked on same cell again, change direction of movement
            if(lastSender == sender){
                if(direction == "r"){
                    direction = "d"
                    //directionLabel.text = "d"
                }
                else if (direction == "d"){
                    direction = "r"
                    //directionLabel.text = "r"
                }
            }
            
            //set the last sender
            lastSender = sender
            
            //unselect all cells
            var x = 0
            var y = 0
            while(y < cells.count){
                while(x < cells.count){
                    cells[y][x].isSelected = false
                    cells[y][x].backgroundColor = UIColor.white
                    x += 1
                }
                y += 1
                x = 0
            }
            
            //make only the current button selected
            sender.isSelected = true
            //sender.backgroundColor = UIColor.green
            
            //determine the index of where the currentselected button is location
            //then highlight everything inthat row or column
            x = 0
            y = 0
            
            var posx = 0
            var posy = 0
            while(y < cells.count){
                while(x < cells.count){
                    if(cells[y][x].isSelected){
                        posx = x
                        posy = y
                    }
                    x += 1
                }
                y += 1
                x = 0
            }
            
            //set the hint definition
            let stry = String(posy)
            let strx = String(posx)
            let key = stry + strx + direction
            let indexLookup = solutionWordIndex[key]
            if (indexLookup == nil){
                defLabel.text = "No word in this direction"
                
            }
            else{
                //print("definitions count: \(puzzleWordsDefinitionToUse.count)")
                //print(solutionWordIndex)
                if(indexLookup! >= puzzleWordsDefinitionToUse.count){
                    defLabel.text = "No word in this direction"
                    
                }
                else{
                    defLabel.text = puzzleWordsDefinitionToUse[indexLookup!]
                }
                
            }
            
            if(direction == "r"){
                //posx = 0
                while(posx < cells.count){
                    cells[posy][posx].backgroundColor = UIColor.green
                    if(cells[posy][posx].isEnabled == false){
                        break
                    }
                    posx += 1
                    
                }
                
            }
            else if(direction == "d"){
                //posy = 0
                while(posy < cells.count){
                    cells[posy][posx].backgroundColor = UIColor.green
                    if(cells[posy][posx].isEnabled == false){
                        break
                    }
                    posy += 1
                    
                }
            }
        }
        
    }

    @IBAction func letterAction(sender: UIButton){
        
        if(!paused){
            nextIndex.removeAll()
            //get the letter that was clicked on from the letters buttons
            let letter = sender.title(for: UIControl.State.normal)!
            
            indexy = 0
            indexx = 0
            
            var i = 0
            var j = 0
            if(direction == "r"){
                while(i < cells.count){
                    while(j < cells.count){
                        if(cells[i][j].isSelected){
                            if(letter == "Cl"){
                                cells[i][j].setTitle("",for: .normal)
                                cells[i][j].isSelected = false
                                nextIndex.append(i)
                                nextIndex.append(j)
                            }
                            else{
                                cells[i][j].setTitle(letter,for: .normal)
                                cells[i][j].isSelected = false
                                nextIndex.append(i)
                                nextIndex.append(j + 1)
                            }
                        }
                        j += 1
                    }
                    i += 1
                    j = 0
                }
            }
            else if(direction == "d"){
                while(i < cells.count){
                    while(j < cells.count){
                        if(cells[i][j].isSelected){
                            if(letter == "Cl"){
                                cells[i][j].setTitle("",for: .normal)
                                cells[i][j].isSelected = false
                                nextIndex.append(i)
                                nextIndex.append(j)
                            }
                            else{
                                cells[i][j].setTitle(letter,for: .normal)
                                cells[i][j].isSelected = false
                                nextIndex.append(i + 1)
                                nextIndex.append(j)
                            }
                            
                        }
                        j += 1
                    }
                    i += 1
                    j = 0
                }
            }
            
            nextAvailableIndex()
            cells[nextIndex[0]][nextIndex[1]].isSelected = true
            
            //set the hint definition
            let stry = String(nextIndex[0])
            let strx = String(nextIndex[1])
            let key = stry + strx + direction
            let indexLookup = solutionWordIndex[key]
            
            if (indexLookup == nil){
                defLabel.text = "No word in this direction"
            }
            else{
                if(indexLookup! >= puzzleWordsDefinitionToUse.count){
                    defLabel.text = "No word in this direction"
                }
                else{
                    defLabel.text = puzzleWordsDefinitionToUse[indexLookup!]
                }
            }
            
            //set all of the preceding rows or columns green
            var x = 0
            var y = 0
            var posx = 0
            var posy = 0
            while(y < cells.count){
                while(x < cells.count){
                    if(cells[y][x].isSelected){
                        posx = x
                        posy = y
                    }
                    x += 1
                }
                y += 1
                x = 0
            }
            
            
            if(direction == "r"){
                //posx = 0
                while(posx < cells.count){
                    cells[posy][posx].backgroundColor = UIColor.green
                    if(cells[posy][posx].isEnabled == false){
                        break
                    }
                    posx += 1
                }
                
            }
            else if(direction == "d"){
                //posy = 0
                while(posy < cells.count){
                    cells[posy][posx].backgroundColor = UIColor.green
                    if(cells[posy][posx].isEnabled == false){
                        break
                    }
                    posy += 1
                }
            }
            
            
            
            
            cells[nextIndex[0]][nextIndex[1]].backgroundColor = UIColor.green
            lastSender.backgroundColor = UIColor.white
            lastSender = cells[nextIndex[0]][nextIndex[1]]
            
        }
        
        //check if puzzle completed and update status label accordingly
        puzzleString = ""
        var rw = 0
        var co = 0
        while (rw < cells.count){
            while(co < cells.count){
                if(!cells[rw][co].isEnabled){
                    //print("row: \(rw) col: \(co)")
                    puzzleString += "_"
                }
                else{
                    //print("row: \(rw) col: \(co)")
                    puzzleString += cells[rw][co].title(for: UIControl.State.normal)!
                }
                co += 1
            }
            rw += 1
            co = 0
        }
        
        //print(puzzleString)
        //print(solutionString)
        
        if(puzzleString == solutionString){
            //print("puzzle solved")
            //puzzle has been solved, change the color of all cells to green
            var rw = 0
            var co = 0
            while (rw < cells.count){
                while(co < cells.count){
                    cells[rw][co].backgroundColor = UIColor.green
                    co += 1
                }
                rw += 1
                co = 0
            }
            
            //update label completed
            statusLabel.textColor = UIColor.green
            statusLabel.text = "Complete!"
        }
        else{
            //update label completed
            statusLabel.textColor = UIColor.red
            statusLabel.text = "Incomplete"
        }
    }
    
    
    
    func nextAvailableIndex(){
        
        if(direction == "r"){
            if(nextIndex[1] >= cells.count){
                nextIndex[1] = 0
                nextIndex[0] += 1
                if(nextIndex[0] >= cells.count){
                    nextIndex[0] = 0
                }
            }
        
            while(cells[nextIndex[0]][nextIndex[1]].isEnabled == false){
                nextIndex[1] += 1
                if(nextIndex[1] >= cells.count){
                    nextIndex[1] = 0
                    nextIndex[0] += 1
                    if(nextIndex[0] >= cells.count){
                        nextIndex[0] = 0
                    }
                }
            }
        }
        else if(direction == "d"){
            if(nextIndex[0] >= cells.count){
                nextIndex[0] = 0
                nextIndex[1] += 1
                if(nextIndex[1] >= cells.count){
                    nextIndex[1] = 0
                }
            }
            
            while(cells[nextIndex[0]][nextIndex[1]].isEnabled == false){
                nextIndex[0] += 1
                if(nextIndex[0] >= cells.count){
                    nextIndex[0] = 0
                    nextIndex[1] += 1
                    if(nextIndex[1] >= cells.count){
                        nextIndex[1] = 0
                    }
                }
            }
        }
    }
}

