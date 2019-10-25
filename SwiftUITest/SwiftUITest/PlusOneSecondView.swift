//
//  PlusOneSecondView.swift
//  SwiftUITest
//
//  Created by justin on 2019/10/23.
//  Copyright © 2019 jlai. All rights reserved.
//

import SwiftUI
import Foundation

struct PlusOneSecondView: View {
    @State var timeCount: Double = 0.0
    
    @State var clickCount: Int = 0
    
    @State private var isStart: Bool = false
    
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {timer in
            if self.isStart {
                self.timeCount += 0.1
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.yellow
                .edgesIgnoringSafeArea(.all)
            ZStack {
                VStack {
                    HStack {
                        Group {
                            Text(timeString(time: timeCount))
                                .font(.system(size: 100, weight: .black))
                                .italic()
                                .foregroundColor(Color.white)
                                .onAppear(perform: {
                                    let _ = self.timer
                                })
                            
                            Text("s")
                                .font(.system(size: 60, weight: .black))
                                .italic()
                                .foregroundColor(Color.white)
                                .padding(.top)
                        }
                        .shadow(color: Color.black.opacity(0.25), radius: 16, x: 0, y: 4)
                    }
                    .padding(.top, 120)
                    
                    //                    A flexible space that expands along the major axis of its containing stack layout,
                    //                    or on both axes if not contained in a stack.
                    Spacer()
                    
                    VStack {
                        Spacer()
                        Button(action: {
                            self.isStart.toggle()
                        }) {
                            Text(!isStart ? "Start" : "Stop")
                                .font(.system(size: 34, weight: .black))
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 190, height:60)
                        .background(Color.green)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.25), radius: 16, x: 0, y: 4)
                        .padding(.bottom, 10)
                        
                        Button(action: {
                            self.timeCount += 1.0
                            self.clickCount += 1
                            print("Total plus:", self.clickCount)
                        }) {
                            Text("+1s")
                                .font(.system(size: 34, weight: .black))
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 190, height:60)
                        .background(Color.green)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.25), radius: 16, x: 0, y: 4)
                        
                        Text("a little work with 🕰")
                            .foregroundColor(Color.black.opacity(0.5))
                            .font(.system(size: 17, weight: .regular))
                            .italic()
                            .padding(.top, 16)
                            .padding(.bottom, 16)
                    }
                }
            }
        }
    }
    
    func timeString(time: Double) -> String {
        return String(format: "%.1f", time)
    }
}

//extension PlusOneSecondView {
//    func gainTime(newTime: Double) -> Double {
//        var newTimeCount = timeCount
//        newTimeCount += newTime
//        return newTimeCount
//    }
//}

#if DEBUG
struct PlusOneSecondView_Previews: PreviewProvider {
   static var previews: some View {
      Group {
         PlusOneSecondView()
      }
   }
}
#endif
