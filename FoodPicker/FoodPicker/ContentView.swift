//
//  ContentView.swift
//  FoodPicker
//
//  Created by Dong on 2022/10/11.
//

import SwiftUI

//class ViewModel{
//    var selectedFood: String?
//}

struct ContentView: View {
    
    let food = [ "漢堡" , "沙拉" , "披薩" , "義大利麵" , "雞腿便當" , "刀削麵" , "火鍋" , "牛肉麵" , "關東煮"]
    
    @State private var selectedFood: String?
//    let vm = ViewModel()
    
    var body: some View {
        VStack(spacing: 26){
            Image("dinner")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("今晚我想來點......")
                
                
            
            if selectedFood != nil {
                Text(selectedFood ?? "")
                    .foregroundColor(.green)
                    .id(selectedFood) // 強制變成不一樣的 View (SwiftUI 判斷 變化 (前、後)是不同的View) 讓他淡入淡出能夠正常運作 (ios16可能原本就能正常運作)
//                    .transition(.scale.combined(with: .slide))
                    .transition(.asymmetric(
                        insertion: .opacity.animation(.easeInOut(duration: 0.5).delay(0.2)),
                        removal: .opacity
                            .animation(.easeInOut(duration: 0.4))))
            }
            
            Button {
                // .shuffled() 打亂
                selectedFood = food.shuffled().first
            } label: {
                Text(selectedFood != .none ? "告訴我" : "換一個")
                    .font(.title)
                    .frame(width: 200)
                    .animation(.none, value: selectedFood)
                    .transformEffect(.identity)
            }
            .buttonStyle(.borderedProminent)
            
            
            Button {
                selectedFood = .none
            } label: {
                Text("RESET").frame(width: 200)
            }
            .buttonStyle(.bordered)
            

        }
        .padding()
        .frame(maxWidth: .infinity)
        .font(.title.bold())
        .controlSize(.large)
        .animation(.easeInOut, value: selectedFood)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
