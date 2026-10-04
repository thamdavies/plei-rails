# Quickstart and Validation Guide

Thiết kế cho implementation sắp tới; các luồng mới chưa chạy ở thời điểm viết tài liệu này. Không coi lệnh dưới đây là kết quả test đã pass. Data lifecycle: [data-model.md](data-model.md); HTTP/UI expectations: [contracts/web.md](contracts/web.md).

## Prerequisites

Ruby 3.4.4, Bundler, Node theo `.node-version`, Yarn 1.x, Docker Compose, FFmpeg/ffprobe (build có MP3 encoder), Chrome/Selenium và các thiết bị Safari iOS/Chrome Android để thử audio. Dùng test fixtures có quyền sử dụng. Không dùng credential production cho thử local.

## Local Setup (after implementation)

Từ repository root, chạy tuần tự:

```sh
docker compose up -d --wait db
bundle install
yarn install --frozen-lockfile
bin/rails db:prepare
bin/rails db:seed
```

Seeds cần được implementation tạo dữ liệu test/dev: admin + hai user owner/other, email chưa xác minh/đã xác minh, 20 bài với pending/rejected/approved, M4A AAC và ALAC, failed upload. Admin password lấy env hoặc tương tác console, không hardcode production secret. Không promote admin bằng public registration.

Chạy ở ba terminal:

```sh
bin/rails server -p 1996
```

```sh
bin/dev
```

```sh
bin/jobs
```

`Procfile.dev` hiện chỉ watch JS/CSS, không khởi động Rails hoặc worker. Mở `http://localhost:1996`. Development mail log/preview để lấy token; SMTP production phải cấu hình riêng. ffprobe/ffmpeg phải có trong PATH của web/worker. Chuẩn bị migrations users/sessions/domain/Active Storage và test schema trong bước implementation, không chạy generator trong planning.

## Automated Checks

```sh
RAILS_ENV=test bin/rails db:prepare
bin/rails test
bin/rails test:system
bundle exec rubocop
bin/brakeman --no-pager
bin/bundler-audit
```

Các test mới phải chứng minh authorization ở endpoint audio thực, không chỉ DOM/link visibility. Job tests dùng test adapter/drain; mail tests kiểm tra nonce/expiry/reuse; concurrency tests dùng connections riêng, disable transactional fixtures cho race cases. Kết quả audit dependency ghi riêng, không tự coi fail là pass.

## End-to-End Scenarios

1. **Register/verify**: đăng ký email chưa có, chưa xác minh không tải được; resend, mở token GET không verify, xác nhận POST verify; reuse/expired/bad token bị từ chối. Email trùng khác hoa/thường không tạo tài khoản mới. Reset password revoke sessions.
2. **Upload**: user verified gửi MP3/M4A, status processing rồi pending, preview owner/admin; guest và other user bị chặn cả metadata lẫn bytes. Tệp rỗng, giả đuôi, corrupt cuối tệp, >30.000.000, thiếu rights/title/artist fail. Đúng byte boundary nhận; interrupted request không pending. AAC/ALAC M4A normalize ra MP3 nghe được.
3. **Moderate**: approve → public searchable/shareable; reject yêu cầu lý do → only owner/admin. Stale admin form 409, không duplicate decision. Preview chưa xử lý trả not-ready, không pending.
4. **Revision**: sửa metadata/thay M4A: link không đổi, old public title/audio còn trong search/detail. Owner/admin nghe update; guest audio update 404. Reject giữ old. Approve switch pointer atomically; old public media request mới 404.
5. **Remove/delete race**: khi update processing/pending, remove/delete cancel update. Racing approval/processing completion không republish tombstoned track. Raw blob/default Active Storage route 404. Guest unavailable page có link về catalog.
6. **Player/share**: play/pause/seek/volume/time, only one audio, no autoplay; navigate detail/search/back vẫn nghe đúng thời điểm, reconnect không duplicate listeners. Copy đúng URL, clipboard denied có fallback. Logout dừng preview. Network error, deleted song và play promise rejected hiển thị retry hợp lý. Safari iOS dùng system volume.
7. **Operations**: `/jobs` chỉ admin; SMTP fail retry và không verify; FFmpeg timeout thành failed; upload flood 429. Purge không xóa blob đang dùng; restart container còn dữ liệu volume, restore backup thử trên isolated database/volume.

## Performance and Usability Acceptance

Sau khi implementation bổ sung fixture/task load-data riêng, seed 1.000 bài công khai trong môi trường benchmark, không reset dữ liệu production. 20 browser contexts/device sessions start play bằng click, ghi thời điểm click→playing bằng browser timestamps; tối thiểu 100 lượt start, mỗi người nghe ít nhất 5 phút. Mô phỏng connection mỗi client ≥10 Mbps và RTT ≤100 ms; dùng tệp MP3 derivative thật, không mock audio hoặc warm cache toàn bộ. Pass SC-010 khi p95 ≤3 giây và không stream/start thất bại do overload. Thu 5xx/CPU/RAM/disk/bandwidth để phân biệt nguyên nhân. HTTP-only range load bổ sung kiểm tra capacity nhưng không thay phép đo click→playing browser.

Với 10 người lần đầu, đo find→play ≤60s (9/10), share ≤15s (9/10), upload ≤3 phút không tính transfer (9/10), admin thao tác ≤60s sau nghe thử; đánh giá dễ dùng ≥4/5 (8/10). Kiểm chứng 10 share links, 10 unavailable links, 15 moderation-state tracks và verified/unverified như SC-003/004/007/009/011. Ghi raw timings và exceptions, không chỉ nhận xét cảm tính.

## Production Readiness (before release)

Set actual APP_HOST/from/SMTP config, HTTPS secure cookies/allowed hosts, private persistent storage volume, FFmpeg runtime tools, job worker, reverse proxy body envelope 32 MiB và streaming timeout phù hợp. Disk outside public path. Daily PostgreSQL+volume backup và restore rehearsal, >80% disk alert. Không deploy hoặc chọn nhà cung cấp SMTP trong workflow lập kế hoạch này.

## Dry-Rails Compatibility and Architecture Validation

Before feature work: add chosen dry-rails/dry-validation/dry-monads dependencies, resolve and inspect lockfile; verify Ruby/Rails constraints. Run `bin/rails zeitwerk:check`, boot development/test and production eager-loading with isolated config, and start worker. Resolve representative `revisions.submit` and `moderation.approve` keys through PleiRails::Container after components exist; reload and ensure new class behavior is used without stale instances. Do not claim compatibility before these checks pass.

Verify contracts with invalid input and operation Success/Failure paths, inject audio/storage/clock doubles for unit tests, and integration-test real DB rollback: a failure after a write must leave no partial publication/decision. Verify queued work appears only after commit and retry is idempotent. Concurrent requests must not share actor or params through component instances. Unit tests prefer constructor injection over global container stubs to preserve parallel-test isolation.
