//
//  ViewController.swift
//  FrontendIOS
//
//  Created by Jovem Tranquilão on 01/08/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nome: UITextField!
    
    @IBOutlet weak var senha: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chefe: UIButton!
    
    @IBOutlet weak var chefeMenu: UIMenu!
    
    private var colaboradorList: [ColaboradorDTO]?
    
    private var apiService = ApiService()
        
    let cellReuseIdentifier = "cell"

        
    override func viewDidLoad() {
        super.viewDidLoad()
        listarTodos()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
          
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    public func listarTodos() {
        // Do any additional setup after loading the view.
        
        apiService.listarTodos { [weak self] (colaboradorList) in
            self?.colaboradorList = colaboradorList
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.carregarCombos()
            }
        }
    
    }
    
    public func carregarCombos(){
       let colaboradorOptions: [UIAction] = colaboradorList?.map { colaborador in
           UIAction(title: colaborador.nome, image: UIImage(systemName: "person")) { _ in
               // Lógica a ser executada ao selecionar um colaborador
               // Você pode acessar o colaborador selecionado através do parâmetro _
               // Por exemplo: print("Colaborador selecionado: \(colaborador.nome)")
           }
       } ?? []
        
       chefeMenu = UIMenu(
            title: "Selecione um Colaborador",
            children: colaboradorOptions
       )
        
        //chefeMenu.replacingChildren(colaboradorOptions)
        
        chefe.addTarget(self, action: #selector(showChefeMenu(_:)), for: .touchUpInside)

    }
    
    @objc func showChefeMenu(_ sender: UIButton) {
       let chefeMenuController = UIMenuController.shared
       chefeMenuController.showMenu(from: chefe, rect: chefe.bounds)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.colaboradorList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell? {
            cell.textLabel?.text = self.colaboradorList?[indexPath.row].nome ?? ""
            return cell
        } else {
           return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nome = self.colaboradorList?[indexPath.row].nome
        print("You tapped cell number \(nome).")
    }

  
}

