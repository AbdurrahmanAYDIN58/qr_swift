//
//  ViewController.swift
//  qr
//
//  Created by ABDURRAHMAN AYDIN on 19.01.2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    var video = AVCaptureVideoPreviewLayer()
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var square: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        // Do any additional setup after loading the view.
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
            
            
            
        }
        catch{
            print("error")
            
            
        }
        

        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = cameraView.layer.bounds
        cameraView.layer.addSublayer(video)
        cameraView.bringSubviewToFront(square)
        session.startRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != nil
        {
            if let objecct = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if objecct.type == AVMetadataObject.ObjectType.qr
                {
                    let alert = UIAlertController(title: "QR Code", message: objecct.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "retake", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "copy", style: .default, handler: { (nil) in
                        UIPasteboard.general.string = objecct.stringValue
                    }))
                    present(alert, animated: true, completion: nil)
                    
                    
                }
            }
            
        }

}
    
    
    
    
    
    
    
}

