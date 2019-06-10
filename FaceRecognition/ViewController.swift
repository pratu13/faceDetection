//
//  ViewController.swift
//  FaceRecognition
//
//  Created by pratyush sharma on 04/06/19.
//  Copyright © 2019 pratyush sharma. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var mytextview: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        detect()
        // Do any additional setup after loading the view.
    }

    @IBAction func `import`(_ sender: Any) {
        
        //Create an image picker
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        //display the image picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            myImageView.image = image
        }
        detect()
        self.dismiss(animated: true, completion: nil)
    }
    
    func detect(){
        
        //get image from image view
        let image = CIImage(image: myImageView.image!)!
        
        
        //set up the detector
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        
        let faces = faceDetector?.features(in: image, options: [CIDetectorSmile:true])
        
        if !faces!.isEmpty{
            
            for face in faces as! [CIFaceFeature]
            {
                let isSmilimg = "\nPerson is smiling: \(face.hasSmile)"
                let mouthShowing = "\nMouth is showing: \(face.hasMouthPosition)"
                var bothEyesShowing = "\nBoth eyes showing: true"
                
                if !face.hasRightEyePosition || !face.hasLeftEyePosition{
                    bothEyesShowing = "\nBoth eyes showing: false"
                }
                
                let array = ["low","medium","high","very high"]
                //Degree of suspiciousness
                var suspectDegree = 0
                
                if !face.hasMouthPosition {
                    suspectDegree += 1
                }
                if !face.hasSmile {suspectDegree += 1 }
                if bothEyesShowing.contains("false") {
                    suspectDegree += 1
                }
                
                if face.faceAngle > 10 || face.faceAngle < -10{
                    suspectDegree += 1
                }
                
                let suspectText = "\nSuspiciousness: \(array[suspectDegree])"
                
                
                mytextview.text = "\(suspectText) \n\(mouthShowing)\(isSmilimg)\(bothEyesShowing)"
            }
            
        }
        else{
            mytextview.text = "\nNO FACES DETECTED!"
        }
        
    }
}

