# VyaparSetu AI — team notes

Internal notes for the demo and for presenting the project. Product documentation lives in [README.md](README.md); this file is only for us.

> This repository is public, so never put passwords, API keys, or personal email addresses here.

## Two-minute presentation script

Say this in front of the app. Bold text is what you tap or point at.

> **0:00 — Problem (20s).**
> "India ke gaon ke artisans bahut achha handmade maal banate hain, lekin unke paas digital catalogue nahi hota, English description likhne ka time nahi hota, aur bulk buyers tak pahunchne ka rasta nahi hota. Beech mein middlemen poora margin le lete hain."
>
> **0:20 — What we built (20s).**
> "Humne **VyaparSetu** banaya — ek do-tarfa marketplace. Producer apna product photo aur voice se add karta hai, AI uski description aur price suggestion banata hai. Buyer catalogue browse karta hai, quote maangta hai, aur quote accept karte hi order confirm ho jata hai. **Same app Android par aur browser par chalti hai.**"
>
> **0:40 — Live demo (50s).**
> Open https://vyaparsetu.serverpod.space/ → **I Make & Sell Products** → email → **Send code** → OTP → onboarding → **Add Product** → name, category, price → **Add Product**. Point at **My Products**: "Ye listing turant buyer catalogue mein live hai."
> Then open the same URL in a second window → **I Want to Buy Products** → browse the catalogue → open the product → **Request quote**.
>
> **1:30 — The quote loop (20s).**
> "Ab producer ke **Quotes** tab mein wahi request aati hai. Producer total quote karta hai. Buyer **Accept** dabata hai — dono taraf same order, same status."
>
> **1:50 — Tech in one line (10s).**
> "Poora stack Dart mein hai: Flutter frontend, Serverpod backend, PostgreSQL. Ek hi codebase se Android APK, website, API aur database — sab ek saath deploy hote hain. APK har push par GitHub Releases se automatically update hota hai."

If the live demo breaks, switch to the recorded video and say "network issue hai, lekin architecture ye hai" — never debug in front of judges.

## Five-minute demo (step by step)

1. Open https://vyaparsetu.serverpod.space/ and pick a role.
2. **Producer:** sign in with an email, enter the OTP, complete onboarding.
3. **Add a product:** choose a photo, type or dictate a description, optionally **AI Generate Catalog** / **Suggest Price**, then **Add Product**.
4. **Buyer:** in a second browser profile or phone, sign in, browse the marketplace, open the product, request a quote.
5. **Producer:** open **Quotes**, submit a total in rupees.
6. **Buyer:** open **Quotes**, accept. Both accounts show the same confirmed order.
7. **Extras:** post a buyer requirement, respond to it as a producer, show notifications.

Create the demo accounts the day before. Do not rely on an inbox you cannot open during the demo.

## Questions teachers and mentors ask

**What exactly is the product?**
A mobile-first B2B marketplace that lets rural artisans create a catalog and quote bulk buyers, and lets buyers discover, request, and confirm orders in one place.

**Who is the user and why would they use it?**
Producers in craft clusters (handloom, terracotta, brass, woodcraft, food) who sell through middlemen, and bulk buyers (retailers, exporters, gifting companies) who want authentic handmade supply.

**Why not just use WhatsApp or IndiaMART?**
WhatsApp has no catalog, quote state, or order record. IndiaMART is lead generation and paid. VyaparSetu is built for artisans: voice-assisted listing, AI catalog copy, a price recommendation, and a simple quote → accept workflow.

**What is technically interesting here?**
End-to-end Dart with Serverpod: one set of models generates the database schema, server stubs, and typed client. The same codebase serves Android, web, API, and the hosted web frontend.

**How does authentication work?**
Email + 6-digit OTP through Serverpod's email identity provider. The server issues a server-side session. No passwords are stored.

**How do you stop a buyer from accepting someone else's quote?**
`trade.accept` loads the trade and checks `buyerProfileId` against the caller's profile from the session. The same pattern protects product edits, publishing, and producer quotes.

**How is money handled?**
All amounts are integers in paise. The UI formats them as ₹. No floating-point rounding.

**What happens if the AI key is missing or Gemini is slow?**
The AI call is optional with a 4-second timeout. On any failure a deterministic template is used, and pricing is fully local, so the demo never depends on the network.

**How is the app deployed?**
Serverpod Cloud runs API, web server, Insights, and managed PostgreSQL in one project. `serverpod cloud deploy` builds, migrates, and rolls out. The Flutter web build is served from `web/app`.

**How do users get updates?**
Every push to `main` triggers GitHub Actions, builds an APK with an incremented build number, and replaces the asset in the `apk-latest` release. The download URL never changes.

**What did you test?**
Static analysis, widget tests, Serverpod integration tests, and a deployed end-to-end run: OTP login, producer onboarding, product publish, buyer catalog, quote request, quote, and acceptance.

**What is not built yet?**
Payments, escrow, shipping, ratings, push notifications, real-time chat, GST invoicing, regional-language UI, and Play Store signing.

## Verification checklist

| Verify | Expected result |
| --- | --- |
| Producer saves a draft, then publishes | The producer can view the draft and the buyer can find the listing after publication. |
| Producer hides a listing | The buyer can no longer find the product or request new quotes. Existing orders remain available. |
| Buyer accepts a quote | Both parties see one confirmed order with the same reference and total. |
| Other user opens the marketplace | Private drafts and other accounts' quote activity stay private. |

## Housekeeping

- Serverpod Cloud Starter trial ends **2026-12-23**. After that the project needs a paid plan or the Dockerfile-based self-host path.
- Production starts with an empty database; the development seed only runs in `development` mode. Create fresh accounts before a demo.
- The APK is debug-signed. That installs fine on phones but is not Play Store ready.
- Keep `config/passwords.yaml`, `.env`, and SMTP/Gemini keys out of commits.
