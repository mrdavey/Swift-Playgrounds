//: Playground - noun: a place where people can play

import UIKit
import CoreImage

let image = #imageLiteral(resourceName: "1337f89c838985f1b18b3174edd8c100.jpg")

// Filter reference: https://developer.apple.com/library/prerelease/content/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html

func simpleFilter(inputImage: UIImage) -> UIImage {
    let inputCIImage = CIImage(image: inputImage)!

    /* Standard single filters */
//    let blurFilter = CIFilter(name: "CIGaussianBlur")!
//    blurFilter.setValue(inputCIImage, forKey: kCIInputImageKey)
//    blurFilter.setValue(8, forKey: kCIInputRadiusKey)

//    let filter = CIFilter(name: "CICMYKHalftone")!
//    filter.setValue(inputCIImage, forKey: kCIInputImageKey)
//    filter.setValue(25, forKey: kCIInputWidthKey)

//    let filter = CIFilter(name: "CICrystallize")!
//    filter.setValue(inputCIImage, forKey: kCIInputImageKey)
//    filter.setValue(55, forKey: kCIInputRadiusKey)
//
//    let outputImage = filter.outputImage!

    /* Combining multiple filters */
    let outputImage = inputCIImage
        .applyingFilter("CICrystallize", withInputParameters: [kCIInputRadiusKey: 50])
        .applyingFilter("CICMYKHalftone", withInputParameters: [kCIInputWidthKey: 35])

    return UIImage(ciImage: outputImage)
}

simpleFilter(inputImage: image)


/* Creating custom filters */

class CustomFilter: CIFilter {
    var inputImage: CIImage?

    override public var outputImage: CIImage! {
        get {
            if let inputImage = self.inputImage {
                let args = [inputImage as AnyObject]
                return createCustomKernel().apply(withExtent: inputImage.extent, arguments: args)
            } else {
                return nil
            }
        }
    }

    func createCustomKernel() -> CIColorKernel {
        let kernelString =
            "kernel vec4 chromaKey( __sample s) { \n" +
                "  vec4 newPixel = s.rgba;" +
                "  newPixel[0] = 0.0;" +
                "  newPixel[2] = newPixel[2] / 2.0;" +
                "  return newPixel;\n" +
        "}"
        return CIColorKernel(string: kernelString)!
    }
}

let filter = CustomFilter()
filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
let outputImage = filter.outputImage!

