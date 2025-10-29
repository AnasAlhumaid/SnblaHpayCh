# SnblaHpayCh
Tech Stack & Libraries

SwiftUI (iOS 18.5) — UI & state management

MVVM — structured separation between logic and UI

Stripe iOS SDK — sandbox payments via PaymentSheet

Node.js + Express (Render) — live backend for test PaymentIntents

MockHPayAPI — in-memory mock repo for local/offline debugging

Async/Await — concurrency and clean async state handling

# if want to use it with Stripe 
Install Stripe SDK
File → Add Packages → https://github.com/stripe/stripe-ios
Run the backend (already deployed)

Live test API:
https://hpaymini-stripe-backend-1.onrender.com

Uses STRIPE_SECRET_KEY (Test Mode) on Render inside App

# Assumptions:

Wallet balance is user-specific (mocked userId = 1)

Stripe operates in Test Mode; no real payments

# Limitations:

No real authentication or persistent storage

Minimal validation on card data

Backend endpoints are basic (demo-only)

# Next Steps / Improvements:

Add real login and user tokens

Store cards and transactions persistently (e.g. Firestore)

Add proper localization and accessibility

Expand UI animations and error visuals


https://github.com/user-attachments/assets/f8610277-5986-42b1-9920-656052e71f05

<img width="250" height="600" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-10-29 at 10 58 29" src="https://github.com/user-attachments/assets/d7ac53da-1ded-46b0-982f-db5a4bc1b12e" />
<img width="250" height="600" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-10-29 at 10 58 14" src="https://github.com/user-attachments/assets/90d884ac-6856-4c8d-8756-ae9554423f86" />
