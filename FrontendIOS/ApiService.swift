//
//  ApiService.swift
//  FrontendIOS
//
//  Created by Jovem Tranquilão on 04/08/23.
//

import Foundation

class ApiService {
    public func listarTodos(completionHandler: @escaping ([ColaboradorDTO]) -> Void) {
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
    
    func save(nome: String, senha: String, viewController: ViewController) {
      
      // declare the parameter as a dictionary that contains string as key and value combination. considering inputs are valid
      
      let parameters: [String: Any] = ["nome": nome, "senha": senha]
      
      // create the url with URL
      let url = URL(string: "http://192.168.2.4:8080")! // change server url accordingly
      
      // create the session object
      let session = URLSession.shared
      
      // now create the URLRequest object using the url object
      var request = URLRequest(url: url)
      request.httpMethod = "POST" //set http method as POST
      
      // add headers for the request
      request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      do {
        // convert parameters to Data and assign dictionary to httpBody of request
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
      } catch let error {
        print(error.localizedDescription)
        return
      }
      
      // create dataTask using the session object to send data to the server
      let task = session.dataTask(with: request) { data, response, error in
        
        if let error = error {
          print("Post Request Error: \(error.localizedDescription)")
          return
        }
        
        // ensure there is valid response code returned from this HTTP response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode)
        else {
          print("Invalid Response received from the server")
          return
        }
        
        // ensure there is data returned
        guard let responseData = data else {
          print("nil Data received from the server")
          return
        }
        
        do {
          // create json object from data or use JSONDecoder to convert to Model stuct
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
      // perform the task
      task.resume()
      viewController.limparCampos()
    }

    
}
