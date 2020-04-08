//
//  UIImage.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 11/4/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /// Gets the average color of an UIImage
	// From https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
	var averageColor: UIColor? {
		// Resizing the image fixes an issue when rendering the context. The app could't allocate the IOSurface.
		guard let resizedImage = self.resized(toWidth: 25) else { return nil }
		
		guard let inputImage = CIImage(image: resizedImage) else { return nil }
		
		let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

		guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
		guard let outputImage = filter.outputImage else { return nil }

		var bitmap = [UInt8](repeating: 0, count: 4)
		let context = CIContext(options: [.workingColorSpace: kCFNull!])
		context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

		return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
	}
		
	// From https://nshipster.com/image-resizing/
	func resized(toWidth width: CGFloat) -> UIImage? {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height))))
		return renderer.image { (context) in
			self.draw(in: CGRect(origin: .zero, size: size))
		}
	}
}
