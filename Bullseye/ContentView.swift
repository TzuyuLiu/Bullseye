//
//  ContentView.swift
//  Bullseye
//
//  Created by 劉子瑜 on 2019/12/10.
//  Copyright © 2019 劉子瑜. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //有@State代表是屬於Instance Scope：程式沒被terminate之前都存在
    //@State代表在更新數值時，View會一起被更新
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    @State var score = 0
    @State var round = 1
    let midnightBlue = Color(red: 0.0/255.0, green: 52.0/255.0, blue: 102.0/255.0)
    
    //因為有很多地方要使用同樣的樣式，所以為了符合DRY(Don't repeact yoursel)，自訂一個新的object
    //這個object只需要在ContentView裡面使用，所以定義在這裡就好，也能定義在ContentView外讓所有人使用
    //ViewModifier是一種object，會接收view，並且設定成你想要的樣子再返回
    //ViewModifier其實就是一種protocol
    struct LabelStyle: ViewModifier{
        func body(content: Content) -> some View {
            return content
                   .foregroundColor(Color.white)
                   .modifier(Shadow())
                   .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }
    
    struct ValueStyle:ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.yellow)
                .modifier(Shadow())
                .font(Font.custom("Arial Rounded MT Bold", size: 24))

        }
    }
    
    //記得符合DRY
    struct Shadow:ViewModifier {
          func body(content: Content) -> some View {
              return content
                  .shadow(color: Color.black, radius: 5, x: 2, y: 2)
          }
      }
    
    struct ButtonLargeTextStyle: ViewModifier{
           func body(content: Content) -> some View {
               return content
                      .foregroundColor(Color.black)
                      .font(Font.custom("Arial Rounded MT Bold", size: 18))
           }
    }
    
    struct ButtonSmallTextStyle: ViewModifier{
              func body(content: Content) -> some View {
                  return content
                         .foregroundColor(Color.black)
                         .font(Font.custom("Arial Rounded MT Bold", size: 12))
              }
          }
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                //Target row
                HStack {
                    Text("Put the bulleyes as close as you can to:")
                        .modifier(LabelStyle())
                    Text("\(target)").modifier(ValueStyle())
                }
                Spacer()
                //Slider row
                HStack{
                    Text("1").modifier(LabelStyle())
                    //$:state variable
                    //原本預設的顏色為藍色，可以用accentColor改變顏色
                    Slider(value: $sliderValue, in: 1...100).accentColor(Color.green)   //會自動更新sliderValue
                    Text("100").modifier(LabelStyle())
                }
                Spacer()
                //Button row
                Button(action: {
                    print("button pressed")
                    self.alertIsVisible = true
                }) {
                    Text("Hit Me!")
                }.modifier(ButtonLargeTextStyle())
                .alert(isPresented: $alertIsVisible) { () -> Alert in
                    return Alert(title: Text("\(alertTitle())"),
                                 message: Text("The slider's value is \(sliderValueRounded()).\n" +
                                    "You scored \(pointsForCurrentRound()) points this round."),
                                 dismissButton: .default(Text("Awesome")){//我們希望更新亂數數值是在按下Awsome(計算玩分數後)，才不會用猜出來的數值減去新產生出的亂數
                                    self.score =  self.score + self.pointsForCurrentRound() //在button action裡面要加上self.
                                    self.target = Int.random(in: 1...100) //因為每次開啟app時的random value都一樣
                                    self.round += 1
                        })
                }
                .background(Image("Button")).modifier(Shadow())
                Spacer()

                //Score row
                HStack{
                    Button(action: {
                        self.startNewGame()
                    }) {
                        HStack{
                            //Image預設的顏色為藍色(accent color)
                            Image("StartOverIcon").accentColor(midnightBlue)
                            Text("Start over").modifier(ButtonSmallTextStyle())
                        }
                    }.background(Image("Button")).modifier(Shadow())
                    Spacer()
                    HStack{
                        Text("Score:").modifier(LabelStyle())
                        Text("\(score)").modifier(ValueStyle())
                    }
                    Spacer()
                    HStack{
                        Text("Round: ").modifier(LabelStyle())
                        Text("\(round)").modifier(ValueStyle())
                    }
                    Spacer()
                    //按下info之後會跳到AboutView的頁面，用navigation link達成
                    //他會產生一個新的view 讓AboutView顯示
                    NavigationLink(destination: AboutView()) {
                        HStack{
                            Image("InfoIcon").accentColor(midnightBlue)
                            Text("Info").modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button")).modifier(Shadow())
                }
                .padding(.bottom, 20)
            }
        }
        .background(Image("Background"), alignment: .center)
        .accentColor(midnightBlue)
        .navigationBarTitle("Bullseye") //程式最上面那一條叫做navigation bar
    }
    
    func sliderValueRounded() -> Int {
        //rounded：看是靠近0.99或0.01，讓數字進或者捨棄小數點
        return Int(sliderValue.rounded())
    }
    
    func pointsForCurrentRound() -> Int {
        //以下屬於local scope：當pointsForCurrentRound完成之後就會將三個變數都丟棄掉
        let maximumScore = 100
        let bouns: Int
        let difference = amountOff()
        if (difference == 0){
            bouns = 100
        } else if (difference == 1){
            bouns = 50
        } else {
            bouns = 0
        }
        //如果只有單行可以刪除return
        return maximumScore - difference + bouns
    }
    
    func amountOff() -> Int{
        abs(sliderValueRounded() - target)
    }
    
    func alertTitle() -> String{
        let difference = amountOff()
        let title: String
        if difference == 0 {
            title = "Perfect!"
        } else if difference < 5 {
            title = "You almost had it!"
        } else if difference <= 10 {
            title = "Not bad."
        } else {
            title = "Are you even trying?"
        }
        return title
    }
    
    //如果要做一連串事情 用func會比較清楚
    func startNewGame(){
        score = 0
        round = 1
        sliderValue = 50.0
        target = Int.random(in: 1...100)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 896, height: 414))
        
    }
}
