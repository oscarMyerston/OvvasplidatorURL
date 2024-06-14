//
//  ContainsOpenRedirectTests.swift
//  OvvasplidatorURLTests
//
//  Created by Oscar David Myerston Vega on 13/06/24.
//

import XCTest
@testable import OvvasplidatorURL

final class ContainsOpenRedirectTests: XCTestCase {

    func testNoQueryItems() {
        let validator = URLValidator()
        XCTAssertFalse(validator.testcontainsOpenRedirect(url: "https://example.com"))
    }

    func testNoRedirectURI() {
        let validator = URLValidator()
        XCTAssertFalse(validator.testcontainsOpenRedirect(url: "https://example.com?param1=value1"))
    }

    func testRedirectURIWithoutValue() {
        let validator = URLValidator()
        XCTAssertFalse(validator.testcontainsOpenRedirect(url: "https://example.com?redirect_uri="))
    }

    func testValidRedirectURI() {
        let validator = URLValidator()
        XCTAssertTrue(validator.testcontainsOpenRedirect(url: "https://example.com?redirect_uri=https://trusted.com"))
    }

    func testInvalidRedirectURI() {
        let validator = URLValidator()
        XCTAssertFalse(validator.testcontainsOpenRedirect(url: "https://example.com?redirect_uri=javascript:alert('XSS')"))
    }

    func testInvalidRedirectURI_full() {
        let validator = URLValidator()

        // Caso donde no hay parámetro 'redirect_uri'
        let urlStringNoRedirect = "https://example.com"
        XCTAssertFalse(validator.testcontainsOpenRedirect(url: urlStringNoRedirect))

        // Caso donde 'redirect_uri' no es una URL válida
        let urlStringInvalidRedirect = "https://example.com?redirect_uri=notavalidurl"
        XCTAssertFalse(validator.testcontainsOpenRedirect(url: urlStringInvalidRedirect))

        // Caso donde 'redirect_uri' tiene un esquema no seguro (javascript:)
        let urlStringXSSRedirect = "https://example.com?redirect_uri=javascript:alert('XSS')"
        XCTAssertFalse(validator.testcontainsOpenRedirect(url: urlStringXSSRedirect))
    }

    func testMultipleQueryItems() {
        let validator = URLValidator()
        XCTAssertTrue(validator.testcontainsOpenRedirect(url: "https://example.com?param1=value1&redirect_uri=https://trusted.com"))
    }

}
