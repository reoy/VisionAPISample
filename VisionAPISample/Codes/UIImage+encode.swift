//
//  UIImage+encode.swift
//  VisionAPISample
//
//  Created by 吉田麗央 on 2016/03/23.
//  Copyright © 2016年 吉田麗央. All rights reserved.
//

import UIKit

extension UIImage {
    
    func base64EncodeImage() -> String {
        var imagedata = UIImagePNGRepresentation(self)
        
        if (imagedata?.length > 2097152) {
            let oldSize: CGSize = self.size
            let newSize: CGSize = CGSizeMake(800, oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: self)
        }
        
        return imagedata!.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
    }
    
    private func resizeImage(imageSize: CGSize, image: UIImage) -> NSData {
        UIGraphicsBeginImageContext(imageSize)
        image.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}