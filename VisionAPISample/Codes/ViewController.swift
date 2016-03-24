//
//  ViewController.swift
//  VisionAPISample
//
//  Created by 吉田麗央 on 2016/03/23.
//  Copyright © 2016年 吉田麗央. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    
    let session = AVCaptureSession()
    let output = AVCaptureStillImageOutput()
    let visionApiClient = VisionAPIClient()
    let wikiApiClient = WikipediaAPIClient()
    
    var backCamera: AVCaptureDevice?
    var input: AVCaptureDeviceInput?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        visionApiClient.delegate = self
        wikiApiClient.delegate = self
        setupCamera()
        startCapture()
    }

    override func viewWillLayoutSubviews() {
        setupVideoLayer()
    }
    
    private func setupCamera() {
        guard let backCamera = getBackCamera() else { return }
        input = try! AVCaptureDeviceInput(device: backCamera)
        session.addInput(input)
        session.addOutput(output)
    }

    private func setupVideoLayer() {
        videoView.layer.sublayers?.removeAll()
        let videoLayer = AVCaptureVideoPreviewLayer(session: session)
        videoLayer.frame = videoView.bounds
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoView.layer.addSublayer(videoLayer)
    }
    
    private func startCapture() {
        session.startRunning()
    }
    
    private func getBackCamera() -> AVCaptureDevice? {
        return AVCaptureDevice.devices().filter { $0.position == .Back }.first as? AVCaptureDevice
    }
    
    @IBAction func captureImage() {
        SVProgressHUD.showWithStatus("Cloud Vision API\nに問い合わせ中", maskType: SVProgressHUDMaskType.Gradient)
        let connection = output.connectionWithMediaType(AVMediaTypeVideo)
        output.captureStillImageAsynchronouslyFromConnection(connection) { (buffer, error) -> Void in
            let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
            guard let image = UIImage(data: data) else {
                SVProgressHUD.showErrorWithStatus("失敗")
                return
            }
            self.request(image)
        }
    }
    
    private func request(image: UIImage) {
        let imageData = image.base64EncodeImage()
        visionApiClient.request(imageData)
    }
}

extension ViewController: VisionAPIClientDelegate {
    func visionAPIClientDidReceivedData(data: NSData?, error: ErrorType?) {
        if let _ = error {
            SVProgressHUD.showErrorWithStatus("失敗")
            return
        }
        guard let data = data else {
            SVProgressHUD.showErrorWithStatus("失敗")
            return
        }
        let json = JSON(data: data)
        print(json)
        if let title = json["responses"][0]["landmarkAnnotations"][0]["description"].string {
            wikiApiClient.request(title)
        }
    }
}

extension ViewController: WikipediaAPIClientDelegate {
    func wikipediaAPIClientDidReceivedData(data: NSData?, error: ErrorType?) {
        if let _ = error {
            SVProgressHUD.showErrorWithStatus("失敗")
            return
        }
        guard let data = data else {
            SVProgressHUD.showErrorWithStatus("失敗")
            return
        }
        let json = JSON(data: data)
        if let pageid = json["query"]["pages"].dictionaryValue.keys.first {
            SVProgressHUD.dismiss()
            let baseURLString = "https://en.wikipedia.org/wiki/index.php?curid=\(pageid)"
            let urlString = baseURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
        }
    }
}
