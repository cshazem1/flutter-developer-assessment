# Scenario 2: Refactor Under Pressure — God BLoC with 3-Week Deadline

## 1. Decision: Incremental Refactor DURING the Launch Sprint

**I would NOT do a big-bang refactor now, and NOT defer it entirely.**
Instead: extract the new live-streaming feature into its own focused BLoC immediately, and leave the existing `FetchUserDataBloc` intact for now.

Rationale:
- A full 21-dependency split 3 weeks before launch = high regression risk with zero test coverage.
- Pure deferral = we keep adding to the god-class, making it worse and harder to split later.
- Incremental extraction = the new feature ships clean, the old code doesn't change, no merge risk.

---

## 2. Risks for Each Option

| Option | Key Risks |
|---|---|
| **Full refactor now** | No tests → regressions everywhere. 3 weeks is not enough for a safe 21-dep split + regression validation. Launch delay likely. |
| **Do nothing** | New live-streaming code goes into FetchUserDataBloc → it grows to 25+ deps. Technical debt compounds. Next feature will be even harder. |
| **Incremental (my choice)** | Small risk: new BLoC must not duplicate state already in FetchUserDataBloc. Mitigated by clear interface contract. |

---

## 3. The Split I Would Make Now (Minimal, Safe)

Create only ONE new BLoC for the new feature:

```
LiveStreamingBloc(
  StartStreamUC,
  StopStreamUC,
  FetchStreamStatsUC,
)
```

Register as `registerFactory` (short-lived, per-room screen).

Post-launch, plan the full split in a dedicated refactor sprint:

```
UserProfileBloc   → FetchMyProfileUC, FetchUserProfileUC
RealTimeBloc      → InitPusherUC, SubscribeChatUC, SubscribeMessagesUC,
                    ListenToBannersUC, ListenToGamesUC, SubscribeCounterUC
AppConfigBloc     → FetchConfigUC, FetchCountriesUC, InitAnalyticsUC, UpdateFCMTokenUC
UserExtrasBloc    → FetchUserBadgesUC, FetchLevelDataUC, FetchWalletUC,
                    FetchGiftHistoryUC, FetchUserRoomsUC, FetchSupporterUC,
                    FetchCpProfileUC, FetchUserIntroUC, FetchMyBadgesUC
```

Dependency diagram:

```
Core deps (Dio, Hive)
    │
    ▼
DataSources → Repositories → UseCases
                                 │
                    ┌────────────┼────────────┬────────────┐
                    ▼            ▼            ▼            ▼
           UserProfile     RealTime      AppConfig    UserExtras
              BLoC           BLoC          BLoC          BLoC
```

---

## 4. Making the Launch Safer Without Full Refactor

- **Feature flag**: wrap the new live-streaming entry point behind a remote config flag so we can disable it in production without a release if something goes wrong.
- **Isolate**: the new `LiveStreamingBloc` takes no deps from `FetchUserDataBloc` — it stands alone.
- **Manual smoke test checklist**: document the 10 most common user flows that touch `FetchUserDataBloc` and walk through them before release.

Post-launch plan (Week 4–6 after launch):
1. Write characterization tests for current behaviour (record what the god-class does, don't test correctness yet).
2. Extract BLoCs one at a time, starting with `AppConfigBloc` (lowest risk — pure data fetching, no WebSocket).
3. Each extraction: one PR, one code review, one day of internal testing.

---

## 5. Team Coordination — Avoiding Merge Conflicts

- **Feature branches**: the dev doing the new live feature works in `feat/live-streaming`; refactor work happens in `refactor/app-config-bloc`. No two branches touch `FetchUserDataBloc` at the same time.
- **Trunk-based lock**: agree that no one merges into `main` the day before release.
- **Diff size rule**: refactor PRs are limited to extracting ONE BLoC at a time (~200 lines max). Reviewable in 30 minutes.
- **Clear owner**: one dev owns the FetchUserDataBloc file during the sprint. Other devs branch off from their last sync point.

---

## 6. Testing Strategy — Zero Coverage Starting Point

**Before the refactor:**
1. Add **widget tests** for the 3 screens most likely to break: home, room, profile. Use `MockBloc` to supply canned states — these catch "did the UI break?" not "is the BLoC logic right?".
2. Add **unit tests** for each NEW BLoC as we extract it. This is the investment that pays off immediately.

**I would NOT** try to write tests for the existing `FetchUserDataBloc` before refactoring — with 21 dependencies it would take longer to set up the test harness than to do the refactor itself. Write tests for the new smaller BLoCs as they emerge.

**Testing order:**
1. Widget tests for screens (protect the UI) → 2 days
2. Unit tests for each extracted BLoC → 0.5 day per BLoC
3. Integration test for the new LiveStreamingBloc → 1 day
