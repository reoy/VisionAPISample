//
//  APIClient.swift
//  VisionAPISample
//
//  Created by Reo Yoshida on 2016/03/23.
//  Copyright © 2016年 吉田麗央. All rights reserved.
//

import Foundation

protocol APIClient {
    func throwRequest(request: NSMutableURLRequest)
    func dataReceived(data: NSData?, error: ErrorType?)
}

extension APIClient {
    func throwRequest(request: NSMutableURLRequest) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, resp, error -> Void in
            self.dataReceived(data, error: error)
        }
        task.resume()
    }
}