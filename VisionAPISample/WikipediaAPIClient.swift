//
//  WikipediaAPIClient.swift
//  VisionAPISample
//
//  Created by Reo Yoshida on 2016/03/23.
//  Copyright © 2016年 吉田麗央. All rights reserved.
//

import Foundation

protocol WikipediaAPIClientDelegate: class {
    func wikipediaAPIClientDidReceivedData(data: NSData?, error: ErrorType?)
}

class WikipediaAPIClient: APIClient {

    var delegate: WikipediaAPIClientDelegate?

    func request(title: String) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            guard let request = self.createRequest(title) else { return }
            self.throwRequest(request)
        })
    }

    private func createRequest(title: String) -> NSMutableURLRequest? {
        let baseURLString = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=categories&titles=\(title)"
        let urlString = baseURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        guard let url = NSURL(string: urlString) else { return nil }
        return NSMutableURLRequest(URL: url)
    }

    func dataReceived(data: NSData?, error: ErrorType?) {
        delegate?.wikipediaAPIClientDidReceivedData(data, error: error)
    }
}
