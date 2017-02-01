//
//  EditorViewController.swift
//  GameOfLifeVaxi
//
//  Created by Peter Varga on 2017. 02. 01..
//  Copyright © 2017. Peter Varga. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    
    var game: Game!
    var world: World!
    var gameView: UIView!

    var timer: Timer!
    var isPlaying: Bool = false
    var isGameOver: Bool = false

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.game = Game()
        self.world = game.world
        self.world.isInEditMode = true
        
        self.gameView = world.getCurrentStateView()
        self.container.addSubview(gameView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(playNext))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notification.Name("updateView"), object: nil)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func playNext() {
        let lastHash = self.world.worldHash
        self.game.nextRound()
        self.gameView.removeFromSuperview()
        self.gameView = self.world.getCurrentStateView()
        self.container.addSubview(self.gameView)
        let currentHash = self.world.worldHash
        
        if lastHash == currentHash {
            self.gameover()
        }

    }
    
    func updateView() {
        self.gameView.removeFromSuperview()
        self.gameView = self.world.getCurrentStateView()
        self.container.addSubview(self.gameView)
    }
    
    func gameover() {
        if self.isPlaying {
            self.playButton.setTitle("Auto play", for: .normal)
            self.timer.invalidate()
        }
        
        self.isPlaying = false
        
        let alertController = UIAlertController(title: "Game of life", message: "Game over :(", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
        
        self.isGameOver = true
    }

    @IBAction func playButtonClicked(_ sender: Any) {
        
        if self.isPlaying {
            self.playButton.setTitle("Auto play", for: .normal)
            self.timer.invalidate()
        } else {
            self.playButton.setTitle("Pause", for: .normal)
            
            self.timer = Timer.init(timeInterval: 0.4, repeats: true, block: { (timer) in
                DispatchQueue.main.async {
                    self.playNext()
                }
            })
            
            
            RunLoop.main.add(self.timer, forMode: RunLoopMode.commonModes)
            
        }
        
        self.isPlaying = !self.isPlaying

        
    }

}
