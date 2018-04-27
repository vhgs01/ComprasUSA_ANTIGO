//
//  ShoppingRegisterViewController.swift
//  ComprasUSA
//
//  Created by Fellipe Soares Oliveira on 21/04/2018.
//  Copyright © 2018 Fellipe Soares Oliveira. All rights reserved.
//

import UIKit
import CoreData

class ShoppingRegisterViewController: UIViewController {
    
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var btRegister: UIButton!
    @IBOutlet weak var swPaymentForm: UISwitch!
    @IBOutlet weak var lbPrice: UITextField!
    @IBOutlet weak var lbName: UITextField!
    @IBOutlet weak var lbShoppingState: UITextField!
    @IBOutlet weak var btAddUpdate: UIButton!
    @IBOutlet weak var plusButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var btAddState: UIButton!
    
    // MARK: - Properties
    var product: Product!
    var smallImage                  : UIImage!
    var pickerView                  : UIPickerView!
    var fetchedResultController     : NSFetchedResultsController<State>!
    var dataSource                  : [State]?
    var backupWidth                 : CGFloat =  0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        if product != nil {
            lbName.text = product.name
            lbPrice.text = "\(product.price)"
            swPaymentForm.isOn = product.paymentForm
            btAddUpdate.setTitle("Atualizar", for: .normal)
            if let image = product.photo as? UIImage {
                ivPhoto.image = image
            }
        }
        
    }
    func checkState() {
        if let data = dataSource, data.count <= 0 {
            btAddState.isHidden         = false
            lbShoppingState.isHidden    = true
            plusButtonConstraint.constant = 0.0
            
        }
        else {
            btAddState.isHidden             = true
            lbShoppingState.isHidden        = false
            plusButtonConstraint.constant   = 22
            
        }
    }
    
    func config() {
     
        pickerView = UIPickerView() //Instanciando o UIPickerView
        pickerView.backgroundColor = .white
        pickerView.delegate = self  //Definindo seu delegate
        pickerView.dataSource = self  //Definindo seu dataSource
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        
        lbShoppingState.inputAccessoryView = toolbar
        lbShoppingState.inputView = pickerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let text = lbShoppingState.text?.isEmpty, !text {
            lbShoppingState.text = ""
        }
        
        loadStates()
        checkState()
    }
    
    // MARK:  Methods
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
            dataSource = fetchedResultController!.fetchedObjects!
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func cancel() {
        lbShoppingState.resignFirstResponder()
    }
    
    @objc func done() {
        if let data = dataSource, data.count > 0 {
            if let name = data[pickerView.selectedRow(inComponent: 0)].name {
                lbShoppingState.text = name
            }
        }
        
        cancel()
    }
    
    // MARK: - IBActions
    @IBAction func addPhoto(_ sender: UIButton) {
        //Criando o alerta que será apresentado ao usuário
        let alert = UIAlertController(title: "Selecionar Imagem", message: "De onde você quer escolher a imagem?", preferredStyle: .actionSheet)
        
        //Verificamos se o device possui câmera. Se sim, adicionamos a devida UIAlertAction
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        //As UIAlertActions de Biblioteca de fotos e Álbum de fotos também são criadas e adicionadas
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: UIButton?) {
        if product != nil && product.name == nil {
            context.delete(product)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addUpdateProduct(_ sender: UIButton) {
        if product == nil {
            product = Product(context: context)
        }
        
        if let name = lbName.text, let priceString = lbPrice.text, let price = Double(priceString) {
            product.name            = name
            product.price           = price
            product.paymentForm     = swPaymentForm.isOn
        }
        
        if smallImage != nil {
            product.photo = smallImage
        }
        
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
        
        close(nil)
    }
    @IBAction func registerAction(_ sender: Any) {
        performSegue(withIdentifier: "segueToRegisterState", sender: nil)
    }
    

}

// MARK: - UIImagePickerControllerDelegate
extension ShoppingRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        //Atribuímos a versão reduzida da imagem à variável smallImage
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivPhoto.image = smallImage //Atribuindo a imagem à ivPhoto
        
        //Aqui efetuamos o dismiss na UIImagePickerController, para retornar à tela anterior
        dismiss(animated: true, completion: nil)
    }
}

extension ShoppingRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Retornando o texto recuperado do objeto dataSource, baseado na linha selecionada
        return fetchedResultController.object(at: IndexPath(row: row, section: 0)).name
    }
}

extension ShoppingRegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1    //Usaremos apenas 1 coluna (component) em nosso pickerView
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        
        if let data = dataSource, data.count > 0 {
            count = data.count
        }
        
        return count
        
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ShoppingRegisterViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}
