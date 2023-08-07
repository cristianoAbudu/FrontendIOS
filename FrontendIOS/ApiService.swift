//
//  ApiService.swift
//  FrontendIOS
//
//  Created by Jovem Tranquilão on 04/08/23.
//

import Foundation

class ApiService {
    
    
    public func listarTodos(completionHandler: @escaping ([ColaboradorDTO]) -> Void) {
        
        let url = URL(string: "http://localhost:8082")!

       
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
    
    func save(nome: String, senha: String, viewController: ViewController) {
        
      let url = URL(string: "http://localhost:8084")!

      
      let parameters: [String: Any] = ["nome": nome, "senha": senha]
      
      let session = URLSession.shared
      
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
      } catch let error {
        print(error.localizedDescription)
        return
      }
        
      let task = session.dataTask(with: request) { data, response, error in
        
        if let error = error {
          print("Post Request Error: \(error.localizedDescription)")
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode)
        else {
          print("Invalid Response received from the server")
          return
        }
        
        guard let responseData = data else {
          print("nil Data received from the server")
          return
        }
        
        do {
          if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
            print(jsonResponse)
            viewController.listarTodos()

            // handle json response
          } else {
            print("data maybe corrupted or in wrong format")
            throw URLError(.badServerResponse)
          }
        } catch let error {
          print(error.localizedDescription)
        }
      }
      task.resume()
      viewController.limparCampos()
    }
    
    func associarChefe(chefe: ColaboradorDTO, subordinado: ColaboradorDTO, viewController: ViewController) {
      
      let parameters: [String: Any] = ["idChefe": chefe.id, "idSubordinado": subordinado.id]
      
      let session = URLSession.shared
        
      let url = URL(string: "http://localhost:8081/associaChefe")!

        var request = URLRequest(url: url)
      request.httpMethod = "POST"
      
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
      } catch let error {
        print(error.localizedDescription)
        return
      }
        
      let task = session.dataTask(with: request) { data, response, error in
        
        if let error = error {
          print("Post Request Error: \(error.localizedDescription)")
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode)
        else {
          print("Invalid Response received from the server")
          return
        }
        
        guard let responseData = data else {
          print("nil Data received from the server")
          return
        }
        
        do {
          if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
            print(jsonResponse)
            viewController.listarTodos()

            // handle json response
          } else {
            print("data maybe corrupted or in wrong format")
            throw URLError(.badServerResponse)
          }
        } catch let error {
          print(error.localizedDescription)
        }
      }
      task.resume()
      viewController.limparCampos()
    }

    
}
