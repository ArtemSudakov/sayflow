//
//  SelectLangView.swift
//  sayflow
//
//  Created by Asd on 19.08.2025.
//


import SwiftUI


struct SelectLangView: View {
    @EnvironmentObject private var router: ViewsRouter
    
    var body: some View {
        VStack {
            Text("im lang select")
            Button {
                router.pop()
            } label: {
                Text("Go back")
                    .frame(width: 150, height: 44)
                    .background(Color.white)
                    .cornerRadius(12)
                    .foregroundStyle(Color("Gray44"))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    SelectLangView()
}
