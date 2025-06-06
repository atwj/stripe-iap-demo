//
//  ContentView.swift
//  stripe-iap-demo
//
//  Created by Amos Tan on 14/5/25.
//

import SwiftUI
import SwiftData
import Inject
import SafariServices
import WebKit

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    var onDismiss: () -> Void

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = context.coordinator
        return safariVC
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        let parent: SafariView

        init(_ parent: SafariView) {
            self.parent = parent
        }

        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            parent.onDismiss()
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    var onDismiss: () -> Void

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url, url.absoluteString.contains("your-return-url.com") {
                parent.onDismiss()
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    }
}

struct ContentView: View {
    @ObserveInjection var inject 
    @State private var showWebView = false
    @State private var showCustomerPortal = false
    let checkoutURL = URL(string: "https://buy.stripe.com/test_28E7sKeAo1qs1Td7umefC1f")!
    let customerPortalURL = URL(string: "https://billing.stripe.com/p/login/test_28o29hdEl9wDgX6fYY")!
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Button(action: {
                    showWebView = true
                }) {
                    Text("Subscribe next year!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showWebView, onDismiss: {
                    // Handle any post-dismissal logic if needed
                }) {
                    VStack {
                        HStack {
                            Spacer()
                            Button("Cancel") {
                                showWebView = false
                            }
                            .padding()
                        }
                        WebView(url: checkoutURL, onDismiss: {
                            showWebView = false
                        })
                    }
                }
                
                Button(action: {
                    showCustomerPortal = true
                }) {
                    Text("Customer Portal")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showCustomerPortal, onDismiss: {
                    // Handle any post-dismissal logic if needed
                }) {
                    VStack {
                        HStack {
                            Spacer()
                            Button("Cancel") {
                                showCustomerPortal = false
                            }
                            .padding()
                        }
                        WebView(url: customerPortalURL, onDismiss: {
                            showCustomerPortal = false
                        })
                    }
                }
                
                Spacer()
            }
        }
        .enableInjection()
    }
}

#Preview {
    ContentView()
}
