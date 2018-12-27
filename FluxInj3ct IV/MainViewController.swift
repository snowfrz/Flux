//
//  MainViewController.swift
//  FluxInj3ct IV
//
//  Created by Justin Proulx on 2018-12-14.
//  Copyright © 2018 New Year's Development Team. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MainViewController: UIViewController
{
    @IBOutlet var actionView: TopRoundedCornersView!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var titleStack: UIStackView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var jailbreakButton: JailbreakButton!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var videoView: UIView!
    @IBOutlet var twitterButtons: [TwitterButton]!
    
    var blurToTitleConstraint: NSLayoutConstraint?
    var defaultHeight: CGFloat = 0
    var defaultDropHeight: CGFloat = 0
    
    var totalDragged: CGFloat = 0
    var isDown: Bool = false
    var currentTransform: CGAffineTransform?
    
    var originalConstraintValue: CGFloat!
    
    var animator: UIDynamicAnimator!
    
    var triggerDateMet: Bool = false
    
    // MARK: – Loading and presentation
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        animator = UIDynamicAnimator(referenceView: self.view)
        
        self.gradientView.layer.addSublayer(createGradient())
        
        self.view.bringSubviewToFront(actionView)
        
        defaultHeight = self.view.frame.size.height - (-48 + titleStack.frame.size.height)
        defaultDropHeight = self.defaultHeight - 224 - safeAreaHeight()
        
        progressBar.isHidden = true
        progressLabel.isHidden = true
        
        // if it's started
        if UserDefaults.standard.bool(forKey: "started")
        {
            progressLabel.isHidden = true
            progressBar.isHidden = true
            
            jailbreakButton.setTitle("Happy New Year", for: .normal)
            
            // check date
            var dateOneComponents = DateComponents.init()
            dateOneComponents.year = 2018
            dateOneComponents.month = 12
            dateOneComponents.day = 31
            
            let dateOne = NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: dateOneComponents)
            let dateTwo = Date()
            
            triggerDateMet = dateOne?.compare(dateTwo) != ComparisonResult.orderedDescending ? true : false
            
            if !triggerDateMet
            {
                // current date is earlier than trigger date
                infoLabel.text = "Success. Cydia is now installed."
            }
            else
            {
                // current date is trigger date or later
                infoLabel.isHidden = true
                
                for button in twitterButtons
                {
                    button.tintColor = UIColor(red:0.30, green:0.44, blue:0.50, alpha:0.75)
                    button.setColors()
                }
                
                let videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NGGYU", ofType: "mp4")!)
                let player = AVPlayer(url: videoURL)
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                playerLayer.frame = self.view.bounds
                videoView.layer.addSublayer(playerLayer)
                player.play()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        var anchors = [NSLayoutConstraint]()
        anchors.append(self.actionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0))
        NSLayoutConstraint.activate(anchors)
        
        self.view.layoutIfNeeded()
        self.actionView.layoutIfNeeded()
        
        self.actionView.transform = CGAffineTransform(translationX: 0, y: self.actionView.frame.size.height)
        self.actionView.frame.size.height += self.view.frame.size.height
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveLinear, animations: {
            
            self.actionView.transform = CGAffineTransform.identity
            
            self.view.layoutIfNeeded()
            self.actionView.layoutIfNeeded()
        }){ _ in
            self.actionView.frame.size.height = self.defaultHeight
        }
        
        if UserDefaults.standard.bool(forKey: "started")
        {
            dismissCard()
        }
    }
    
    // MARK: – User Interface
    func safeAreaHeight() -> CGFloat
    {
        if #available(iOS 11.0, *)
        {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            let bottomPadding = window.frame.maxY - safeFrame.maxY
            return bottomPadding
        }
        else
        {
            return 0
        }
    }
    
    func createGradient() -> CAGradientLayer
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red:0.47, green:0.68, blue:0.77, alpha:1.0).cgColor, UIColor(red:0.47, green:0.77, blue:0.60, alpha:1.0).cgColor]
        
        return gradientLayer
    }
    
    @IBAction func handleActionViewPull(sender: UIPanGestureRecognizer)
    {
        let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        lightImpactFeedbackGenerator.prepare()
        
        if sender.state == .ended || sender.state == .cancelled || sender.state == .failed
        {
            if !isDown
            {
                if totalDragged < 150
                {
                    springBackView(view: self.actionView, toTransform: .identity)
                }
                else
                {
                    dismissCard()
                    
                    // Play the haptic signal
                    lightImpactFeedbackGenerator.impactOccurred()
                }
            }
            else
            {
                if totalDragged > -150
                {
                    springBackView(view: self.actionView, toTransform: currentTransform ?? self.actionView.transform)
                }
                else
                {
                    springBackView(view: self.actionView, toTransform: .identity)
                    isDown = false
                    // Play the haptic signal
                    lightImpactFeedbackGenerator.impactOccurred()
                }
            }
        }
        else
        {
            // get the amount the user's finger was dragged
            let fingerDragAmount = sender.translation(in: self.view).y
            
            totalDragged = fingerDragAmount
            
            // get the translation amount
            var viewTranslationY: CGFloat = 0
            viewTranslationY = stretchTranslation(fingerDrag: fingerDragAmount, springMath: customSpringMathFunction)
            
            if isDown
            {
                viewTranslationY += defaultDropHeight
            }
            
            self.actionView.transform = CGAffineTransform(translationX: 0, y: viewTranslationY)
            
            if fingerDragAmount < 0
            {
                self.actionView.frame.size.height -= fingerDragAmount
            }
        }
    }
    
    func dismissCard()
    {
        animateView(view: self.actionView, moveHeight: defaultDropHeight)
        isDown = true
    }
    
    func stretchTranslation(fingerDrag: CGFloat, springMath: (CGFloat) -> CGFloat) -> CGFloat
    {
        let translationAmount = springMath(fingerDrag)
        return translationAmount
    }
    
    func animateView(view: UIView, moveHeight: CGFloat)
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            view.transform = CGAffineTransform(translationX: 0, y: moveHeight)
        }){ _ in
            self.currentTransform = self.actionView.transform
        }
    }
    
    func springBackView(view: UIView, toTransform: CGAffineTransform)
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .allowUserInteraction, animations: {
            
            view.transform = toTransform
            
            view.superview?.layoutIfNeeded()
            view.layoutIfNeeded()
        }){ _ in
            self.actionView.frame.size.height = self.defaultHeight
        }
    }
    
    func customSpringMathFunction(x: CGFloat) -> CGFloat
    {
        return 3*(atan(x/512) * 180 / CGFloat.pi)
        //return 16*pow(abs(x), 1/3) * (x >= 0 ? 1 : -1)
        //return atan(x) * 180 / CGFloat.pi
        //return (8*sqrt(abs(x))) * (x >= 0 ? 1 : -1)
    }
    
    // MARK: – Jailbreak code
    @IBAction func jailbreak(sender: JailbreakButton)
    {
        if !UserDefaults.standard.bool(forKey: "started")
        {
            // dismiss the card
            let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            lightImpactFeedbackGenerator.prepare()
            dismissCard()
            lightImpactFeedbackGenerator.impactOccurred()
            
            // check compatibility
            let compatibilityString = "iOS " + UIDevice.current.systemVersion
            
            if compatibilityString.contains("iOS 12.")
            {
                // if compatible, jailbreak
                infoLabel.isHidden = true
                jailbreakButton.isEnabled = false
                jailbreakButton.setTitle("Jailbreaking...", for: .normal)
                
                progressBar.isHidden = false
                progressLabel.isHidden = false
                
                progressBar.setProgress(0, animated: false)
                
                startJailbreak()
            }
            else
            {
                infoLabel.text = "Incompatible with your version of iOS. Flux 4 can only jailbreak iOS 12.0 to iOS 12.1.2."
            }
        }
        else
        {
            let alert = UIAlertController(title: "Reset", message: "Do you want to reset the app? You'll be able to go through the \"jailbreak\" process again.", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                UserDefaults.standard.set(false, forKey: "started")
                fatalError()
            }
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func startJailbreak()
    {
        // this function contains the fake jailbreak progress code
        let i: Float = Float(arc4random_uniform(1000))
        var j: Float = 0
        
        if (i > 500)
        {
            let k = arc4random_uniform(5)
            if (k == 4)
            {
                let divisor: Float = Float(arc4random_uniform(25000)+2500)
                j = i / divisor
            }
            else
            {
                let divisor: Float = Float(arc4random_uniform(200000)+10000)
                j = i/divisor
            }
        }
        else
        {
            j = 0;
        }
        
        progressBar.setProgress(progressBar.progress + j, animated: true)
        
        let progress = Int(progressBar.progress*100);
        
        if (progress < 14)
        {
            progressLabel.text = "Loading exploit";
        }
        else if (progress >= 14 && progress < 35)
        {
            progressLabel.text = "Unpacking Cydia";
        }
        else if (progress >= 35 && progress < 63)
        {
            progressLabel.text = "Patching (1/2)";
        }
        else if (progress >= 63 && progress < 76)
        {
            progressLabel.text = "Patching (2/2)";
        }
        else if (progress >= 76 && progress < 85)
        {
            progressLabel.text = "Verifying patch success";
        }
        else if (progress >= 85 && progress < 94)
        {
            progressLabel.text = "Moving files";
        }
        else if (progress >= 94 && progress < 100)
        {
            progressLabel.text = "Finalizing...";
        }
        
        // if "jailbreak" isn't done, run the code again to calculate the next interval
        if progressBar.progress*100 < 100
        {
            self.perform(#selector(startJailbreak), with: nil, afterDelay: 0.6)
        }
        else
        {
            // if "jailbreak" is done, finish up
            progressLabel.text = "Please restart your device. After it is restarted, come back to the Flux app so Cydia can be installed.";
            jailbreakButton.setTitle("Restart Device", for: .normal)
            
            UserDefaults.standard.set(true, forKey: "started")
        }
    }
    
    // MARK: – Twitter
    @IBAction func openTwitter(sender: TwitterButton)
    {
        var handle = ""
        if sender.titleLabel?.text == "Justin Proulx"
        {
            handle = "JustinAlexP"
        }
        else if sender.titleLabel?.text == "nullpixel"
        {
            handle = "nullriver"
        }
        else if sender.titleLabel?.text == "AppleBetas"
        {
            handle = "AppleBetasDev"
        }
        else
        {
            handle = "rickastley"
        }
        
        let normalURL = URL(string: "https://twitter.com/" + handle)
        let twitterURL = URL(string: "twitter://user?screen_name=" + handle)
        
        if UIApplication.shared.canOpenURL(twitterURL!)
        {
            UIApplication.shared.open(twitterURL!, options:[:], completionHandler: nil)
        }
        else
        {
            UIApplication.shared.open(normalURL!, options:[:] , completionHandler: nil)
        }
    }
}
