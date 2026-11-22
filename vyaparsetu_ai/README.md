# VyaparSetu AI

A full-stack, demo-ready marketplace connecting Indian rural artisans & producers directly with bulk and retail buyers. Built with Flutter, Serverpod 4.1.2, and PostgreSQL.

---

## 1. Environment & Credentials Configuration

Configure local secrets in `vyaparsetu_ai_server/config/passwords.yaml` (copied from `passwords.yaml.example`). **Never commit passwords.yaml or real credentials.**

```yaml
development:
  database: 'your-development-db-password'
  redis: 'your-development-redis-password'
  serviceSecret: 'your-local-service-secret'
  emailSecretHashPepper: 'your-development-email-pepper'
  serverSideSessionKeyHashPepper: 'your-development-session-pepper'
  # Real Gmail SMTP Credentials for OTP delivery
  smtpUser: 'your-email@gmail.com'
  smtpPass: 'your-16-char-app-password'
  # Optional Gemini / LLM API Key for AI catalog generation
  geminiApiKey: 'your-gemini-api-key'
```

Alternatively, set environment variables:
- `SMTP_USER=your-email@gmail.com`
- `SMTP_PASS=your-gmail-app-password` (spaces stripped automatically)
- `GEMINI_API_KEY=your-gemini-api-key` (or `LLM_API_KEY`)

*Note: If SMTP credentials are omitted, the server automatically falls back to logging the 6-digit OTP verification code to the console for seamless local development.*

---

## 2. Start the Server

```powershell
cd vyaparsetu_ai_server
dart pub get
dart run bin/main.dart --apply-migrations
```

On development start, the server automatically checks and seeds ~6 demo producers, ~20 realistic Indian artisan products across various crafts (Phulkari, Khadi, Terracotta, Channapatna woodcraft, Brass hammering, Raw forest honey, Desi jaggery, Kashmiri Pashmina), and initial buyer requirements.

The API runs at `http://localhost:8080/`.

---

## 3. Expose Server via Cloudflare Tunnel (for Physical Devices & APK)

```powershell
cloudflared tunnel --url http://localhost:8080
```

Cloudflare will output a public HTTPS tunnel URL (e.g. `https://demo-artisan-market.trycloudflare.com`).

---

## 4. Run the Flutter App

### Debug on Emulator / Desktop
```powershell
cd vyaparsetu_ai_flutter
flutter pub get
flutter run --dart-define=SERVER_URL=http://localhost:8080/
```

### Physical Android Device (LAN)
```powershell
flutter run --dart-define=SERVER_URL=http://<YOUR_LOCAL_IP>:8080/
```

---

## 5. Build Release APK

Ensure Android NDK and Gradle are set up, then build the release APK configured with your tunnel:

```powershell
cd vyaparsetu_ai_flutter
flutter build apk --release --dart-define=SERVER_URL=https://your-tunnel-host.trycloudflare.com/
```

The APK will be generated at:
`vyaparsetu_ai_flutter/build/app/outputs/flutter-apk/app-release.apk`

---

## 6. Demo Accounts & End-to-End Walkthrough

### Pre-seeded Demo Producers
1. **Gurpreet Singh** — *Punjab Heritage Handlooms* (Handloom & Textiles, Amritsar, Punjab)
2. **Rameshwar Prajapati** — *Mitti Kala Terracotta Art* (Handicrafts, Alwar, Rajasthan)
3. **Sunita Devi** — *Kashmir Pashmina & Needlework* (Clothing & Embroidery, Srinagar, J&K)
4. **Manoj Kumar** — *Vedic Pure Forest Organics* (Food & Homemade Products, Haridwar, Uttarakhand)
5. **Lakshmi Bai** — *Channapatna Heritage Wood Toys* (Woodwork, Ramanagara, Karnataka)
6. **Arjan Sharma** — *Moradabad Brass Craft Center* (Metal Craft, Moradabad, Uttar Pradesh)

### Walkthrough Steps for Demo
1. **Sign Up & OTP Verification**:
   - Launch app -> Enter email on Sign In screen.
   - 6-digit OTP code is sent to your Gmail inbox via SMTP (and logged to server console).
   - Enter OTP to log in.
2. **Role Setup / Onboarding**:
   - Choose **Buyer** or **Producer**.
   - Producers complete multi-step onboarding (Business details, Craft category, Indian State location, PAN/GST format verification).
3. **Producer Journey**:
   - Tap **Add Product** -> Use Voice description (Speech-to-text) -> Tap **AI Generate Catalog** to get structured title & description.
   - Tap **Suggest Price** to run the embedded AI Pricing Engine (WPI macro-inflation index + material/labor cost breakdown).
   - Publish product -> Listed instantly on Marketplace.
   - Navigate to **Buyer Needs** tab -> See live requirements from buyers -> Submit response/quote.
4. **Buyer Journey**:
   - Browse catalog of 20+ authentic Indian artisan products.
   - Filter / Search / View details with price in Rupees (₹).
   - Add to **Wishlist** (persisted in DB).
   - Request a custom **Quote / Bargain** on products with required quantity and delivery notes.
   - Post a **Buyer Requirement** with category, budget, and unit quantity.
   - View real-time **Notifications** and accept received quotes to confirm orders.
