# Data Model

## User

`id`, `email_address` normalized lower/strip, `password_digest`, `verified_at` nullable, `role` user/admin default user, `verification_nonce` random, timestamps. Unique index email; no role mass-assignment. Email change ngoài scope. Password 12+ ký tự, tối đa 72 byte; validation thống nhất với registration/reset. Verification tokens bind id/email/nonce, 24h; rotate nonce after consumption. Password reset 15m, invalidated by password change.

## Session

`id`, `user_id` FK, `ip_address`, `user_agent`, timestamps. Signed encrypted/secure cookie references session; server revoke on logout/reset. Generated auth base adjusted to permit public catalog/media only.

## Track

`id` bigint, `public_id` unique immutable UUID, `owner_id` FK User, `published_revision_id` nullable FK TrackRevision, `removed_at`, `deleted_at`, `removal_reason`, `lock_version`, timestamps. Public visibility requires not deleted/removed and public pointer to approved/ready revision belonging to this Track. Displayed title/artist come only from public revision.

Status là suy ra: removed khi removed_at có giá trị; nếu chưa removed và public pointer có thì approved (dù revision mới pending/rejected); nếu chưa có public pointer dùng trạng thái revision mới nhất. Deleted là tombstone, không trạng thái hiển thị thường.

## TrackRevision

`id`, `track_id` FK, `sequence` integer, `submitted_by_id` FK User, `title` 1..200 chars trimmed, `artist` 1..200 chars trimmed, `status` processing/pending/approved/rejected/failed/superseded/cancelled, `rights_confirmed_at`, `submitted_at`, `processed_at`, `duration_seconds` positive, `source_format`, `processing_error_code`, `lock_version`, timestamps. Active Storage attachments `original_audio` and `playback_audio`. Ảnh bìa optional: v1 dùng placeholder, không thêm upload ảnh.

- Unique `(track_id, sequence)` và partial unique `(track_id)` WHERE status IN ('processing','pending').
- Metadata và attachment immutable sau submit. Sửa một revision bị từ chối tạo revision mới; gửi lại metadata-only có thể dùng lại original blob còn tồn tại nhưng phải tạo derivative và kiểm tra trước pending.
- Input 1..30.000.000 bytes, MP3/MP4-family M4A có audio hợp lệ; validation/decode như research. MIME client không đáng tin. Attachment source/derivative không có route public.
- `published_revision_id` phải thuộc Track tương ứng: composite FK `(track_id, revision_id)` với unique `(track_id,id)` hoặc equivalent database constraint; service validation một mình không đủ. Thêm FK pointer sau khi cả hai tables tồn tại.

## ModerationDecision

`id`, `track_id` FK, `revision_id` nullable FK (bắt buộc approve/reject), `admin_id` FK User, `action` approve/reject/remove, `reason` bắt buộc reject/remove 1..2.000 chars, `created_at`. Append-only. Snapshot revision sequence để audit dễ đọc; không public email admin. Remove references current published revision nếu có.

## Relationships

User owns many Tracks and Sessions. Track has many revisions/decisions and zero or one current public revision. Revision belongs to Track/submitter and has decisions. UUID share URL points to Track, not revision/file, no share-link table cần thiết.

## State Transitions

| Action | Revision | Track/public pointer |
| --- | --- | --- |
| Submit valid metadata/upload | new processing | unchanged; new Track has no public pointer |
| Process/decode success | processing → pending | unchanged |
| Invalid input/decode/timeout | processing → failed | unchanged; not in admin queue |
| Admin approve | pending → approved; previous approved → superseded | atomically switch pointer |
| Admin reject with reason | pending → rejected | unchanged |
| Resubmit rejected | new processing, old stays rejected | unchanged |
| Remove by admin | processing/pending → cancelled | removed_at set, pointer cleared, reason/audit recorded |
| Delete by owner | processing/pending → cancelled | deleted_at set, pointer cleared |

For approve/reject/remove/delete/submit and processing completion: transaction lock Track first then revision; recheck deleted/removed/status/token. Job completion cannot change cancelled revision to pending. Duplicate job finds completed state and exits without new attachment/decision. Expected lock_version and pending status from admin form reject stale operation with 409. Failed metadata validation creates no Track/revision; processing records only appear after complete transfer, never advertised as pending. Failed records owner-visible for retry by new submission.

Removed/deleted Tracks cannot be edited/resubmitted/reopened by stale form. New Track submission is permitted independently, subject to admin review.

## Retention and Read Rules

Only current approved revision on active Track is public. Owner/admin may preview pending/rejected/processing-ready derivative; everyone else receives 404. No derivative yet returns explicit not-ready error to authorized user. Superseded versions no longer public; audit remains. Purge retired binaries after 7 days; shared blob only purge when all referring revisions retired. Deleted metadata persists for unavailable share links/audit, hidden from normal lists.

Admin list reads pending revision metadata; owner list shows public state and pending/rejected update separately. Do not expose pending title/artist in search/snippets. Search matches public title/artist, literal substring case-insensitive, paginated 25; ties use id stable order.

Implementation boundary: dry-validation contracts validate use-case input; Active Record/DB retain invariant/uniqueness/FK constraints. Operations own lifecycle transitions and explicit rollback on Failure; schema and publication rules above are unchanged. Container components must not retain request/record state.
