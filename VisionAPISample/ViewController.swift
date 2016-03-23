//
//  ViewController.swift
//  VisionAPISample
//
//  Created by 吉田麗央 on 2016/03/23.
//  Copyright © 2016年 吉田麗央. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let session = AVCaptureSession()
    let output = AVCaptureStillImageOutput()
    
    var backCamera: AVCaptureDevice?
    var input: AVCaptureDeviceInput?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCamera()
        setupVideoLayer()
        startCapture()
    }
    
    private func setupCamera() {
        guard let backCamera = getBackCamera() else { return }
        input = try! AVCaptureDeviceInput(device: backCamera)
        session.addInput(input)
        session.addOutput(output)
    }
    
    private func setupVideoLayer() {
        let videoLayer = AVCaptureVideoPreviewLayer(session: session)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(videoLayer)
    }
    
    private func startCapture() {
        session.startRunning()
    }
    
    private func getBackCamera() -> AVCaptureDevice? {
        return AVCaptureDevice.devices().filter { $0.position == .Back }.first as? AVCaptureDevice
    }
    
    private func captureImage() {
        let connection = output.connectionWithMediaType(AVMediaTypeVideo)
        output.captureStillImageAsynchronouslyFromConnection(connection) { (buffer, error) -> Void in
            let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
            
        }
    }
    
    private func request() {
        
    }
}

