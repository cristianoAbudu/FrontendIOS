//
//  ViewController.swift
//  FrontendIOS
//
//  Created by Jovem Tranquilão on 01/08/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nome: UITextField!
    
    @IBOutlet weak var senha: UITextField!
    
    private var colaboradorList: [ColaboradorDTO]?
    
    private var apiService = ApiService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listarTodos()
    }
    
    public func listarTodos() {
        // Do any additional setup after loading the view.
        
        apiService.listarTodos { [weak self] (colaboradorList) in
            self?.colaboradorList = colaboradorList
            DispatchQueue.main.async {
                //self?.tableView.reloadData()
            }
        }
    }
    
    public func limparCampos() {
        nome.text = ""
        senha.text = ""
    }
    
    @IBAction func salvar(_ sender: UIButton) {
        apiService.save(
            nome: nome.text ?? "",
            senha:  senha.text ?? "",
            viewController: self
        )
    }

}

