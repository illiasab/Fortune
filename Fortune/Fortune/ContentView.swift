import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    @State private var memeURL: URL? = nil
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack(alignment: .center) {
            TextField("Ask for Prediction", text: $text)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
                .padding()
                .onSubmit {
                    if !text.isEmpty {
                        fetchMeme()
                    }
                }
            
            if isLoading {
                ProgressView("")
                    .padding()
            } else if let memeURL = memeURL {
                AsyncImage(url: memeURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 500)
                } placeholder: {
                    ProgressView()
                }
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                Text("")
                    .foregroundColor(.gray)
            }
            
            HStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color.yellow)
                }
                .background(Color.gray.opacity(0.3))
                .padding(30)

                Button(action: {
                    
                    fetchMeme()
                }) {
                    Image(systemName: "hand.thumbsdown.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color.yellow)
                }
                .background(Color.gray.opacity(0.3))
                .padding(30)
            }
            .padding(.top, 20)
        }
        .animation(.easeInOut, value: memeURL)
    }
    
    
    func fetchMeme() {
        isLoading = true
        errorMessage = nil
        
        MemeService.shared.fetchRandomMeme { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let meme):
                    memeURL = URL(string: meme.url)
                    isLoading = false
                case .failure(let error):
                    print("Error fetching meme: \(error.localizedDescription)")
                    errorMessage = "Failed to load meme. Please try again."
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
