//
//  World.swift
//  GameOfLifeVaxi
//
//  Created by Peter Varga on 2017. 02. 01..
//  Copyright © 2017. Peter Varga. All rights reserved.
//

import UIKit

class World {
    
    var cells: [Cell]
    let dimension: Int = 20
    
    var isInEditMode = false
    
    init() {
        
        self.cells = []
        
        for i in 0..<self.dimension {
            
            for j in 0..<self.dimension {
            
                self.cells.append(Cell(x: i, y: j))
                
            }
            
        }
        
    }
    
    var worldHash: String = ""
    
    func reset() {
        self.cells.forEach { (cell) in
            cell.state = .New
        }
    }
    
    func getCellFor(x xCoord: Int, y yCoord: Int) -> Cell? {
        return cells.filter {
            $0.x == xCoord && $0.y == yCoord
        }.first
    }
    
    // from http://blog.scottlogic.com/2014/09/10/game-of-life-in-functional-swift.html
    let cellsAreNeighbours = { (op1: Cell, op2: Cell) -> Bool in
        
        let delta = (abs(op1.x - op2.x), abs(op1.y - op2.y))
        switch (delta) {
        case (1,1), (1,0), (0,1):
            return true
        default:
            return false
        }
    }
    
    //**
    
    func getNeighboursFor(_ cell: Cell) -> [Cell] {
        return self.cells.filter { cellsAreNeighbours(cell, $0)}
    }
    
    func getLivingNeighboursFor(_ cell: Cell) -> [Cell] {
        return getNeighboursFor(cell).filter{$0.state == .Alive}
    }
    
    func printCurrentState() {
        
        print("------------------------")
        
        for i in 0..<self.dimension {
            
            var str = ""
            
            for j in 0..<self.dimension {
                
                let cell = self.getCellFor(x: i, y: j)
                
                switch cell!.state {
                case .Alive:
                    str.append("O ")
                    break
                case .New:
                    str.append("  ")
                    break
                default:
                    break
                }
                
            }
            
            print(str)
        }
        
    }
    
    func getCurrentStateView() -> UIView {
        
        self.worldHash = ""
        
        let w = Int(UIScreen.main.bounds.size.width)
        
        let view = UIView(frame: CGRect(x: 5, y: 0, width: w, height: w))
        
        var x = 0, y = 0
        
        
        for i in 0..<self.dimension {
            
            y = 0
            
            for j in 0..<self.dimension {
                
                
                let cell = self.getCellFor(x: i, y: j)
                
                let miniView = UIView(frame: CGRect(x: x, y: y, width: w / dimension, height: w / dimension))
                
                switch cell!.state {
                case .Alive:
                    miniView.backgroundColor = UIColor.yellow
                    self.worldHash.append("A")
                    break
                case .New:
                    miniView.backgroundColor = UIColor.init(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
                    self.worldHash.append("N")
                    break
                case .Dead:
                    self.worldHash.append("D")
                    break
                }
                
                if isInEditMode {
                    let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
                    miniView.addGestureRecognizer(tap)
                    miniView.tag = self.cells.index{$0 === cell}!
                }
                
                miniView.layer.borderWidth = 1
                miniView.layer.borderColor = UIColor.lightGray.cgColor
                
                view.addSubview(miniView)
                
                y = y + w / dimension
            }
            
            x = x + w / dimension
            
        }
        
        return view
        
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        let view = sender.view
        let tag = view!.tag
        switch self.cells[tag].state {
        case .Alive:
            self.cells[tag].state = .New
            break
        case .New:
            self.cells[tag].state = .Alive
            break
        default:
            break
        }
        
        NotificationCenter.default.post(name: Notification.Name("updateView"), object: nil)
    }

}
