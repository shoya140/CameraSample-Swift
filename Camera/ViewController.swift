//
//  ViewController.swift
//  Camera
//
//  Created by ishimaru on 2014/10/19.
//  Copyright (c) 2014年 shoya140. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet private weak var cameraPreviewView: UIView!
    
    var stillImageOutput: AVCaptureStillImageOutput!
    var session: AVCaptureSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureCamera() {
        var captureDevice: AVCaptureDevice?
        let devices: NSArray = AVCaptureDevice.devices()
        
        for device: AnyObject in devices{
            if device.position == AVCaptureDevicePosition.Back{
                captureDevice = device as? AVCaptureDevice
            }
        }
        if captureDevice == nil {
            NSLog("Missing Camera")
            return
        }
        
        var error: NSErrorPointer = nil
        var deviceInput = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: error) as AVCaptureDeviceInput
        self.stillImageOutput = AVCaptureStillImageOutput()
        self.session = AVCaptureSession()
        self.session.sessionPreset = AVCaptureSessionPresetPhoto
        self.session.addInput(deviceInput as AVCaptureInput)
        self.session.addOutput(self.stillImageOutput)
        
        let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(self.session) as AVCaptureVideoPreviewLayer
        previewLayer.frame = self.cameraPreviewView.bounds
        self.cameraPreviewView.layer.addSublayer(previewLayer)
        
        self.session.startRunning()
    }
    
    @IBAction func saveImage(sender: UIButton) {
        var videoConnection: AVCaptureConnection = self.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection,
            completionHandler: {imageDataSampleBuffer, error in
                if imageDataSampleBuffer == nil {
                    return
                }
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                let image = UIImage(data: imageData)
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        })
    }

}

