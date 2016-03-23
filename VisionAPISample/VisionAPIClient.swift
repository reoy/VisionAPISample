//
//  VisionAPIClient.swift
//  VisionAPISample
//
//  Created by Reo Yoshida on 2016/03/23.
//  Copyright © 2016年 吉田麗央. All rights reserved.
//

import Foundation

protocol VisionAPIClientDelegate: class {
    func visionAPIClientDidReceivedData(data: NSData?, error: ErrorType?)
}

class VisionAPIClient: APIClient {

    let API_KEY = "AIzaSyD4SqHVvj3L75Gxp4AQapYehYR4V8yb9zo"
    weak var delegate: VisionAPIClientDelegate?

    func request(imageData: String) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.throwRequest(self.createRequest(imageData))
        });
    }

    private func createRequest(imageData: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(
            URL: NSURL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(API_KEY)")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            NSBundle.mainBundle().bundleIdentifier ?? "",
            forHTTPHeaderField: "X-Ios-Bundle-Identifier")

        // Build our API request
        let jsonRequest: [String: AnyObject] = [
            "requests": [
                "image": [
                    "content": imageData
                ],
                "features": [
                    [
                        "type": "LANDMARK_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]

        // Serialize the JSON
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonRequest, options: [])
        return request
    }

    func dataReceived(data: NSData?, error: ErrorType?) {
        self.delegate?.visionAPIClientDidReceivedData(data, error: error)
    }
}
