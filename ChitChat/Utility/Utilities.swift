//
//  Utility.swift
//  ChitChat
//
//  Created by Shilpee Gupta on 10/01/23.
//

import Foundation

//easily throw generic errors with text description
extension String: LocalizedError {
    public var errorDescription: String?{
        return self
    }
}
