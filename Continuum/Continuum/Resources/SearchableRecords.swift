//
//  SearchableRecords.swift
//  Continuum
//
//  Created by William Moody on 6/5/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import Foundation


protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
