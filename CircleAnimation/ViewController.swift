//
//  ViewController.swift
//  CircleAnimation
//
//  Created by Viral Chauhan on 13/12/17.
//  Copyright © 2017 Viral Chauhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    
    var shapeLayer : CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    fileprivate func setupNoficationObserver () {
        NotificationCenter.default.addObserver(self, selector: #selector(handleForegroundEvent), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc private func handleForegroundEvent () {
        animatePulsaingLayer()
    }
    
    
    private func createCircleShapeLayer (strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let cirularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: CGFloat(2 * Float.pi), clockwise: true)
        
        let layer = CAShapeLayer()
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.path = cirularPath.cgPath
        layer.position = view.center
        return layer
        
    }
    
    fileprivate func setupCircleLayers() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: .pulsingFillColor)
        self.view.layer.addSublayer(pulsatingLayer);
        animatePulsaingLayer ()
        
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroudColor)
        self.view.layer.addSublayer(trackLayer)
        
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.strokeEnd = 0
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2 , 0, 0, 1)
        self.view.layer.addSublayer(shapeLayer)
    }
    
    fileprivate func setupParcentageLabel() {
        //Center label
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupNoficationObserver ()
        self.view.backgroundColor = UIColor.backgroudColor;
        
        setupCircleLayers()
        
        setupParcentageLabel()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
    }

    fileprivate func animatePulsaingLayer () {
        let animate = CABasicAnimation(keyPath: "transform.scale")
        animate.toValue = 1.3
        animate.duration = 0.8
        animate.repeatCount = Float.infinity
        animate.autoreverses = true
        animate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        pulsatingLayer.add(animate, forKey: "pulsing")
    }
    
    let urlString = "http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_5mb.mp4"
    
    fileprivate func animateCircle() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1.5
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urAnimation")
    }
    
    
    private func backgroundDownloadFile () {
        
        print("Background Download File")
        shapeLayer.strokeEnd = 0
        self.percentageLabel.text = "Start"
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        guard let url = URL.init(string: urlString) else {
            return
        }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
    
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
        
        print(percentage)
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Download finished")
    }
    
    @objc private func handleTap () {
        
        backgroundDownloadFile ()
        
    }
   

}

