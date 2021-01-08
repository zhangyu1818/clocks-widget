//
//  Image.swift
//  Clocks
//
//  Created by ZhangYu on 2021/1/6.
//

import Foundation
import SwiftUI

func saveImage(imageName: String, image: UIImage, onCompleted: ((URL) -> Void)?) {
    guard let documentsDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.zhangyu1818.clocks") else { return }

    let fileName = imageName
    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    guard let data = image.jpegData(compressionQuality: 1) else { return }

    // Checks if file exists, removes it if so.
    if FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
            print("Removed old image")
        } catch let removeError {
            print("couldn't remove file at path", removeError)
        }
    }

    do {
        try data.write(to: fileURL)
        onCompleted?(fileURL)
    } catch {
        print("error saving file with error", error)
    }
}

func cropImage(
    _ inputImage: UIImage,
    toRect cropRect: CGRect,
    viewWidth: CGFloat = UIScreen.main.bounds.width,
    viewHeight: CGFloat = UIScreen.main.bounds.height
) -> UIImage? {
    let imageViewScale = max(inputImage.size.width / viewWidth,
                             inputImage.size.height / viewHeight)

    // Scale cropRect to handle images larger than shown-on-screen size
    let cropZone = CGRect(x: cropRect.origin.x * imageViewScale,
                          y: cropRect.origin.y * imageViewScale,
                          width: cropRect.size.width * imageViewScale,
                          height: cropRect.size.height * imageViewScale)

    // Perform cropping in Core Graphics
    guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to: cropZone)
    else {
        return nil
    }

    // Return image to UIImage
    let croppedImage = UIImage(cgImage: cutImageRef)
    return croppedImage
}
