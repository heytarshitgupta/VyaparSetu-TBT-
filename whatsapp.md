# VyaparSetu AI team handoff

The previous PROD-01B assignment covered publishing and hiding producer drafts. The marketplace branch includes that lifecycle, buyer search, reviewable voice dictation and one product photo, plus buyer quote requests, producer quotes and buyer order confirmation.

| Verify | Expected result |
| --- | --- |
| Producer saves a draft, then publishes | The producer can view the draft and the buyer can find the listing after publication. |
| Producer hides a listing | The buyer can no longer find the product or request new quotes. Existing orders remain available. |
| Buyer accepts a quote | Both parties see one confirmed order with the same reference and total. |
| Other user opens the marketplace | Private drafts and other accounts’ quote activity stay private. |

Use the [README walkthrough](README.md) with separate Producer and Buyer accounts. Keep local passwords, email codes and provider tokens out of commits.

## Repository comparison

| Source | What it contains |
| --- | --- |
| Legacy `main` at `7653860` | A larger Flutter interface backed in part by Supabase, with Python catalog generation and pricing services. Several buyer screens use local mock data. |
| Legacy `producer-development` at `eefa504` | Further producer onboarding, pilot marketplace data, pricing guidance and buyer-demand insights. This branch has changes outside legacy `main`. |
| Legacy `rangan` at `93f1567` | An unmerged FAQ checkpoint. |
| Hackathon `main` at `e5a6a6e` | Flutter, Serverpod and PostgreSQL setup, verified email sign-in, roles and private product drafts. |

The marketplace branch follows the producer-to-buyer demo flow. Legacy onboarding, verification, wishlist, comparison, bargaining, pricing, analytics, multilingual screens and AI-generated catalogs remain outside this implementation. Voice input here transcribes speech into an editable description. Review the event’s reuse rules and sponsor requirements before bringing across legacy source or assets or claiming sponsor integration.

## Verification

The Flutter release web build, four widget tests and eleven Serverpod integration tests passed with PostgreSQL 16. A live local smoke check served the build, verified email sign-in for separate Buyer and Producer accounts, and confirmed that concurrent quote acceptance returned one order reference. Static analysis completed with informational Flutter Material deprecations. Serverpod Cloud deployment, production email delivery and the physical-device camera and microphone demo remain to be verified.
