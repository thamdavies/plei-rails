# Web and Media Contracts

Rails HTML/Turbo forms, session cookies, CSRF on mutations. No standalone public JSON API. UUID `public_id` identifies Track; numeric revision ids only in scoped management/preview paths. Server chooses owner/role/status/public pointer.

## Routes

| Method/path | Access | Inputs/result |
| --- | --- | --- |
| GET `/` or `/tracks?q=&page=` | Public | current approved metadata only, query trimmed/case insensitive/literal substring, 25/page, stable ordering, empty state |
| GET `/tracks/:public_id` | Public | current public revision, stable share URL; unavailable 404 with return link |
| GET/HEAD `/tracks/:public_id/audio/:revision_id` | Public only if revision still current | audio/mpeg private,no-store, 200/206/416; mismatch/removed/deleted 404 |
| GET `/registrations/new` | Public | signup form |
| POST `/registrations` | Public | email/password/password_confirmation; default user role, unverified, enqueue verification; duplicate normalized email 422 |
| GET `/session/new` | Public | login form |
| POST `/session` | Public | create session; invalid login 422 generic |
| DELETE `/session` | Authenticated | revoke session, stop private preview, redirect public catalog |
| GET `/email_verifications/:token` | Token | confirmation page only, no state mutation |
| POST `/email_verifications/:token` | Token | verify bound email once; bad/expired 422 with resend guidance |
| POST `/email_verification_requests` | Authenticated | resend unverified email; verified account no-op |
| GET `/passwords/new`, POST `/passwords` | Public | request reset; generic outcome independent of email existence |
| GET `/passwords/:token/edit`, PATCH `/passwords/:token` | Token | reset password; 15m token, invalid token 422; revoke sessions |
| GET `/my/tracks`, `/my/tracks/new` | Authenticated | own submissions/status and upload form; unverified gets verification guidance |
| POST `/my/tracks` | Verified user | multipart title/artist/rights_confirmed/audio, new processing revision after full transfer; 303 owner status page |
| GET `/my/tracks/:public_id` | Owner | public state plus latest submission/decision, no other user's private content |
| GET `/my/tracks/:public_id/revisions/new` | Verified owner | revision form only if active and no processing/pending |
| POST `/my/tracks/:public_id/revisions` | Verified owner | metadata, optional replacement audio, rights confirmation; new revision; public pointer unchanged |
| DELETE `/my/tracks/:public_id` | Owner | tombstone and cancel pending/processing; immediately inaccessible publicly |
| GET/HEAD `/my/tracks/:public_id/revisions/:id/audio` | Owner/admin | protected derivative preview, 200/206; not-ready 409; unavailable 404 |
| GET `/admin/revisions`, `/admin/revisions/:id` | Admin | pending queue/details/preview only ready revisions |
| POST `/admin/revisions/:id/approve` | Admin | expected lock_version; atomic publish |
| POST `/admin/revisions/:id/reject` | Admin | expected lock_version/reason required; public pointer unchanged |
| POST `/admin/tracks/:public_id/remove` | Admin | expected lock_version/reason required; revoke public availability + cancel updates |
| GET `/jobs` and engine subtree | Admin | operations dashboard; authentication/role checks on mounted engine |

## Response and Upload Rules

HTML mutations success 303 to state page; 422 validation with field errors; 409 pending conflict/stale decision/cancelled job target; 403 authenticated user lacking role/verified email; unauthenticated HTML management redirects login. Private resource outside owner's scope returns 404. CSRF rejected with 422. Rate-limited request 429 with Retry-After. Upload bytes >30.000.000 rejects 413; proxy multipart request envelope limit 32 MiB, model checks exact file bytes; do not trust Content-Length alone. Both extension and actual container/decode validated. Validation errors never create admin pending entry; audio processing has explicit processing/failed UI and only successful processing enters pending queue. Other admin can preview owner URL after policy check; no separate leaking blob route.

## Media Protocol

GET and HEAD authorize before headers/body. Missing Range: 200 with correct Content-Length. Single valid byte range (including suffix/open end) returns 206, Content-Range and exact bytes; unsatisfiable range returns 416 and `Content-Range: bytes */N`. Multi-range request deliberately ignored and served authorized full representation 200. HEAD returns equivalent metadata/no bytes. Accept-Ranges bytes, Content-Type audio/mpeg, private,no-store, X-Content-Type-Options nosniff. Parse range safely and cap buffer to 64 KiB; close file/connection on client disconnect. No signed blob redirects, no default Active Storage endpoints or browser-cache replay after removal. ETag ties revision/checksum; handle If-Range consistently and never bypass current policy on conditional requests.

Removal/replacement is enforced for every newly authorized request; cannot retract already delivered/buffered bytes or promise stopping a currently-open transfer. Next play/range attempt fails and player explains unavailable. Admin decision creates immutable metadata snapshot; stream URL pinned to a revision avoids combining different files during one seek session. After revision replacement, player retries by fetching latest Track detail and asks user to restart.

## UI Contract

- One stable permanent player across same-origin Turbo pages; navigating catalog/detail/search keeps current time/play state and does not duplicate audio nodes/listeners. Full browser refresh need not preserve playback.
- User initiates playback; loading indicator until playing, errors accessible, retry and next selected song; selecting another stops first. Progress/time labels and keyboard seek. On iOS volume uses system controls if browser limits volume API.
- Copy canonical Track URL, not preview/audio URL; success only after clipboard promise resolves; fallback selectable input. Never auto-send messages.
- Owner page distinguishes live version from update awaiting review. Pending content visible only owner/admin, not snippets or public search.
- All fields have labels, focus/error association; usable keyboard and mobile viewport. Default vi locale. Native audio controls permitted as accessibility fallback.

## Requirement Traceability

FR-001/002 catalog+search; FR-003/004/007 media+player; FR-005/006 detail+share; FR-008 uploads+processing; FR-010 auth+verification+policies; FR-011 public pointer filtering; FR-012 decisions+409; FR-013 revision update; FR-014 delete/remove. No FR-009 implementation (deferred favorites).

## Operation Result Boundary

Controllers/jobs invoke injected operation with actor and allowed input. Operations return Success(payload) or Failure({code, errors}); field errors map to 422, forbidden to 403, not_found to 404, stale_state to 409, rate_limited to 429, upload_too_large to 413. Payload/error shape is a project convention, not automatic dry-rails rendering. Unexpected errors propagate to logging/error handling rather than all being converted to validation failures. Authentication redirects remain controller concerns. Shared operations enforce authorization even when invoked by a job/console.
