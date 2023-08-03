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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        listarTodos { [weak self] (colaboradorList) in
              self?.colaboradorList = colaboradorList
          DispatchQueue.main.async {
            //self?.tableView.reloadData()
          }
        }
    }


    @IBAction func salvar(_ sender: UIButton) {
        print(nome.text)
        print(senha.text)
        //var colaboradorDTO = ColaboradorDTO()
    }
                        
    
    //https://www.freecodecamp.org/news/how-to-make-your-first-api-call-in-swift/
    func listarTodos(completionHandler: @escaping ([ColaboradorDTO]) -> Void) {
        let url = URL(string: "http://192.168.2.4:8080")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completionHandler([])
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                completionHandler([])
                return
            }

            if let data = data {
                do {
                    let colaboradorDTOList = try JSONDecoder().decode([ColaboradorDTO].self, from: data)
                    completionHandler(colaboradorDTOList)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completionHandler([])
                }
            } else {
                completionHandler([])
            }
        }

        task.resume()
    }


}

