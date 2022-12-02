//
//  ViewController.swift
//  FaceRecognition
//
//  Created by swag.ksss on 05.10.2022.
//

import UIKit
import CoreImage

class ViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBAction func `import`(_ sender: Any) {
        
        //Create image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        //display the image picker
        self.present(imagePicker,animated: true, completion :nil)
    }
    
    // Pick photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            myImageView.image = image
    }
        
        detect()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func detect()
    {
        // Get image from image view
        let myImage = CIImage(image : myImageView.image!)!
        
        //Set up the detector
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyLow]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: myImage, options:[ CIDetectorSmile : true])
        
        if  !faces!.isEmpty
        {
            for face in faces as! [CIFaceFeature]
            {
                let  moutShowing = "\nMouth is showing : \(face.hasMouthPosition)"
                let isSmiling = "\nPerson is smiling : \(face.hasSmile)"
                var bothEyesShowing = "\nBoth eyes showing : true"
                
                if !face.hasRightEyePosition || !face.hasLeftEyePosition
                {
                    bothEyesShowing = "\nBoth eyes showing : false"

                }
                
                //Degree of suspiciosness
                let array = ["Low","Medium","High","Very high"]
                var suspectDegree = 0
                
                if !face.hasMouthPosition {suspectDegree += 1}
                if !face.hasSmile{suspectDegree += 1}
                if bothEyesShowing.contains("false"){suspectDegree += 1}
                if face.faceAngle > 10 || face.faceAngle < -10 {suspectDegree += 1}
                
                let suspectText = "\nSuspiciousness : \(array[suspectDegree])"
                
                myTextView.text = "\(suspectText)\n\(moutShowing)\(isSmiling)\(bothEyesShowing)"
            }
        }
        
        else
        {
            myTextView.text = "No faces found"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detect()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

