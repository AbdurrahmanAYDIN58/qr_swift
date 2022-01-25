

/*class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
 {

    @IBOutlet weak var myImg: UIImageView!
    
  

   /* @IBAction func takePhoto(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }*/
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            myImg.contentMode = .scaleToFill
            myImg.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

   /* @IBAction func savePhoto(_ sender: AnyObject) {
        let imageData = UIImagePNGRepresentation(myImg.image!)
        let compressedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)

        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePhoto(_ sender: Any) { if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    }
    
    @IBAction func savePhoto(_ sender: Any) {
    }
}*/
//GalleryViewController class

import UIKit
import PDFKit

class GalleryViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var myImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var fileNameTextField: UITextField!
   
    var ImageArray : [UIImage] = []
    var picker = UIImagePickerController()

   

   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Select Photo", style: UIBarButtonItem.Style.plain, target: self, action: #selector(chooseImage))
        
        tableView.dataSource = self
        tableView.delegate = self
        //Looks for single or multiple taps.
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

           //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
           //tap.cancelsTouchesInView = false

           view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {

      
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func didTabSort(){
        if tableView.isEditing{
            tableView.isEditing = false
            
        }
        else{
            tableView.isEditing = true
        }
        
    }
    
    // pdf olarak kaydetmek için gerekli fonksiyon
    func createPDF(image: UIImage) -> NSData? {

        let pdfData = NSMutableData()
        let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
        
        let testHeight = image.size.height
        let test2height = testHeight * image.scale
        
        let testwith = image.size.width
        let test2with = testwith * image.scale

        var mediaBox = CGRect.init(x: 0, y: 0, width: test2with, height: test2height)

        let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!

        pdfContext.beginPage(mediaBox: &mediaBox)
        pdfContext.draw(image.cgImage!, in: mediaBox)
        pdfContext.endPage()

        return pdfData
    }
     
    func savePDF(someUIImageFile: [UIImage], fileName: String) -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let docURL = documentDirectory.appendingPathComponent("\(fileName).pdf")

        createPDFS(arrImages: someUIImageFile)?.write(to: docURL, atomically: true)
        
        return docURL
    }
    
    @IBAction func AddClicked(_ sender: Any) { self.ImageArray.append(myImg.image ?? UIImage())
        tableView.reloadData()
    }
    
    @objc func chooseImage() {
        
        
        self.picker.delegate = self
        self.picker.allowsEditing = true
        self.picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonTabbed(_ sender: Any) {
        let dataURL = savePDF(someUIImageFile: (ImageArray ?? []) as! [UIImage], fileName: fileNameTextField.text ?? "")
        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(activityItems: [dataURL], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
  
    func createPDFS(arrImages: [UIImage]) -> NSData? {

            var pageHeight = 0.0
            var pageWidth = 0.0

            for img in arrImages
            {
                pageHeight =  pageHeight+Double(img.size.height)

                if Double(img.size.width) > pageWidth
                {
                    pageWidth = Double(img.size.width)
                }
                
            }

            let pdfData = NSMutableData()
            let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
        

           var mediaBox = CGRect.init(x: 0, y: 0, width: pageWidth, height: pageHeight)

           let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!

            for img in arrImages
            {
                let testHeight = img.size.height
                let test2height = testHeight * img.scale
                
                let testwith = img.size.width
                let test2with = testwith * img.scale
 
                 var mediaBox2 = CGRect.init(x: 0, y: 0, width: test2with/*img.size.width*/, height: test2height/*img.size.height*/)

                       /* pdfContext.beginPage(mediaBox: &mediaBox2)
                pdfContext.draw(img.cgImage!, in: CGRect.init(x: 0.0, y: 0, width: pageWidth, height: Double(img.size.height)))

             pdfContext.endPage()*/
                pdfContext.beginPage(mediaBox: &mediaBox2)
                pdfContext.draw(img.cgImage!, in: mediaBox2)
                 pdfContext.endPage()
            }

            return pdfData
        }
    /*  @IBAction func pick(_ sender: Any) {
        
if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
        let picker = UIImagePickerController()
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    }*/
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let image = info[.originalImage] as? UIImage
    myImg.image = image
    

    self.dismiss(animated: true, completion: nil)
        
    
   /* if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
                    myImg.contentMode = .scaleToFill
                    myImg.image = pickedImage
            print("image")
                }
                picker.dismiss(animated: true, completion: nil)
            }*/
  }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        
        let table = self.ImageArray[indexPath.row]
        cell.ok.image = table
        cell.bk.text = String(indexPath.row + 1)
        return cell
}

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.ImageArray.count
}
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.beginUpdates()
            ImageArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
            tableView.reloadData()
            
        }
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
  
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        ImageArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        tableView.reloadData()
    }
    /*func tableView(_ IMDBTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let table = self.ImageArray[indexPath.row]
        let cell = UITableViewCell(
        let vc = cell.instantiateViewController(withIdentifier: String(describing: Cell.self) as! Cell,
       //vc.modalPresentationStyle = .custom
  
        vc.id = resultsViewModel.id
        vc.name = resultsViewModel.name
        self.present(vc, animated: true, completion: nil)

    }*/
}
