//
//  DartModeView.swift
//  SwiftUITest
//
//  Created by justin on 2019/10/24.
//  Copyright © 2019 jlai. All rights reserved.
//

import SwiftUI

extension UIViewController {
    var isDarkModeEnabled : Bool {
        get {
            return traitCollection.userInterfaceStyle == .dark
        }
    }
}

// switch darmode refer: https://www.appcoda.com/dark-mode-preview/
struct DartModeView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            Color(UIColor(named: "accentColor")!)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text("Now, is")
                            .font(.system(size: 32, weight: .black))
                            .foregroundColor(Color(UIColor(named: "labelColor")!))
                            .multilineTextAlignment(.leading)
                        Text(colorScheme == .light ? "Light   " : "Dark   ")
                            .font(colorScheme == .light ?  Font.custom("Condiment-Regular", size: 98) : Font.custom("Superclarendon", size: 78))
                            .foregroundColor(Color(UIColor(named: "labelColor")!).opacity(0.75))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 20)
                            .frame(width: 250)
                    }
                    .padding(.trailing, 80)
                        
                }
                Spacer()
                Text("a little work with 🔛")
                    .foregroundColor(Color(UIColor(named: "labelColor")!).opacity(0.5))
                    .font(.system(size: 17, weight: .regular))
                    .italic()
                    .padding(.top, 16)
                    .padding(.bottom, 16)
            }
        }
    }
}

#if DEBUG
struct DartModeView_Previews : PreviewProvider {
   static var previews: some View {
      Group {
        DartModeView().previewDevice("iPhone 7")
            .environment(\.colorScheme, .light)

         DartModeView().previewDevice("iPhone X")
            .environment(\.colorScheme, .dark)
      }
   }
}
#endif
