//
//  HighScoresViewController.swift
//  Duos
//
//  Created by Jorge Tapia on 10/12/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import UIKit
import CoreData

class HighScoresViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resetButton: UIButton!
    
    var highScores = [HighScore]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        highScores = HighScore.allScores() as! [HighScore]
        resetButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Actions
    
    @IBAction func backAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func resetAction(sender: AnyObject) {
        HighScore.reset()
        highScores = HighScore.allScores() as! [HighScore]
        
        tableView.reloadData()
    }
    
    // MARK: - Cell configuration
    
    private func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let highScore = highScores[indexPath.row]
        
        cell.textLabel?.text = "\(indexPath.row + 1))  \(highScore.time!)"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "E, dd/MM/y"
        let formattedDate = dateFormatter.stringFromDate(highScore.date!)
        cell.detailTextLabel?.text = formattedDate
    }
    
}

// MARK: - Table view data source

extension HighScoresViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if highScores.count == 0 {
            let backgroundLabel = UILabel(frame: tableView.frame)
            backgroundLabel.text = "There are no high scores.\nPlease play some games and come later."
            backgroundLabel.textColor = UIColor(red: 68.0 / 255.0, green: 68.0 / 255.0, blue: 68.0 / 255.0, alpha: 1.0)
            backgroundLabel.textAlignment = NSTextAlignment.Center
            backgroundLabel.font = UIFont(name: "MarkerFelt-Thin", size: 17.0)
            backgroundLabel.numberOfLines = 0
            
            tableView.backgroundView = backgroundLabel
            resetButton.enabled = false
        } else {
            tableView.backgroundView = nil
            resetButton.enabled = true
        }
        
        return highScores.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScoreCell", forIndexPath: indexPath)
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
}