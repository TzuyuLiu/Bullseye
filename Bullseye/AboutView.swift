//
//  AboutView.swift
//  Bullseye
//
//  Created by 劉子瑜 on 2019/12/13.
//  Copyright © 2019 劉子瑜. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    
    let biege = Color(red: 255.0/255.0, green: 214.0/255.0, blue: 179.0/255.0)

    struct AboutHeadingStyle: ViewModifier{
           func body(content: Content) -> some View {
               return content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 30))
                .padding(.top, 20)
                .padding(.bottom ,20)
           }
    }
    
    struct AboutBodyStyle: ViewModifier{
           func body(content: Content) -> some View {
               return content
                      .foregroundColor(Color.black)
                      .font(Font.custom("Arial Rounded MT Bold", size: 16))
                .padding(.leading, 60)
                .padding(.trailing ,60)
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)    //文字置中
           }
    }
    
    var body: some View {
        //Vstack並不會佔據全螢幕，所以背景周圍會有一圈空白，此時用group解決
        Group{
            VStack{
                Text("🎯 Bullseye 🎯").modifier(AboutHeadingStyle())
                Text("This is Bullseye, the game where you can win points and earn fame by dragging a slider. ").modifier(AboutBodyStyle()).lineLimit(nil)
                Text("Your goal is to place the slicer as close as possible to the target value. The close you are, the more points you score.").modifier(AboutBodyStyle()).lineLimit(nil)
                Text("Enjoy!").modifier(AboutBodyStyle())
            }
            .navigationBarTitle("About Bullseye")
            .background(biege)  //background可以用圖片或顏色
        }
        .background(Image("Background"))
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView().previewLayout(.fixed(width: 896, height: 414))
    }
}
