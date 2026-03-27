# Scenario 1: Offline-First Chat Architecture

## 1. Architecture Design

### Local Storage
Use **Hive** (already in the stack) with a structured `MessageBox`:

```
MessageBox schema:
  id          String   (UUID, client-generated)
  roomId      String
  senderId    String
  content     String
  createdAt   int      (Unix timestamp ms)
  status      String   ('pending' | 'sent' | 'failed' | 'delivered')
  syncedAt    int?     (null until confirmed by server)
```

Rule: every message is written to Hive **first**, then sent to the API/Pusher. The UI always reads from Hive — never from an in-memory list that disappears on restart.

### Sync Strategy
- **Send path**: write to Hive with `status=pending` → POST to REST API → on success, update `status=sent` and `syncedAt`.
- **Receive path**: Pusher delivers new messages → write to Hive (dedup by `id`) → UI reacts via Hive `watch()`.
- **Reconnect path**: on network restore, query `SELECT * WHERE status='pending' ORDER BY createdAt` and retry sends in order.
- **History pull**: on first open of a chat, fetch last N messages from REST API and upsert into Hive (server `id` is the dedup key).

### Conflict Resolution
- No true conflict: chat is append-only. The only "conflict" is a pending message that the server already received (duplicate send on retry). Guard: server returns `409 Conflict` with the existing `id` → mark local record `sent`.
- Order is determined by server `createdAt` on the timeline; client shows messages in local `createdAt` order while offline, then re-sorts after sync.

---

## 2. Sprint 1 (Weeks 1–2) — MVP: Offline Reading + Optimistic Send

**Flutter (you):**
- Add Hive adapter for the `Message` model.
- Refactor `MessagesRepository` to write-to-Hive-then-send.
- Show Hive data in `MessagesBloc`; remove in-memory list.
- Display "Sending…" badge on pending messages.
- Add `ConnectivityBloc` that listens to `connectivity_plus` and triggers retry on reconnect.

**Backend (1 dev):**
- Add `POST /messages` idempotency key header so retries don't duplicate.
- Add `GET /messages?after_id=X&limit=50` cursor-based endpoint for efficient history pull.

**Definition of Done:**
- User can read last 50 cached messages with no internet.
- User can type and "send" a message offline; it queues and delivers when back online.

---

## 3. Sprint 2 (Weeks 3–4) — Reliability + UX Polish

**Flutter:**
- Implement exponential back-off retry (1s, 2s, 4s, max 30s) for failed sends.
- Show "Failed — Tap to retry" on `status=failed` messages.
- Paginate history: load older messages from Hive first; pull from API only when Hive has no older records.
- Add `SyncStatusIndicator` banner ("You're offline — messages will send when connected").

**Backend:**
- Cursor pagination (`after_id`) in production.
- Webhook / Pusher event for `message_delivered` so client can flip `sent → delivered`.

---

## 4. Sprint 3 (Weeks 5–6) — Polish & Edge Cases

- Prune Hive: delete messages older than 30 days to control storage growth.
- Handle app killed mid-send: on cold start, scan pending messages and retry.
- Test on slow connections (throttle to 2G in Android emulator).
- Test with large font / RTL text.
- Write integration tests for the sync flow using `mocktail` for the API and a real Hive test database.

---

## 5. What We Explicitly DO NOT Build

| Out of scope | Why |
|---|---|
| End-to-end encryption | Requires key exchange protocol; 3 more weeks minimum |
| Multi-device message read-receipts | Backend sync complexity; out of 1-dev capacity |
| Media messages (images/video) offline | Binary blob storage & upload queue is a separate system |
| Full-text search of cached messages | Nice-to-have; Hive is not a query engine |

---

## 6. Risk Analysis

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Duplicate messages on retry | High | Medium | Server idempotency key; client dedup by `id` |
| Hive data grows too large | Medium | Medium | 30-day TTL prune job on app foreground |
| Pusher drops messages during disconnect | High | High | Pull history on reconnect using `after_id` cursor |
| Message order wrong after sync | Medium | High | All messages sorted by server `createdAt` after sync |
| Hive corruption on force-quit | Low | High | Wrap Hive writes in transactions; keep a WAL |

---

## 7. Local Message Table Schema (Hive TypeAdapter)

```dart
@HiveType(typeId: 10)
class LocalMessage extends HiveObject {
  @HiveField(0) String id;           // UUID (client-generated)
  @HiveField(1) String chatRoomId;   // which conversation
  @HiveField(2) String senderId;
  @HiveField(3) String content;
  @HiveField(4) int createdAtMs;     // client timestamp (fallback ordering)
  @HiveField(5) int? serverCreatedAtMs; // set after server confirms
  @HiveField(6) String status;       // 'pending' | 'sent' | 'failed' | 'delivered'
  @HiveField(7) int? syncedAtMs;     // when we heard back from server
}
```

Indexes (via Hive compound box key): `chatRoomId + createdAtMs` for sorted reads.
