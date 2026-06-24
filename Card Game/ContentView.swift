import SwiftUI

struct ContentView: View {
    
    let images = [
        "card2", "card3", "card4", "card5", "card6", "card7",
        "card8", "card9", "card10", "card11", "card12", "card13", "card14"
    ]
    
    @State private var playercard: String = "card11"
    @State private var cpucard: String = "card10"
    
    @State private var playScore: Int = 0
    @State private var cpuScore: Int = 0
    @State private var roundsPlayed: Int = 0
    
    @State private var level: Int = 1
    @State private var showTie = false
    
    @State private var showResultPopup = false
    @State private var resultTitle = ""
    @State private var resultMessage = ""
    
    var body: some View {
        ZStack {
            Image("background-wood-grain")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                Image("logo")
                
                Text("LEVEL \(level)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Round \(roundsPlayed + 1) of 3")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))
                
                HStack {
                    VStack(spacing: 8) {
                        Text("PLAYER")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        Image(playercard)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("CPU")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        Image(cpucard)
                    }
                }
                .padding(.horizontal, 35)
                
                if showTie {
                    Text("TIE! PLAY AGAIN")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.yellow)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text(" ")
                        .font(.system(size: 20))
                }
                
                Button {
                    buttonTapped()
                } label: {
                    Image("button")
                }
                .disabled(roundsPlayed == 3)
                
                HStack(spacing: 55) {
                    VStack {
                        Text("Player")
                        Text("\(playScore)")
                            .font(.system(size: 32, weight: .bold))
                    }
                    
                    VStack {
                        Text("CPU")
                        Text("\(cpuScore)")
                            .font(.system(size: 32, weight: .bold))
                    }
                }
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal)
            
            if showResultPopup {
                Color.black.opacity(0.55)
                    .ignoresSafeArea()
                
                VStack(spacing: 18) {
                    Text(resultTitle)
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundColor(resultTitle == "YOU WON!" ? .green : .red)
                    
                    Text(resultMessage)
                        .font(.system(size: 18, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Button {
                        nextLevel()
                    } label: {
                        Text(resultTitle == "MATCH TIED!" ? "PLAY LEVEL AGAIN" : "NEXT LEVEL")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 12)
                            .background(Color.yellow)
                            .clipShape(Capsule())
                    }
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.black.opacity(0.88))
                )
                .padding(35)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    func buttonTapped() {
        guard roundsPlayed < 3 else { return }
        
        playercard = images.randomElement() ?? "card11"
        cpucard = images.randomElement() ?? "card10"
        
        let playerValue = Int(playercard.replacingOccurrences(of: "card", with: "")) ?? 0
        let cpuValue = Int(cpucard.replacingOccurrences(of: "card", with: "")) ?? 0
        
        withAnimation {
            showTie = false
        }
        
        if playerValue > cpuValue {
            playScore += 1
        } else if cpuValue > playerValue {
            cpuScore += 1
        } else {
            withAnimation {
                showTie = true
            }
        }
        
        roundsPlayed += 1
        
        if roundsPlayed == 3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                showLevelResult()
            }
        }
    }
    
    func showLevelResult() {
        if playScore > cpuScore {
            resultTitle = "YOU WON!"
            resultMessage = "Congratulations! You won Level \(level)."
        } else if cpuScore > playScore {
            resultTitle = "CPU WON!"
            resultMessage = "The CPU won this level. Try again!"
        } else {
            resultTitle = "MATCH TIED!"
            resultMessage = "Both scored \(playScore). Play this level again!"
        }
        
        withAnimation {
            showResultPopup = true
        }
    }
    
    func nextLevel() {
        if playScore > cpuScore {
            level += 1
        }
        
        playScore = 0
        cpuScore = 0
        roundsPlayed = 0
        playercard = "card11"
        cpucard = "card10"
        
        withAnimation {
            showTie = false
            showResultPopup = false
        }
    }
}

#Preview {
    ContentView()
}
