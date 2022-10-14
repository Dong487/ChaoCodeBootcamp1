//
//  ContentView.swift
//  LayoutTest
//
//  Created by Dong on 2022/10/13.
//

// iOS16 推出的 LayoutProtocol
// 適合相似大小且不超出範圍的 View 來重複排序
// 但不適合太大量的 View 因爲layout都是 eager 畫面會一次都run完 (與Lazy相反)

// https://www.youtube.com/watch?v=du_Bl7Br9DM
// 此篇 code 為 subView 比螢幕 size小的情況下 (圖片有可能size 超出螢幕範圍)
// 如果要能使用 上面網址 11:16 更改一些小地方
//

import SwiftUI

struct EqualSizeLayout: Layout {
    let vSpacing: CGFloat = 10
    let hSpacing: CGFloat = 10
    
    private func getMaxSize(_ subviews: Subviews) -> CGSize{
        return subviews.reduce(.zero) { maxSize, view in
            let size = view.sizeThatFits(.unspecified) // .unspecified : 理想的空間
            
            // .max() -> 比較能給的空間 跟 子View的空間哪個比較大
            return .init(
                width: max(maxSize.width ,size.width),
                height: max(maxSize.height ,size.height)
            )
        }
    }
    
    // 計算整個Layout 要有多大
    // ProposedViewSize -> Layout空間大小提案
    // Subviews -> 裡面所包含的 View
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        
        // 確保有獲取的空間寬度 else return .zero
        // !subviews.isEmpty: 避免算width 會有負數
        guard let totalWidth = proposal.width, !subviews.isEmpty else { return .zero }
        
        let maxSize = getMaxSize(subviews)
 
        // 每一橫排 最多能塞 幾個subview
        let maxColumns = ( (totalWidth + hSpacing) / (maxSize.width + hSpacing) ).rounded(.down)
        // 每一個橫排 個數 (subview 有可能小於最多能擺的 subviews.count < maxColumns) 所以用 .min檢查
        let columns = min(maxColumns ,CGFloat(subviews.count))
        
        // rows(總共需要幾行) = SubView 數量 / 每一個橫排能擺的數量 (如果有餘數就要加到下一行 所以 rounded(進位) )
        let rows = (CGFloat(subviews.count) / columns).rounded(.up)
        
        let width = columns * (maxSize.width + hSpacing ) - hSpacing  // - - - - - - - > 總寬度
        let height = rows * (maxSize.width + vSpacing ) - vSpacing    // - - - - - - - > 總高度
        
        return .init(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxSize = getMaxSize(subviews)
        let proposal = ProposedViewSize(maxSize)
        
        var x = bounds.minX
        var y = bounds.minY
        
        
        // 每一個 subView 的放置
        subviews.forEach { view in
            view.place(at: .init(x: x, y: y),
                       proposal: proposal)
            
            x += maxSize.width + hSpacing //
            
            if (x >= bounds.maxX){
                y += maxSize.height + vSpacing
                x = bounds.minX
            }
        }
    }
    
    
    
}

struct ContentView: View {
    
    let tags = ["WWDC2022" , "SwiftUI" , "swifT" , "iPhone" ,"ipad" , "iOS"]
    
    var body: some View {
        VStack {
            // .callAsFunction() 可以直接寫成()
            EqualSizeLayout()(){
                ForEach(tags ,id: \.self){ item in
 
                    Text(item)
                        .font(.callout)
//                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.gray)
                        
                    
                }
            }
            .background(.yellow)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
