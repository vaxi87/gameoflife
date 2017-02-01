//
//  ViewController.swift
//  GameOfLifeVaxi
//
//  Created by Peter Varga on 2017. 02. 01..
//  Copyright © 2017. Peter Varga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    var game: Game!
    var world: World!
    var gameView: UIView!
    var timer: Timer!
    var isPlaying: Bool = false
    var isGameOver: Bool = false
    @IBOutlet weak var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.game = Game()
        self.world = game.world
        

        
        self.view.backgroundColor = UIColor.lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(playNext))
        self.view.addGestureRecognizer(tap)
        
        // Glider
        self.world.getCellFor(x: 4, y: 3)!.state = .Alive
        self.world.getCellFor(x: 5, y: 4)!.state = .Alive
        self.world.getCellFor(x: 3, y: 5)!.state = .Alive
        self.world.getCellFor(x: 4, y: 5)!.state = .Alive
        self.world.getCellFor(x: 5, y: 5)!.state = .Alive
        
        self.gameView = world.getCurrentStateView()
        self.container.addSubview(gameView)
    }
    
    func generateNewWorld() {
        
        self.world.reset()
        
        for _ in 0...50 {
            let x = randLocation(), y = randLocation()
            self.world.getCellFor(x: x, y: y)!.state = .Alive
        }
        
        // Blinker
//        self.world.getCellFor(x: 3, y: 3)!.state = .Alive
//        self.world.getCellFor(x: 4, y: 3)!.state = .Alive
//        self.world.getCellFor(x: 5, y: 3)!.state = .Alive
        
        // Toad
//        self.world.getCellFor(x: 4, y: 3)!.state = .Alive
//        self.world.getCellFor(x: 5, y: 3)!.state = .Alive
//        self.world.getCellFor(x: 6, y: 3)!.state = .Alive
//        self.world.getCellFor(x: 3, y: 4)!.state = .Alive
//        self.world.getCellFor(x: 4, y: 4)!.state = .Alive
//        self.world.getCellFor(x: 5, y: 4)!.state = .Alive
        
//         // Glider
//        self.world.getCellFor(x: 4, y: 3)!.state = .Alive
//        self.world.getCellFor(x: 5, y: 4)!.state = .Alive
//        self.world.getCellFor(x: 3, y: 5)!.state = .Alive
//        self.world.getCellFor(x: 4, y: 5)!.state = .Alive
//        self.world.getCellFor(x: 5, y: 5)!.state = .Alive
        
        gameView?.removeFromSuperview()
        self.gameView = world.getCurrentStateView()
        self.container.addSubview(gameView)
    }

    func randLocation () -> Int {
        return Int(arc4random()) % self.world.dimension
    }

    func playNext() {
        let lastHash = self.world.worldHash
        self.game.nextRound()
        self.gameView.removeFromSuperview()
        self.gameView = self.world.getCurrentStateView()
        self.container.addSubview(self.gameView)
        let currentHash = self.world.worldHash
        
        if lastHash == currentHash {
            gameover()
        }
    }
    
    func gameover() {
        if isPlaying {
            playButton.setTitle("Generate new", for: .normal)
            timer.invalidate()
        }
        
        let alertController = UIAlertController(title: "Game of life", message: "Game over :(", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
        
        self.isGameOver = true
    }


    @IBAction func resetButtonClicked(_ sender: Any) {
        self.generateNewWorld()
        isGameOver = false
        playButton.setTitle("Play", for: .normal)
    }


    @IBAction func playPauseButtonClicked(_ sender: Any) {
        
        if isGameOver {
            self.generateNewWorld()
            isGameOver = false
            playButton.setTitle("Play", for: .normal)
            return
        }
        
        if isPlaying {
            playButton.setTitle("Play", for: .normal)
            timer.invalidate()
        } else {
            playButton.setTitle("Pause", for: .normal)
            
            timer = Timer.init(timeInterval: 0.4, repeats: true, block: { (timer) in
                DispatchQueue.main.async {
                    self.playNext()
                }
            })
    
            
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
      
        }
        
        isPlaying = !isPlaying
    }
}

