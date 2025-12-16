//
//  ToastView.swift
//  Lunchy
//
//  Created by Paulina Vara on 16/12/25.
//

import SwiftUI

struct ToastView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.green.opacity(0.95))
            .cornerRadius(22)
            .padding(.horizontal, 18)
            .padding(.bottom, 26)
    }
}
