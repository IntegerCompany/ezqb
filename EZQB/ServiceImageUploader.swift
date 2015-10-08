//
//  ServiceImageUploader.swift
//  EZQB
//
//  Created by RomanSorochak on 05.08.15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import UIKit

//class ServiceImageUploader {
//
//    class func uploadImage(image: UIImage, withName name: String,
//        completionHandler: (data: NSData?, response: NSURLResponse!, error: NSError?) ->Void) {
//
//            let photo = self.compressForUploadImage(image, scale: 0.5)
//
////            let url: NSURL? = WebServiceURLFactory.urlUserPhotoUploadWithSessionID(sessionID, isPrivate: isPrivate, isProfile: isProfile)
//            let url: NSURL? = NSURL(string: "http://ezquickbooksonline.com/httpdocs/wp-content/plugins/wp-client/pluginajax.php?user_id=sev&filename1=filename12346&p=d9arf80q9294oijhafafs")
//
//            if url == nil {
//
//                completionHandler(data: nil, response: NSURLResponse(), error: NSError(domain: "invalid url", code: 0, userInfo: nil))
//            } else {
//
//                let contentType = String(format:"multipart/form-data; boundary=%@", "------------0xKhTmLbOuNdArY")
//                let boundaryDataStr = String(format:"--%@\r\n", "------------0xKhTmLbOuNdArY").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//                let imgHeaderDataStr = String(format:"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", "photo").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//                let imgContentType = String("Content-Type: image/jpeg\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//
//                let body = NSMutableData()
//                body.appendData(boundaryDataStr!)
//                body.appendData(boundaryDataStr!)
//                body.appendData(imgHeaderDataStr!)
//                body.appendData(imgContentType!)
//                body.appendData(UIImageJPEGRepresentation(photo, 1.0))
//                body.appendData(String("\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
//                body.appendData(boundaryDataStr!)
//
//                let urlRequest = NSMutableURLRequest(URL: url!)
//                urlRequest.HTTPMethod = "POST"
//                urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
//                urlRequest.HTTPBody = body
//
//                NetworkFetcher.uploadDataWithURLRequest(urlRequest,
//                    data: body,
//                    withCompletion: { (data, response, error) -> Void in
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        completionHandler(data: data, response: response, error: error)
//                    })
//                })
//            }
//    }
//
//    private class func compressForUploadImage(original: UIImage, scale: CGFloat) -> UIImage {
//
//        // Calculate new size given scale factor.
//        let originalSize: CGSize = original.size
//        let newSize: CGSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale)
//
//        // Scale the original image to match the new size.
//        UIGraphicsBeginImageContext(newSize)
//        original.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
//        let compressedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return compressedImage
//    }
//}

class ServiceImageUploader {
    
    class func uploadImage(originalImage: UIImage, withName name: String,
        completionHandler: (data: NSData?, response: NSURLResponse!, error: NSError?) ->Void) {
            
            let compressedImage = self.compressForUploadImage(originalImage, scale: 0.5)
            
//            let url: NSURL? = NSURL(string: "http://ezquickbooksonline.com/httpdocs/wp-content/plugins/wp-client/pluginajax.php?user_id=sev&filename1=filename12346&p=d9arf80q9294oijhafafs")
            
            let url: NSURL? = NSURL(string: "http://ezquickbooksonline.com/httpdocs/wp-content/plugins/wp-client/pluginajax_ios.php?user_id=26&filename1=image.jpg&p=d9arf80q9294oijhafafs")
            
            if url == nil {
                
                completionHandler(data: nil, response: NSURLResponse(),
                    error: NSError(domain: "invalid url", code: 0, userInfo: nil)
                )
            } else {
                
                let contentType = String(format:"multipart/form-data; boundary=%@", "------------0xKhTmLbOuNdArY")
                let boundaryDataStr = String(format:"--%@\r\n", "------------0xKhTmLbOuNdArY").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                let imgHeaderDataStr = String(format:"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", "photo").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                let imgContentType = String("Content-Type: image/jpeg\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                
                let body = NSMutableData()
                body.appendData(boundaryDataStr!)
                body.appendData(boundaryDataStr!)
                body.appendData(imgHeaderDataStr!)
                body.appendData(imgContentType!)
                body.appendData(UIImageJPEGRepresentation(compressedImage, 1.0)!)
                body.appendData(String("\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                body.appendData(boundaryDataStr!)
                
                let urlRequest = NSMutableURLRequest(URL: url!)
                urlRequest.HTTPMethod = "PUT"
                urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
                urlRequest.HTTPBody = body
                
                NetworkFetcher.uploadDataWithURLRequest(urlRequest,
                    data: body,
                    withCompletion: completionHandler
                )
            }
    }
    
    
    private class func compressForUploadImage(original: UIImage, scale: CGFloat) -> UIImage {
        
        // Calculate new size given scale factor.
        let originalSize: CGSize = original.size
        let newSize: CGSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale)
        
        // Scale the original image to match the new size.
        UIGraphicsBeginImageContext(newSize)
        original.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let compressedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return compressedImage
    }
}
