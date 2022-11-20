//
//  TipView.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 6/7/22.
//

import SwiftUI

struct TipView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var showTipView: Bool
    
//    var tipViewOpacity: Double {
//        showTipView ? 1 : 0
//    }
    var tipViewScale: CGSize {
        showTipView ? CGSize(width: 1, height: 1) : CGSize(width: 0, height: 0)
    }
    
    @State var degrees: Double = 0.0
    
    var isFlipped: Bool {
        if (degrees >= 180 && degrees < 360) || (degrees >= 540 && degrees < 720) {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        SpinningViewWithBackAndFront {
            VStack {
                ZStack {
                    TipViewBack().opacity(isFlipped ? 1 : 0)
                    TipViewFront(degrees: $degrees, selectedAmount: nil, showTipView: $showTipView).environmentObject(viewModel).opacity(isFlipped ? 0 : 1)
                }
            }
            .scaleEffect(tipViewScale)
            .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
//            .opacity(tipViewOpacity)
        }
        .onAppear { degrees = 0.0 }
    }
}


struct TipViewFront: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @Binding var degrees: Double
//    @Binding var showBack: Bool
    @State var selectedAmount: Int?
    var paymentOptions = [1, 2, 5]
    @Binding var showTipView: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 3)
                .foregroundColor(.blue.opacity(0.5))
                .frame(width: UIScreen.main.bounds.size.width - 20)
            Circle()
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.size.width - 20)
            Circle()
                .foregroundColor(.blue.opacity(0.7))
                .frame(width: UIScreen.main.bounds.size.width - 30)
                .shadow(color: Color.gray, radius: 20, x: 0, y: 0)
                .overlay {
                    VStack(spacing: 30) {
                        Text("tip your bartender?").bold()
                        HStack {
                            ForEach(paymentOptions, id: \.self) { number in
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(selectedAmount == number ? .green.opacity(0.65) : .white.opacity(0.4))
                                    .frame(width: UIScreen.main.bounds.size.width/4 - 10, height: 50)
                                    .overlay {
                                        Text("$\(number)")
                                    }
                                    .onTapGesture { selectedAmount = number }
                            }
                        }
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(selectedAmount != nil ? .green.opacity(0.65) : .white.opacity(0.4))
                                .frame(width: UIScreen.main.bounds.size.width/3 - 10, height: 50)
                                .overlay {
                                    Text("thanks!")
                                }
                                .onTapGesture {
                                    if selectedAmount != nil {
//                                        viewModel.tip(amount: viewModel.tipOptions.firstIndex(matching: <#T##Product#>))
                                        showTipView = false
                                    }
                                }
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.red.opacity(0.65))
                                .frame(width: UIScreen.main.bounds.size.width/3 - 10, height: 50)
                                .overlay {
                                    Text("next time")
                                }
                                .onTapGesture {
                                    withAnimation(.easeOut(duration: 12)) {
                                        showTipView = false
                                        degrees = 720
                                    }
                                }
                        }
                    }
                }
        }
    }
}

struct TipViewBack: View {
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 3)
                .foregroundColor(.blue.opacity(0.5))
                .frame(width: UIScreen.main.bounds.size.width - 20)
            Circle()
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.size.width - 20)
            Circle()
                .foregroundColor(.blue.opacity(0.7))
                .frame(width: UIScreen.main.bounds.size.width - 30)
                .shadow(color: Color.gray, radius: 20, x: 0, y: 0)
                .overlay {
                    VStack {
                        Text("Cocktail Pantry").font(.headline).bold()
                        Text("in association with").font(.caption).italic()
                        Image("The Educated Barfly Logo")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.size.width - 160, height: UIScreen.main.bounds.size.width - 310)
                    }
            }
        }
    }
}


struct SpinningViewWithBackAndFront<Content>: View where Content: View {
    
    var content: () -> Content
    
    var body: some View {
        content()
    }
}

struct TipView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TipView(showTipView: Binding.constant(true))
        }
    }
}


struct FlipView<FrontView: View, BackView: View>: View {

      let frontView: FrontView
      let backView: BackView

      @State var showBack: Bool

      var body: some View {
          ZStack() {
                frontView
                  .modifier(FlipOpacity(percentage: showBack ? 0 : 1))
                  .rotation3DEffect(Angle.degrees(showBack ? 180 : 360), axis: (0,1,0))
                backView
                  .modifier(FlipOpacity(percentage: showBack ? 1 : 0))
                  .rotation3DEffect(Angle.degrees(showBack ? 0 : 180), axis: (0,1,0))
          }
          .onTapGesture {
                withAnimation {
                      self.showBack.toggle()
                }
          }
      }
}

private struct FlipOpacity: AnimatableModifier {
   var percentage: CGFloat = 0
   
   var animatableData: CGFloat {
      get { percentage }
      set { percentage = newValue }
   }
   
   func body(content: Content) -> some View {
      content
           .opacity(Double(percentage.rounded()))
   }
}
