# VyaparSetu AI team handoff

This file is the team's single, rotating assignment. **MEMBER_1** coordinates merges and updates it after each completed task. [README.md](README.md) is the guide for running and checking the app.

## Current assignment

| Field | Value |
| --- | --- |
| Task | PROD-01A ? Private producer product drafts |
| Assigned contributor | MEMBER_3 |
| Branch | `feat/prod-01a-product-drafts` |
| Review | MEMBER_2 reviews, MEMBER_1 coordinates merge |
| Dependency | AUTH-01 is on `main` at `57ab52537b89a0a22bdf04204da063bf898daaa0` |
| Suggested commit | `feat: let producers save and view product drafts` |

**Tell your AI agent:** ?Read `whatsapp.md` from the repository root. I'm MEMBER_3. Implement only the current PROD-01A assignment, run its checks, update README.md and report the results and commit message. I'll review, commit, and push myself.?

The contributor works through the code with the agent, runs the app and tests, reviews the diff, and commits from their own GitHub account. The agent leaves the work for that contributor to review. Keep this handoff file for the coordinator to update after merge.

### 1. Set up your branch

If you haven't cloned the repo, run these from the parent folder where you want it:

```powershell
git clone https://github.com/heytarshitgupta/VyaparSetu-TBT-.git
cd VyaparSetu-TBT-
```

From the outer repo folder, check for local work before switching. If the branch already exists for this task, continue on it after inspecting its status. For a new branch on a clean clone:

```powershell
git status --short --branch
git fetch origin
git switch main
git pull --ff-only origin main
git rev-parse HEAD
git merge-base --is-ancestor 57ab52537b89a0a22bdf04204da063bf898daaa0 HEAD
git switch -c feat/prod-01a-product-drafts
```

The ancestor check must succeed before creating the branch. Record the full SHA from `git rev-parse HEAD` in the PR. Open the outer clone in your AI editor so it can see both README and the app. The Flutter and Serverpod workspace inside it is `vyaparsetu_ai/`. Check `flutter --version`, `dart --version` and `serverpod version`, and use README for local database and secret setup.

### 2. Build this feature

Producer ? **My Products** ? **New draft** ? enter a name and optional description ? **Save draft**. The list and form must read and write the real database through Serverpod. The producer can see their own saved drafts after reloading. Other producers, buyers and signed-out sessions cannot see them. Photos, publish, hide and buyer catalog are follow-up tasks.

Start with the four backend files below. Inspect `ProfileEndpoint` and the existing auth/profile tests first. The starter uses the verified AUTH-01 model and still needs generation, compilation and tests on your branch. Future-facing status values reserve names for the next task. Only draft creation and draft listing are exposed in this task. The server derives the owner from the authenticated Producer profile and validates the fields.

#### `vyaparsetu_ai/vyaparsetu_ai_server/lib/src/models/product_status.spy.yaml`

```yaml
enum: ProductStatus
serialized: byName
values:
  - draft
  - published
  - hidden
```

#### `vyaparsetu_ai/vyaparsetu_ai_server/lib/src/models/product.spy.yaml`

```yaml
class: Product
table: product
fields:
  producerProfileId: int, relation(parent=account_profile, onDelete=Cascade)
  name: String
  description: String
  status: ProductStatus, default=draft
indexes:
  product_producer_profile_idx:
    fields: producerProfileId
```

#### `vyaparsetu_ai/vyaparsetu_ai_server/lib/src/models/product_draft_exception.spy.yaml`

```yaml
exception: ProductDraftException
fields:
  message: String
```

#### `vyaparsetu_ai/vyaparsetu_ai_server/lib/src/endpoints/product_endpoint.dart`

```dart
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

class ProductEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Product> createDraft(
    Session session, {
    required String name,
    required String description,
  }) async {
    final producer = await _requireProducer(session);
    final cleanName = name.trim();
    final cleanDescription = description.trim();
    if (cleanName.isEmpty || cleanName.runes.length > 120) {
      throw ProductDraftException(message: 'Enter a name of 1 to 120 characters.');
    }
    if (cleanDescription.runes.length > 2000) {
      throw ProductDraftException(message: 'Use at most 2000 description characters.');
    }

    return Product.db.insertRow(
      session,
      Product(
        producerProfileId: producer.id!,
        name: cleanName,
        description: cleanDescription,
        status: ProductStatus.draft,
      ),
    );
  }

  Future<List<Product>> listMyDrafts(Session session) async {
    final producer = await _requireProducer(session);
    return Product.db.find(
      session,
      where: (product) =>
          product.producerProfileId.equals(producer.id!) &
          product.status.equals(ProductStatus.draft),
      orderBy: (product) => product.id,
      orderDescending: true,
      limit: 50,
    );
  }

  Future<AccountProfile> _requireProducer(Session session) async {
    final authUserId = session.authenticated!.authUserId;
    final profile = await AccountProfile.db.findFirstRow(
      session,
      where: (row) => row.authUserId.equals(authUserId),
    );
    if (profile == null || profile.role != MarketplaceRole.producer) {
      throw ProductDraftException(message: 'A Producer profile is required.');
    }
    return profile;
  }
}
```

Then make these changes:

| Action | Exact path | What to implement |
| --- | --- | --- |
| Create | `vyaparsetu_ai/vyaparsetu_ai_flutter/lib/features/producer/product_drafts_screen.dart` | Draft list and form with displayable loading, empty, error/retry and save states. Name is required and at most 120 characters. Description is optional and at most 2,000. Disable repeat submission while saving. Keep input available on error. |
| Create | `vyaparsetu_ai/vyaparsetu_ai_flutter/lib/providers/product_drafts_provider.dart` | Follow `session_provider.dart`. Read via `client.product.listMyDrafts()`, use the signed-in user as a dependency, and clear cached draft state when the account changes or signs out. Save through `client.product.createDraft(name: ..., description: ...)` and refresh after success. |
| Modify | `vyaparsetu_ai/vyaparsetu_ai_flutter/lib/features/auth/sign_in_screen.dart` | Read latest content before editing. Add a **My Products** button only for a Producer and open the draft screen. Keep Buyer navigation and sign-out working. |
| Create | `vyaparsetu_ai/vyaparsetu_ai_server/test/integration/product_drafts_test.dart` | Follow the generated `withServerpod` tooling and the existing `profile_test.dart`. Cover signed-out denial, Buyer denial, invalid input, successful persistence, and isolation between two Producer accounts. |
| Modify | `README.md` | Record what you actually verified, the startup commands, and a short click-through check for PROD-01A. Keep AUTH-01 checks. Update `.gitignore` only if your changes introduce a new local-only artifact. |

### 3. Generate, run, and verify

From the outer repo folder:

```powershell
cd .\vyaparsetu_ai
flutter pub get
cd .\vyaparsetu_ai_server
serverpod generate
serverpod create-migration --tag prod-01a
```

Create one migration and review it for the new table, index and foreign key. Regenerate rather than editing protocol files by hand. If the migration already exists on your task branch, inspect it and skip creating another one. Start the configured development PostgreSQL using README, then from the workspace root:

```powershell
serverpod start --no-docker
```

Check the server applies the migration. Open the printed Flutter preview URL. Sign in to a test Producer account, save **Copper Bottle** with an optional description, reload and confirm the record remains. Sign into another test Producer account and confirm it does not appear there. Sign into a Buyer account and confirm there is no **My Products** button. A server test must independently confirm Buyer access is denied. For a new test account, read development verification codes in your local Serverpod terminal.

From the workspace root in a second PowerShell terminal:

```powershell
dart analyze
cd .\vyaparsetu_ai_flutter
flutter test --no-pub
cd ..\vyaparsetu_ai_server
dart test test/integration/product_drafts_test.dart
```

If embedded PostgreSQL fails on Windows, follow the README's separate test-database commands and substitute the product test path. For missing client methods, check you ran `serverpod generate` in the server package. For a missing table, check the running database and migration. Report any failed checks accurately. Keep credentials, verification codes and raw logs out of reports and Git.

### 4. Review and commit your work

From the outer clone, run `git status --short`, `git config user.name` and `git config user.email` to verify your own Git identity. Stage the task files and checked-in generated output only. Inspect `git diff --cached --check`, `git diff --cached --stat` and the staged diff locally. Then commit and push from your GitHub account:

```powershell
git commit -m "feat: let producers save and view product drafts"
git push -u origin feat/prod-01a-product-drafts
```

Open a PR targeting `main` and request MEMBER_2 review. Include base SHA, commit SHA, tests actually run, and any remaining issue. The coordinator updates this handoff after review and merge. The next product task is PROD-01B (photo upload and publish), then MEMBER_2's live buyer catalog task.

**Send when ready:** `TASK PROD-01A PASS - PR <URL>`

**If blocked:** `ERROR TASK PROD-01A <first error line>`
