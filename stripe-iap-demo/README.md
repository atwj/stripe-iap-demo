# Stripe IAP Demo

## Motivation

Given the recent developments around the ruling for In-App Purchases (IAP) for the US iOS App Store, this project aims to provide examples of how apps can redirect payments outside of the App Store using Stripe. This approach allows developers to bypass the App Store's IAP system and handle payments directly through Stripe, offering more flexibility and potentially lower fees.

## Using Stripe Payment Links

### Overview

This project demonstrates how to use Stripe Payment Links to handle payments outside of the App Store. The app uses a `WKWebView` to open a Stripe payment link in an in-app browser. Once the payment is completed, the app detects the return URL and closes the in-app browser.

### Implementation

1. **Set Up Stripe Payment Link**: Create a payment link in Stripe and set a return URL that your app can detect.

2. **Use `WKWebView`**: The app uses a `WKWebView` to load the payment link. This allows for more control over the web content and navigation.

3. **Detect Return URL**: Use the `WKNavigationDelegate` to detect when the return URL is loaded and close the in-app browser.

### Code Example

Here's a simplified version of the code used in this project:

```swift
import SwiftUI
import WebKit

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
    @State private var showWebView = false
    let checkoutURL = URL(string: "https://buy.stripe.com/test_28E7sKeAo1qs1Td7umefC1f")!
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
                
                Spacer()
            }
        }
    }
}
```

### Key Points

- **`WKWebView`**: Provides a flexible way to display web content and control navigation.
- **`WKNavigationDelegate`**: Allows you to intercept navigation events and detect when the return URL is loaded.
- **Manual Dismissal**: A "Cancel" button is provided to manually close the in-app browser.

This approach offers a seamless way to handle payments outside of the App Store, leveraging Stripe's payment infrastructure. 