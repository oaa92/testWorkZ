//
//  Section+ext.swift
//  testWorkZx
//
//  Created by Анатолий on 08/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import Eureka

extension Section {
    var prefixForRowTag: String {
        return tag ?? "" + "."
    }
}
