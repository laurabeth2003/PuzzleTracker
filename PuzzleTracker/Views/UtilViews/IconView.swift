//
//  IconView.swift
//  NinjaFit
//
//  Created by Laura Erickson on 9/16/23.
//

import SwiftUI

/// Util to render an icon and text together
struct IconView: View {
    var icon: String
    var text: String
    
    var body: some View {
        Image(systemName: icon)
        Text(text)
    }
}
