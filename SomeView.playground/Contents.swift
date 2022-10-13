import SwiftUI

let text: Text = Text("你好")

let text2: SwiftUI.ModifiedContent<SwiftUI.Text, SwiftUI._PaddingLayout> = Text("bbbb").padding() as! ModifiedContent<Text, _PaddingLayout>

let view = text2.foregroundColor(.pink)


// - - - - - - - - - - - - -

let useDarkMode = false

// some View : 不透明類型 -> 但只會有一種固定的結果(類型)
//let background: some View = useDarkMode ? Text("不支援") : Color.white // 雖然都 confirm View protocol 可是 不是同一種 View 若 some View改成 any View 就可以放進 body 內
