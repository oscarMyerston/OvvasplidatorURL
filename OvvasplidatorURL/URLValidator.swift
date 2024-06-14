//
//  URLValidator.swift
//  OvvasplidatorURL
//
//  Created by Oscar David Myerston Vega on 13/06/24.
//

import Foundation

class URLValidator {
    private let allowedSchemes = ["https"]
    private let allowedDomains = ["example.com", "trusted.com"]
    private let maxLength = 2048
    private let dangerousCharacters = CharacterSet(charactersIn: "<>{}\"\\^`|")
    private let reservedPaths = ["/admin", "/config", "/setup"]
    private let allowedQueryParameters = ["param1", "param2", "param3"]
    private let allowedPorts: [Int] = [80, 443]
    
    private func isLocalAddress(_ url: URL) -> Bool {
        guard let host = url.host else { return false }
        return host == "localhost" || host == "127.0.0.1" || host == "::1"
    }
    
    private func containsEscapeSequences(_ urlString: String) -> Bool {
        return urlString.contains("%")
    }
    
    private func containsOpenRedirect(_ url: URL) -> Bool {
        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else {
            return false
        }
        
        for item in queryItems {
            if item.name == "redirect_uri", let value = item.value {
                // Verificar si el valor de 'redirect_uri' es una URL válida
                if let redirectURL = URL(string: value), redirectURL.scheme != nil {
                    // Verificar si el esquema es seguro
                    if isSafeScheme(redirectURL.scheme!) {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    private func isSafeScheme(_ scheme: String) -> Bool {
        let safeSchemes = ["http", "https", "ftp", "ftps", "mailto"]
        return safeSchemes.contains(scheme.lowercased())
    }
    
    
    func validate(urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        guard urlString.count <= maxLength else { return false }
        guard urlString.rangeOfCharacter(from: dangerousCharacters) == nil else { return false }
        guard !containsEscapeSequences(urlString) else { return false }
        guard let scheme = url.scheme, allowedSchemes.contains(scheme) else { return false }
        guard let host = url.host, allowedDomains.contains(host) else { return false }
        guard !reservedPaths.contains(url.path) else { return false }
        guard !containsOpenRedirect(url) else { return false }
        if let queryItems = URLComponents(string: urlString)?.queryItems {
            for item in queryItems {
                if !allowedQueryParameters.contains(item.name) {
                    return false
                }
            }
        }
        guard !isLocalAddress(url) else { return false }
        if let port = url.port, !allowedPorts.contains(port) { return false }
        guard url.fragment == nil else { return false }
        
        return true
    }
}

extension URLValidator {
    func getMaxURLLength() -> Int {
        return maxLength
    }
    
    func testcontainsOpenRedirect(url: String) -> Bool {
        guard let url = URL(string: url) else { return false }
        return self.containsOpenRedirect(url)
    }
}
