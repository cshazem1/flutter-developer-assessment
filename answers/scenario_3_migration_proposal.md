# Scenario 3: State Management Migration — BLoC vs Riverpod

## 1. My Recommendation: DO NOT MIGRATE. Improve BLoC instead.

With 80+ existing BLoCs, zero test coverage, a 2000-line DI file, and god-classes, the team's real problems are **architectural debt** — not the choice of state management library. Migrating to Riverpod would take 3–6 months, introduce regressions (no tests to catch them), and the team would be learning a new tool while shipping features. That's a losing trade.

My bet: fix the architecture first (split god-classes, add tests, modularise DI), THEN revisit state management in 6 months from a position of strength.

---

## 2. What I Would Improve in the BLoC Setup Instead

### Phase 1: Stop the bleeding (Week 1–2)
- Enforce the rule: no BLoC with more than 5 constructor parameters.
- Add `flutter_bloc` linting rules via `custom_lint` to catch `BlocBuilder` without `buildWhen`.
- Remove all `registerLazySingleton + registerFactory` duplicates from the DI file.

### Phase 2: Structural improvements (Month 1–2)
- Split god-classes: `FetchUserDataBloc` → 4 focused BLoCs (see Scenario 2).
- Modularise the DI file: one `initXFeature()` function per feature.
- Add `buildWhen` to every `BlocBuilder` touching frequently-updated state.

### Phase 3: Observability (Month 2–3)
- Add `BlocObserver` to log state transitions to Crashlytics — makes debugging production issues much faster.
- Write unit tests for each newly extracted BLoC **before** the extraction goes to prod.

### Phase 4: Re-evaluate (Month 6)
- At this point we have isolated, testable BLoCs and a modular DI.
- If the team still wants Riverpod, migrate feature-by-feature with full test coverage protecting each migration step.

---

## 3. If We Did Migrate — Migration Strategy

**Approach: Strangler Fig pattern (feature by feature, never big-bang)**

Order (least risky to most risky):
1. New features only: all NEW screens use Riverpod `AsyncNotifierProvider`/`NotifierProvider`.
2. Leaf screens first: screens with no shared state (e.g. Settings) — migrate the BLoC to a Riverpod provider, keep the DI registration via `riverpod_annotation`.
3. Shared state last: `HomeBloc`, `FetchUserDataBloc` — only after we have integration tests protecting them.

Keep BLoC and Riverpod coexisting via `flutter_bloc`'s `BlocProvider.value` wrapping a BLoC that internally reads Riverpod providers. This lets us ship incrementally without a "migration branch" that diverges from main.

**Timeline estimate**: 80 BLoCs at 3–4 screens per sprint = ~20 sprints = 10 months. Too long without tests. That's why I don't recommend migrating now.

---

## 4. Rollback Plan

Since we're using the Strangler Fig (never deleting BLoC code until the Riverpod replacement is verified):
- Each migrated screen has a feature flag. If a Riverpod provider causes a production issue, flip the flag to route back to the BLoC-powered screen.
- The BLoC code is kept in a `_legacy/` subdirectory for 2 sprints after migration, then deleted once we're confident.
- No rollback needed for the "improve BLoC" path — every change is a small PR with its own test coverage.

---

## 5. Training 5 Developers

For Riverpod (if we chose to migrate):
1. Week 1: Team reads the Riverpod official docs and [codewithandrea.com](https://codewithandrea.com) architecture articles together (async). Each dev builds a toy feature with Riverpod.
2. Week 2: Pair-programming sessions — senior dev pairs with each junior/mid for their first Riverpod screen migration.
3. Ongoing: Code review acts as the learning feedback loop. PRs that misuse providers are corrected with explanatory comments, not just approvals.
4. Define team conventions document: when to use `NotifierProvider` vs `AsyncNotifierProvider` vs `StreamProvider`, how to scope providers, naming conventions.

For BLoC improvements (my actual recommendation):
- The team already knows BLoC. Training is just sharing the new conventions:
  - "Always add `buildWhen`"
  - "BLoC constructor max 5 params"
  - "Use `BlocSelector` for single-field reads"
- 30-minute team session + a shared style guide doc.

---

## 6. Success Metrics

| Metric | How to Measure | Target |
|---|---|---|
| Frame rendering | Flutter DevTools Performance overlay (% frames > 16ms) | < 5% janky frames on mid-range device |
| Rebuild count | `debugPrint` in `build()` during Profile mode test | < 3 rebuilds per user action |
| BLoC constructor size | Static analysis rule via `custom_lint` | 0 BLoCs with > 5 deps |
| Test coverage | `flutter test --coverage` | > 60% line coverage on all new/refactored BLoCs |
| DI file size | `wc -l` on DI file after modularisation | No single file > 300 lines |
| Bug rate | Crashlytics crash-free sessions | > 99.5% (same as before — migration should not regress this) |
