//
//  OvvasplidatorURLTests.swift
//  OvvasplidatorURLTests
//
//  Created by Oscar David Myerston Vega on 13/06/24.
//

import XCTest
@testable import OvvasplidatorURL

final class OvvasplidatorURLTests: XCTestCase {

    func testValidURL() {
        let validator = URLValidator()
        XCTAssertTrue(validator.validate(urlString: "https://example.com"))
        XCTAssertTrue(validator.validate(urlString: "https://trusted.com/resource"))
    }

    func testInvalidScheme() {
        let validator = URLValidator()
        XCTAssertFalse(validator.validate(urlString: "http://example.com"))
        XCTAssertFalse(validator.validate(urlString: "ftp://example.com"))
    }

    func testInvalidDomain() {
        let validator = URLValidator()
        XCTAssertFalse(validator.validate(urlString: "https://evil.com"))
    }

    func testMaxLengthExceeded() {
        let validator = URLValidator()

        let longURL = "https://" + String(repeating: "a", count: validator.getMaxURLLength() + 1)
        debugPrint(" --- longURL: \(longURL)")
        XCTAssertFalse(validator.validate(urlString: longURL))
    }

    func testDangerousCharacters() {
        let validator = URLValidator()

        XCTAssertFalse(validator.validate(urlString: "https://example.com/<script>alert('XSS')</script>"))
    }

    func testContainsEscapeSequences() {
        let validator = URLValidator()
        
        XCTAssertFalse(validator.validate(urlString: "https://example.com/%27"))
    }

    func testReservedPaths() {
        let validator = URLValidator()

        XCTAssertFalse(validator.validate(urlString: "https://example.com/admin"))
        XCTAssertFalse(validator.validate(urlString: "https://example.com/config"))
        XCTAssertFalse(validator.validate(urlString: "https://example.com/setup"))
    }

    func testOpenRedirect() {
        let validator = URLValidator()

        XCTAssertFalse(validator.validate(urlString: "https://example.com/resource?redirect_uri=http://malicious-site.com"))
    }

    func testInvalidQueryParameters() {
        let validator = URLValidator()

        XCTAssertFalse(validator.validate(urlString: "https://example.com/resource?param1=value1&invalid_param=value2"))
    }

    func testLocalAddress() {
        let validator = URLValidator()

        XCTAssertFalse(validator.validate(urlString: "https://localhost"))
        XCTAssertFalse(validator.validate(urlString: "https://127.0.0.1"))
        XCTAssertFalse(validator.validate(urlString: "https://[::1]"))
    }

    func testInvalidPort() {
        let validator = URLValidator()

        XCTAssertFalse(validator.validate(urlString: "https://example.com:8080"))
    }

    func testFragment() {
        let validator = URLValidator()

        XCTAssertFalse(validator.validate(urlString: "https://example.com#fragment"))
    }

    func testURLValidatorDoesNotLeak() {
        // Creamos un expectation para esperar a que se libere el objeto
        let expectation = self.expectation(description: "URLValidator deallocated")

        // Creamos una débil referencia para verificar si se libera correctamente
        var validator: URLValidator? = URLValidator()
        weak var weakValidator = validator

        // Ejecutamos un ciclo de autoreleasepool para forzar la liberación de la instancia
        autoreleasepool {
            // Ejecutamos alguna lógica con el validator si es necesario
            XCTAssertNotNil(validator)

            // Liberamos la referencia al validator
            validator = nil
        }

        // Esperamos un poco para que el autoreleasepool haga efecto
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Comprobamos que la referencia débil sea nil, lo que indica que el objeto fue liberado correctamente
            XCTAssertNil(weakValidator)
            expectation.fulfill()
        }

        // Esperamos la expectativa
        waitForExpectations(timeout: 1.0, handler: nil)
    }

}


/**
 Explicación de los Tests
 testValidURL: Verifica que las URLs con esquema https y dominios permitidos (example.com, trusted.com) sean válidas.

 testInvalidScheme: Comprueba que las URLs con esquemas no permitidos (http, ftp) sean inválidas.

 testInvalidDomain: Asegura que las URLs con dominios no permitidos (evil.com) sean inválidas.

 testMaxLengthExceeded: Valida que las URLs con una longitud superior al máximo (2048) sean inválidas.

 testDangerousCharacters: Detecta URLs que contienen caracteres peligrosos (<>{}"\\^``|) y las marca como inválidas.

 testContainsEscapeSequences: Rechaza URLs que contienen secuencias de escape (%27).

 testReservedPaths: Verifica que las URLs que incluyen rutas reservadas (/admin, /config, /setup) sean inválidas.

 testOpenRedirect: Detecta URLs que contienen parámetros de consulta que podrían ser usados para redirecciones abiertas y las marca como inválidas.

 testInvalidQueryParameters: Rechaza URLs que contienen parámetros de consulta no permitidos (invalid_param).

 testLocalAddress: Asegura que las URLs que apuntan a direcciones locales (localhost, 127.0.0.1, ::1) sean inválidas.

 testInvalidPort: Verifica que las URLs que especifican puertos no permitidos (8080) sean inválidas.

 testFragment: Rechaza URLs que contienen fragmentos (#fragment).


 */
