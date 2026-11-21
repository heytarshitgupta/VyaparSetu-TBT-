# VyaparSetu AI team handoff

This is the current assignment. MEMBER_1 replaces it after review and merge. [README.md](README.md) shows how to start and use the app.

## Active task

| Field | Value |
| --- | --- |
| Ticket | PROD-01B. Publish and hide your own products |
| Contributor | MEMBER_2 |
| Branch | `feat/prod-01b-publish-hide` |
| Reviewer | MEMBER_3. MEMBER_1 coordinates merge |
| Prerequisite | PR #1, merged at `9152e2d371cc56b60a05ccef2a77dac781ae1cff` |
| Commit message | `feat: let producers publish and hide products` |

**Tell your AI:** "I'm MEMBER_2. Read whatsapp.md and implement only its current assignment. Show me the working local screen first. Verify the changed behavior, update README.md, and tell me what to commit. I'll review and push myself."

MEMBER_3 built and merged draft creation in PR #1. This handoff goes to MEMBER_2 so another teammate can ship a real feature. Product photos and buyer catalog stay as separate follow-ups.

## 1. Start from updated main

In an outer clone folder with a clean worktree:

```powershell
git status --short --branch
git fetch origin
git switch main
git pull --ff-only origin main
git merge-base --is-ancestor 9152e2d371cc56b60a05ccef2a77dac781ae1cff HEAD
git rev-parse HEAD
git switch -c feat/prod-01b-publish-hide
```

Check that the ancestor command succeeded before creating the branch. Record the base SHA. If you are new, clone using the README first. Open the outer clone in your editor, and run Flutter/Serverpod commands from the package directory stated below. Preserve unrelated local changes. Do not commit SDK-only lockfile changes unless this task actually needs a dependency change.

## 2. Build the feature

A Producer opens **My Products**, saves a draft, and clicks **Publish**. The product stays in the list, marked **Published**. They can click **Hide**, reload and see **Hidden**. They can republish a hidden product. A Buyer or a second Producer cannot manage it. The Buyer catalog arrives in CAT-01.

| Action | Path | Expected change |
| --- | --- | --- |
| Modify | `vyaparsetu_ai/vyaparsetu_ai_server/lib/src/endpoints/product_endpoint.dart` | Keep `createDraft` and `listMyDrafts`. Add `listMyProducts`, `publish` and `hide`. Guard all three through the existing `_requireProducer`. |
| Modify | `vyaparsetu_ai/vyaparsetu_ai_flutter/lib/providers/product_drafts_provider.dart` | Read `listMyProducts` for the existing screen. Keep the account dependency. Add publish/hide calls and refresh after each successful change. |
| Modify | `vyaparsetu_ai/vyaparsetu_ai_flutter/lib/features/producer/product_drafts_screen.dart` | Rename the list to **Saved products** while retaining the **New draft** form. Show friendly status labels and the action allowed for each product. Disable an action while its request runs. Surface failures and keep the list available. |
| Modify | `vyaparsetu_ai/vyaparsetu_ai_server/test/integration/product_drafts_test.dart` | Add one focused lifecycle test for Producer A and denial for Producer B/Buyer. Keep the existing draft coverage. |
| Modify | `README.md` | Add the new visual check and record what passed. Keep the clone and run instructions. |

The `ProductStatus` enum and table already exist. This task should require only protocol regeneration. Do not create a migration unless you can explain a genuine schema change.

### Backend starter

Read the current endpoint before editing. Add these methods inside `ProductEndpoint`. They rely on the existing `_requireProducer`, generated `Product.db.updateWhere` and `ProductStatus` enum.

```dart
Future<List<Product>> listMyProducts(Session session) async {
  final producer = await _requireProducer(session);
  return Product.db.find(
    session,
    where: (product) => product.producerProfileId.equals(producer.id!),
    orderBy: (product) => product.id.desc(),
    limit: 50,
  );
}

Future<Product> publish(Session session, {required int productId}) =>
    _changeStatus(session, productId, ProductStatus.published);

Future<Product> hide(Session session, {required int productId}) =>
    _changeStatus(session, productId, ProductStatus.hidden);

Future<Product> _changeStatus(
  Session session,
  int productId,
  ProductStatus status,
) async {
  final producer = await _requireProducer(session);
  final updated = await Product.db.updateWhere(
    session,
    columnValues: (product) => [product.status(status)],
    where: (product) {
      final ownerAndId =
          product.id.equals(productId) &
          product.producerProfileId.equals(producer.id!);
      if (status == ProductStatus.hidden) {
        return ownerAndId &
            (product.status.equals(ProductStatus.published) |
                product.status.equals(ProductStatus.hidden));
      }
      return ownerAndId;
    },
  );
  if (updated.isEmpty) {
    throw ProductDraftException(
      message: 'This product is unavailable for that action.',
    );
  }
  return updated.single;
}
```

Use the new typed client methods after generation. The starter was checked against the merged code signatures. Build and test on your branch.

## 3. See it working, then run focused checks

From `vyaparsetu_ai/vyaparsetu_ai_server` run `serverpod generate`. Start PostgreSQL using README. From `vyaparsetu_ai` run `serverpod start --no-docker` and open the **Flutter preview URL** printed in the terminal. Browser smoke check first:

1. Producer creates **Copper Bottle**, clicks Publish, and sees **Published**.
2. Reload the page and check it is still published. Click Hide, reload, and check **Hidden**. Republish once.
3. A second producer's list excludes the first producer's item. A Buyer has no My Products button.

Before opening the PR, run `dart analyze` from `vyaparsetu_ai`. From `vyaparsetu_ai/vyaparsetu_ai_server` run only:

```powershell
dart test test/integration/product_drafts_test.dart
```

If you add or modify widget tests, run `flutter test --no-pub test/product_drafts_screen_test.dart` from `vyaparsetu_ai/vyaparsetu_ai_flutter`. On Windows, use README's isolated Docker test database if embedded PostgreSQL fails. Don't run the entire suite repeatedly for this ticket. If waiting, record which phase is slow: dependency resolution, database startup, compilation, or a specific test. Keep verification codes, credentials, and raw logs private.

## 4. Commit and hand off

Review your own diff, including generated protocol files, and verify your own Git identity. Stage only this ticket's source, tests, generated files and README. Keep local config, secrets and unrelated lockfile changes out. Commit and push yourself:

```powershell
git diff --cached --check
git commit -m "feat: let producers publish and hide products"
git push -u origin feat/prod-01b-publish-hide
```

Open a PR into `main`, request MEMBER_3 review, and include base SHA, commit SHA, browser results and actual test outcomes. MEMBER_1 updates this file after merge.

Send `TASK PROD-01B PASS - PR <URL>` or `ERROR TASK PROD-01B <first error line>`.
