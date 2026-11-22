# VyaparSetu AI team handoff

VyaparSetu AI is a two-sided marketplace for Indian artisans and bulk buyers, built with Flutter, Serverpod, and PostgreSQL. Producers publish listings, buyers search the catalog and request quotes, and a producer's quote is confirmed as an order on the same record.

| Verify | Expected result |
| --- | --- |
| Producer saves a draft, then publishes | The producer can view the draft and the buyer can find the listing after publication. |
| Producer hides a listing | The buyer can no longer find the product or request new quotes. Existing orders remain available. |
| Buyer accepts a quote | Both parties see one confirmed order with the same reference and total. |
| Other user opens the marketplace | Private drafts and other accounts' quote activity stay private. |

Use the [README walkthrough](README.md) with separate Producer and Buyer accounts. Keep local passwords, email codes, and provider tokens out of commits.

## Scope

The marketplace follows the producer-to-buyer demo flow:

- Producer onboarding, private drafts, publishing, hiding, and one product photo per listing.
- Buyer catalog search, wishlist, buyer requirements, and quote requests.
- Producer quotes, buyer acceptance, and a shared confirmed order.
- Voice input that transcribes speech into an editable description.
- Optional AI catalog copy and a local price suggestion with a deterministic fallback.

Onboarding verification, wishlist comparison, bargaining, analytics, multilingual screens, and AI-generated catalogs are outside the current build.

## Verification

The Flutter release web build, widget tests, and Serverpod integration tests pass with PostgreSQL 16. Static analysis is clean.

Deployed verification on Serverpod Cloud:

- Email OTP sign-in delivered through the Serverpod Cloud email service.
- Producer onboarding and profile creation.
- Product creation, photo validation, and publishing to the buyer catalog.
- Buyer quote request, producer quote, and buyer acceptance on one trade record.
- Web app, API, and Insights endpoints reachable on their public URLs.
- Release APK built and published by GitHub Actions to the `apk-latest` release.
