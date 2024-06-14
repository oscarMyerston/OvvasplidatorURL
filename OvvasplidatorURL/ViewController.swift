//
//  ViewController.swift
//  OvvasplidatorURL
//
//  Created by Oscar David Myerston Vega on 13/06/24.
//

import UIKit

class ViewController: UIViewController {

    var validationLabel: UILabel!
    let urlValidator = URLValidator()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Ejemplo de validación de URL
       // let urlString = "https://example.com/resource?param1=value1"
        //let urlString = "https://localhost"
        let urlString = "https://example.com/<script>alert('XSS')</script>"

        validateAndDisplayResult(for: urlString)
    }

    func setupUI() {
        // Crear y configurar el UILabel
        validationLabel = UILabel()
        validationLabel.translatesAutoresizingMaskIntoConstraints = false
        validationLabel.textAlignment = .center
        validationLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(validationLabel)

        // Configurar restricciones
        NSLayoutConstraint.activate([
            validationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            validationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            validationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            validationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    func validateAndDisplayResult(for urlString: String) {
        let isValid = urlValidator.validate(urlString: urlString)
        validationLabel.text = isValid ? "La URL es válida" : "La URL no es válida"
        validationLabel.textColor = isValid ? .green : .red
    }
}

