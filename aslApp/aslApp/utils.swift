//
//  utils.swift
//  ASLLearner
//
//  Created by Saishreeya Kantamsetty on 4/11/24.
//

import SwiftUI
import AVKit
import Vision
import CoreML

struct CameraView: UIViewControllerRepresentable {
    @Binding var prediction: String

    func makeUIViewController(context: Context) -> CameraViewController {
        let viewController = CameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // called if something in swiftui land changes
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(prediction: $prediction)
    }

    class Coordinator: NSObject, CameraViewControllerDelegate {
        @Binding var prediction: String

        init(prediction: Binding<String>) {
            _prediction = prediction
        }

        func didDetectGesture(_ gesture: String) {
            DispatchQueue.main.async {
                self.prediction = gesture
            }
        }
    }
}

protocol CameraViewControllerDelegate: AnyObject {
    func didDetectGesture(_ gesture: String)
}

// AVCaptureSession gives you real time caputring
class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    weak var delegate: CameraViewControllerDelegate?
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    
    //making a private instance of the ML Model Prototpye and the name is model
    private let model: Prototype = {
        guard let modelURL = Bundle.main.url(forResource: "Prototype", withExtension: "mlmodelc") else {
            fatalError("Failed to locate model file.")
        }
        do {
            let model = try Prototype(contentsOf: modelURL)
            return model
        } catch {
            fatalError("Failed to load model: \(error)")
        }
    }()

    //view did load is an in built function in UI View Controller. It calls setupCamera() method to initialize the camera
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    //
    private func setupCamera() {
        // checks if front camera is available
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            fatalError("No front camera available")
        }

        // AVCaputureDeviceInput captures audio or video from a device (connects app to camera alloweing you to capture what shreeya sees
        // This makes an instance of AVCaptureDeviceInput and takes in a camera as its device
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Unable to access front camera")
        }

        // sets sessionPreset to .high which represents quality and resolution
        captureSession.sessionPreset = .high

        // adds camera input to the session
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        } else {
            fatalError("Couldn't add input")
        }
        
        // viewController in CameraView calls on this and so that is what self is referring to.
        // the method that videoOutput calls basically lets the camera know everytime something new is caputered
        // that is important so that the camera can know when to proceed to the next method with this new information
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))

        // add videoOutput if it is able to to the session
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("Couldn't add output")
        }

        // previewLayer shows what the camera is looking at
        // this is what creates an AVCaputerVideoPreviewLayer to display camera feed
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds // Add this line
        view.layer.addSublayer(previewLayer)
        
        /// this starts showing your view that the camera is ready to go and set up
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    // this method is called when a new video frame is captured
    // the 3 parameteres are: output which is the the AVCaptureOutput that is captured in the video frame, sampleBuffer which is the video frame captured, stored as a CMSampleBuffer, and connection which is the AVCaptureConnection used to capture the frame
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // converts CMSampleBufferGetImageBuffer to CVPixelBuffer so that the capture input is easier to work with.
        // sampleBuffer is the the video frame
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        //result is stored in prediction
        guard let prediction = predict(pixelBuffer: pixelBuffer) else {
            return
        }
        
        //delegat = manages or passes informatino between parts of the app
        //didDetectGesture = calls a method named didDetectGesture on teh delegate and passes the prediction result ot it
        //probs telling another part of the app saying we detected this gesture
        delegate?.didDetectGesture(prediction)
    }
    
    private func checkPixelBufferFormat(pixelBuffer: CVPixelBuffer) {
        guard let pixelFormat = Optional(CVPixelBufferGetPixelFormatType(pixelBuffer)) else {
            print("Failed to retrieve pixel buffer format")
            return
        }

        switch pixelFormat {
            case kCVPixelFormatType_32BGRA:
                print("Pixel buffer format: 32BGRA")
            case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange:
                print("Pixel buffer format: 420YpCbCr8BiPlanarVideoRange")
            case kCVPixelFormatType_32ARGB:
                print("Pixel buffer format: 32ARGB")
            case kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:
                print("Pixel buffer format: 420YpCbCr8BiPlanarFullRange")
            case kCVPixelFormatType_32RGBA:
                print("Pixel buffer format: 32RGBA")
            case kCVPixelFormatType_422YpCbCr8:
                print("Pixel buffer format: 422YpCbCr8")
            // Add more cases as needed for other formats
            default:
                print("Pixel buffer format: Unknown (\(pixelFormat))")
            }
    }
    
    private func reshapeMultiArray(_ multiArray: MLMultiArray) throws -> MLMultiArray {
        let newShape = [1920, 1080, 1] as [NSNumber]
        guard multiArray.count == newShape.reduce(1, { $0 * $1.intValue }) else {
            throw NSError(domain: "com.asllearnerapp", code: 2, userInfo: [NSLocalizedDescriptionKey: "Mismatched array size"])
        }
        
        let reshapedArray = try MLMultiArray(shape: newShape, dataType: multiArray.dataType)
        
        var newIndex = 0
        for channel in 0..<3 {
            for x in 0..<21 {
                for y in 0..<1 { // batchSize = 1
                    let index = y * 3 * 21 + channel * 21 + x
                    reshapedArray[newIndex] = multiArray[index]
                    newIndex += 1
                }
            }
        }
        
        return reshapedArray
    }


    
    // this whole function converts a CVPixelBuffer into MULMultiArray
    private func convertPixelBuffer(toMultiArray pixelBuffer: CVPixelBuffer) throws -> MLMultiArray {
        checkPixelBufferFormat(pixelBuffer: pixelBuffer)

        // Create a CIImage from the CVPixelBuffer
        guard let ciImage = Optional(CIImage(cvPixelBuffer: pixelBuffer).oriented(.right)) else {
            print("Failed to create CIImage from pixel buffer")
            throw NSError(domain: "com.asllearnerapp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create CIImage from pixel buffer"])
        }

        // Create a CGImage from the CIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            print("Failed to create CGImage from CIImage")
            throw NSError(domain: "com.asllearnerapp", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to create CGImage from CIImage"])
        }

        // Get the dimensions of the original image
        let imageWidth = cgImage.width
        let imageHeight = cgImage.height

        // Resize the CGImage to the expected input size of the Core ML model (21x21 in this example)
        let targetSize = CGSize(width: 21, height: 21)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let resizeContext = CGContext(data: nil, width: Int(targetSize.width), height: Int(targetSize.height), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo.rawValue)!
        resizeContext.draw(cgImage, in: CGRect(origin: .zero, size: targetSize))
        let resizedImage = resizeContext.makeImage()!

        // Get pixel data from the resized CGImage
        guard let dataProvider = resizedImage.dataProvider else {
            print("Failed to get image pixel data")
            throw NSError(domain: "com.asllearnerapp", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to get image pixel data"])
        }

        guard let imageData = dataProvider.data else {
            print("Failed to get image pixel data")
            throw NSError(domain: "com.asllearnerapp", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to get image pixel data"])
        }

        // Convert pixel data to UnsafeBufferPointer
        // Convert pixel data to UnsafeBufferPointer
        let bytePtr = CFDataGetBytePtr(imageData)
        let buffer = UnsafeBufferPointer<UInt8>(start: bytePtr, count: CFDataGetLength(imageData))

        // Convert pixel data to [Float] and normalize to [0, 1]
        var floatBuffer = [Float]()
        for byte in buffer {
            let floatPixelValue = Float(byte) / 255.0
            floatBuffer.append(floatPixelValue)
        }

        // Create MLMultiArray with the expected shape (1, 3, 21)
        let multiArray = try MLMultiArray(shape: [1, 3, 21] as [NSNumber], dataType: .float32)

        // Fill MLMultiArray with pixel values
        for index in 0..<multiArray.count {
            multiArray[index] = NSNumber(value: floatBuffer[index])
        }

        return multiArray
    }


    
    
    private func predict(pixelBuffer: CVPixelBuffer) -> String? {
        do {
            // Convert pixelBuffer to MLMultiArray
            guard let modelInput = try? convertPixelBuffer(toMultiArray: pixelBuffer) else {
                print("Failed to convert pixelBuffer to MLMultiArray")
                return nil
            }
            
            print("it passed this!!!")
            // Make a prediction using the model
            let prediction = try model.prediction(poses: modelInput).labelProbabilities
            print("this is the prediction", prediction)
            
            // Find the index of the highest probability in the prediction
            var topValue: Float = 0.0
            var topIndex: Int = -1

            for (index, value) in prediction.enumerated() {
                let floatValue = Float(value.value)
                
                if floatValue > topValue {
                    topValue = floatValue
                    topIndex = index
                }
            }
            
            // Return the index with the highest probability
            if topIndex != -1 {
                return "\(topIndex)"
            } else {
                print("Failed to find top prediction index")
                return nil
            }


        } catch {
            print("Prediction error: \(error)")
            return nil
        }
    }

}
