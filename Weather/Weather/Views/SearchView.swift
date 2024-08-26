//
//  SearchView.swift
//  Weather
//
//  Created by Krishna on 26/08/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city: String = ""
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                HStack {
                    // Enhanced TextField with Icon
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Enter city", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 10)
                        .animation(.easeInOut(duration: 0.3), value: city)
                }
                .padding()
                
                Button(action: {
                    viewModel.fetchWeather(for: city)
                }) {
                    Text("Get Weather")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
                
                if viewModel.isLoading {
                    // Animated Loading Spinner
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding(.top, 20)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
                } else if let weather = viewModel.weather {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Temperature: \(weather.main.temp - 273.15, specifier: "%.1f")°C")
                            .font(.headline)
                        
                        Text("Description: \(weather.weather.first?.description ?? "N/A")")
                        
                        if let icon = weather.weather.first?.icon {
                            AsyncImage(url: URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png"))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .transition(.slide) // Smooth Slide-In Effect
                                .animation(.easeInOut(duration: 0.3), value: icon)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: weather)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: errorMessage)
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            viewModel.loadLastCity()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
