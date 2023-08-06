//
//  ViewController.swift
//  FrontendIOS
//
//  Created by Jovem Tranquilão on 01/08/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nome: UITextField!
    
    @IBOutlet weak var senha: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chefe: UIPickerView!
    
    @IBOutlet weak var subordinado: UIPickerView!
    
    var chefeSelecionado : Int?;
    
    var subordinadoSelecionado : Int?;
        
    private var colaboradorList: [ColaboradorDTO]?
    
    private var apiService = ApiService()
        
    let cellReuseIdentifier = "cell"

        
    override func viewDidLoad() {
        super.viewDidLoad()
        listarTodos()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
          
        tableView.delegate = self
        tableView.dataSource = self
        
        chefe.delegate = self
        chefe.dataSource = self
        
        subordinado.delegate = self
        subordinado.dataSource = self
        
    }
    
    public func listarTodos() {
        // Do any additional setup after loading the view.
        
        apiService.listarTodos { [weak self] (colaboradorList) in
            self?.colaboradorList = colaboradorList
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.chefe.reloadAllComponents()
                self?.subordinado.reloadAllComponents()
            }
        }
    
    }
    
    func pickerView(
        _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.isEqual(chefe)){
            chefeSelecionado = row
        }
        else if(pickerView.isEqual(subordinado)){
            subordinadoSelecionado = row
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
    
    @IBAction func asssociarChefe(_ sender: Any) {
        var colaboradorChefe  = colaboradorList?[chefeSelecionado ?? 0]
        var colaboradorSubordinado = colaboradorList?[subordinadoSelecionado ?? 0]
        apiService.associarChefe(
            chefe: colaboradorChefe!,
            subordinado: colaboradorSubordinado!,
            viewController: self
        )
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.colaboradorList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell? {
            cell.textLabel?.text = self.colaboradorList?[indexPath.row].nome ?? ""
            cell.textLabel?.text! += " chefe: "
            cell.textLabel?.text! += self.colaboradorList?[indexPath.row].chefe?.nome ?? ""

            return cell
        } else {
           return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nome = self.colaboradorList?[indexPath.row].nome
        print("You tapped cell number \(nome).")
    }
    

    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colaboradorList?.count ?? 0
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colaboradorList?[row].nome ?? ""
    }


  
}

