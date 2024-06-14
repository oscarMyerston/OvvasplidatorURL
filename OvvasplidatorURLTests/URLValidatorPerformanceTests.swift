//
//  URLValidatorPerformanceTests.swift
//  OvvasplidatorURLTests
//
//  Created by Oscar David Myerston Vega on 13/06/24.
//

import XCTest
@testable import OvvasplidatorURL

final class URLValidatorPerformanceTests: XCTestCase {

    let validator = URLValidator()
    let urlString = "https://example.com?redirect_uri=https://trusted.com"

    func testURLValidationPerformance() {
        measure {
            _ = validator.validate(urlString: urlString)
        }
    }

    func testURLValidationDetailedPerformance() {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric(), XCTStorageMetric()]) {
            _ = validator.validate(urlString: urlString)
        }
    }


    func testURLValidationPerformanceFull() {
        let validator = URLValidator()

        // Definimos una lista de URLs para probar
        let urlsToValidate = [
            // URLs válidas y seguras
            "https://example.com",
            "https://trusted.com/path/to/resource",
            "https://subdomain.example.com",

            // URLs con protocolos no permitidos
            "ftp://ftpserver.com/file.txt",

            // URLs con parámetros no permitidos
            "https://example.com?param1=value1&param2=value2",
            "https://example.com?param1=value1&admin=true",

            // URLs con caminos reservados
            "https://example.com/admin",
            "https://example.com/config",
            "https://example.com/setup",

            // URLs con redirecciones abiertas
            "https://example.com?redirect_uri=anotherurl.com",
            "https://example.com?redirect_uri=javascript:alert('XSS')",
            "https://example.com?redirect_uri=https://untrusted.com",

            // URLs con puertos no permitidos
            "https://example.com:8080",

            // URLs locales y privadas
            "https://localhost",
            "https://127.0.0.1",
            "https://::1",

            // URLs con fragmentos
            "https://example.com#section",

            // URLs con caracteres peligrosos
            "https://example.com/<script>alert('XSS')</script>",
            "https://example.com/{path}",
            "https://example.com\"path\"",
            "https://example.com\\path",
            "https://example.com^path",
            "https://example.com`path",
            "https://example.com|path",

            // URLs con escape sequences
            "https://example.com/%E3%80%80",

            // URLs con errores de sintaxis
            "https://example.com?invalid=url",
            "https://example.com/path??invalid",

            // URLs con múltiples vulnerabilidades combinadas
            "https://example.com/admin?redirect_uri=javascript:alert('XSS')",
            "https://example.com/config?param1=value1&admin=true",
            "https://example.com/setup#section?param1=value1&admin=true",

            "https://example.com?redirect_uri=https://malicious-site.com",
            "https://example.com/path?<script>alert('XSS')</script>",
            "https://example.com?action=delete&id=123",
            "https://example.com/users?name=' OR 1=1--",
            "https://example.com/admin",
            "https://example.com/admin/../user",
            "https://example.com/logs/debug.log",
            "https://example.com/uploads/malicious.exe",
            "https://example.com/api/customerDetails?id=1234",
            "http://example.com/config.php",
            "https://example.com/admin/login.php",
            "https://example.com/downloads/virus.exe",
            "https://example.com/.git/config",
            "https://example.com?cookie=admin=true",
            "http://example.com/script.js",
            "https://example.com/?allowAdminAccess=true"

        ]
        // Medimos el tiempo de ejecución para validar cada URL
        measure {
            _ = validator.validate(urlString: "https://example.com?param1=value1&admin=true")
            /*
            for urlString in urlsToValidate {
                _ = validator.validate(urlString: urlString)
                //XCTAssertTrue(isValid, "La URL \(urlString) debería ser válida")
            }
             */
        }
    }


}
