# Implementation Plan: Trang nghe và chia sẻ nhạc

**Branch**: `main` (Git thực tế); feature locator `001-music-sharing` | **Date**: 2026-10-04 | **Spec**: [spec.md](spec.md)

**Input**: `specs/001-music-sharing/spec.md`

## Summary

Mở rộng ứng dụng Rails hiện có để người dùng đăng ký, xác minh email và gửi nhạc; admin duyệt trước khi công khai. Tách Track khỏi TrackRevision để bản sửa chờ duyệt không thay đổi bản đang phát hay liên kết chia sẻ. Lưu tệp riêng tư, phát qua endpoint kiểm tra quyền hỗ trợ HTTP Range; dùng một trình nghe cố định qua điều hướng Turbo. Không xây yêu thích hoặc playlist. Theo chỉ định mới, dùng dry-rails cho container/dependency injection; nghiệp vụ nằm trong operations, đầu vào trong contracts, kết quả Success/Failure rõ ràng.

## Technical Context

**Language/Version**: Ruby 3.4.4 (`.ruby-version`), Rails 8.1.4 (`Gemfile.lock`), JavaScript ES modules.

**Primary Dependencies**: PostgreSQL/pg, Hotwire Turbo + Stimulus, Slim/Phlex/RubyUI, Tailwind 4, Active Storage, Action Mailer, Solid Queue đã có. Bổ sung dry-rails, dry-validation và dry-monads (khai báo dependency trực tiếp cho API dùng trực tiếp); dry-system/dry-auto_inject qua dry-rails. Bổ sung bcrypt bằng authentication generator; FFmpeg/ffprobe vào máy phát triển, CI và image runtime. Không thêm SPA hoặc dịch vụ nhạc ngoài.

**Storage**: PostgreSQL cho dữ liệu; Active Storage Disk riêng tư trên persistent volume cho bản gốc và MP3 phát. Một host cho v1; PostgreSQL hiện dùng Docker image 18.0, cổng development 5439. Chưa có migration nghiệp vụ.

**Testing**: Minitest model/integration/mail/job; Capybara/Selenium browser system tests; kiểm tra browser thật cho phát/tua/persistence trên Chrome desktop, Safari iOS và Chrome Android; kiểm tra tải đồng thời riêng trước release.

**Target Platform**: Linux Docker server, HTTPS; web responsive tiếng Việt.

**Project Type**: Rails monolith server-rendered HTML.

**Performance Goals**: 1.000 bài công khai, 20 người nghe đồng thời; 95% bắt đầu phát trong 3 giây và không thất bại do quá tải trong phép thử SC-010. SC-001–SC-011 được kiểm tra theo spec (không có SC-006).

**Constraints**: MP3/M4A tối đa 30.000.000 byte; chỉ email đã xác minh được gửi nhạc. Một bản pending mỗi bài; public revision độc lập. Không URL blob công khai, không full-file buffer trong Ruby để phát nhạc. Không sửa ứng dụng trong giai đoạn lập kế hoạch.

**Scale/Scope**: Khách, người đăng và admin; catalog/search/detail/player, auth, uploads của mình, hàng duyệt. Mục tiêu 1.000 bài không là quota cứng. Provision ban đầu tối thiểu 100 GB volume với theo dõi dung lượng; bản gốc có thể chiếm 30 GB, cộng derivative, phiên bản và backup phải tính riêng.

## Constitution Check

**Before research**: Constitution hiện chỉ chứa placeholder, chưa có nguyên tắc được phê chuẩn. Không diễn giải ví dụ thành luật và không tự sửa constitution. Không có gate định nghĩa để vi phạm; tiếp tục theo spec và hướng dẫn skill.

**After design**: Không có gate constitution mới. Thiết kế giữ nền tảng sẵn có, không thêm sản phẩm ngoài phạm vi, tách quyền truy cập khỏi URL tệp, dùng giao dịch cho duyệt/xóa/gỡ. Spec đạt chất lượng 16/16 ở bước trước; readiness này không xác nhận implementation hoặc performance đã pass.

## Project Structure

### Documentation (this feature)

```text
specs/001-music-sharing/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/web.md
└── checklists/requirements.md
```

`tasks.md` sẽ được tạo bằng `$speckit-tasks`, không tạo trong workflow này.

### Source Code (repository root)

```text
app/
├── models/{user,session,track,track_revision,moderation_decision}.rb
├── controllers/{tracks,media,registrations,sessions,passwords,email_verifications}_controller.rb
├── controllers/my/{tracks,revisions}_controller.rb
├── controllers/admin/{revisions,takedowns}_controller.rb
├── operations/{users,tracks,revisions,moderation,audio}/
├── contracts/{users,tracks,revisions,moderation}/
├── queries/{tracks,revisions}/
├── policies/{track_access,moderation_access}.rb
├── adapters/{audio_processor,audio_storage,mail_delivery,clock}.rb
├── jobs/{process_audio,purge_retired_audio}_job.rb
├── mailers/{email_verification,passwords}_mailer.rb
├── views/{tracks,my,admin,registrations,sessions,passwords,email_verifications}/
├── components/{player,sidebar,top_nav}.rb
└── javascript/controllers/{player,upload,share}_controller.js
config/initializers/system.rb
config/system/
config/{routes,storage,locales/vi,environments}/
db/migrate/
test/{operations,contracts,queries,adapters,models,integration,jobs,mailers,system,fixtures/files}/
```

**Structure Decision**: Tái sử dụng layout Slim/Phlex hiện có; thay catalog mẫu bằng truy vấn revision đã công khai. Controllers/jobs là adapters gọi operation từ PleiRails::Container; operations dùng PleiRails::Deps và nhận actor/input theo từng lời gọi. Contracts kiểm tra input nghiệp vụ, policies kiểm tra quyền, queries đọc dữ liệu, adapters bọc FFmpeg/storage/mail/clock. Active Record giữ association/invariant và DB constraints; không thêm ROM hoặc repository chung chỉ để bọc CRUD. Không migration thư viện yêu thích. Danh sách path là đích thiết kế, chưa có các file này.

## Delivery Sequence and Validation

1. Compatibility spike dry-rails với Rails 8.1/Ruby 3.4: resolve dependencies, boot, Zeitwerk, eager-load, reload và job boot; sau đó schema, auth/session, email verification/reset, giới hạn request và bảo vệ `/jobs`.
2. Private storage, upload/validation/processing, owner UI; chưa có bài được công khai trước processing thành công.
3. Admin moderation transaction và preview; kiểm tra race duyệt/duyệt, duyệt/gỡ, duyệt/xóa.
4. Public catalog/search/detail/media, player persistent, share fallback; loại link navigation mẫu không thuộc phạm vi.
5. End-to-end security, media và usability/load checks; cấu hình production SMTP/HTTPS/volume/backup trước release.

Kiểm tra từng FR tại [contracts/web.md](contracts/web.md), lifecycle tại [data-model.md](data-model.md), chạy kiểm chứng tại [quickstart.md](quickstart.md).

## Operational Design

- SMTP qua Action Mailer + Solid Queue; production host/from/SMTP lấy env/credentials, development dùng mail log/preview. Retry mail có giới hạn, failures thấy trong jobs dashboard chỉ admin; không coi enqueue thành email verified.
- Rate limits khởi điểm có thể cấu hình: login 10/3 phút/IP; đăng ký 5/giờ/IP; resend/reset 3/15 phút/email + 10/giờ/IP; upload 10/giờ/account và một processing job/account. Trả 429/Retry-After; không áp quota cứng cho số bài.
- HTTPS, Secure/HttpOnly/SameSite cookies, CSRF trên mutations, strong params không nhận role/owner/public pointer, không log password/token/file bytes. Không đưa tệp vào public/.
- Processing timeout 120 giây/job, bounded worker concurrency 1 cho audio ban đầu; status processing/error khác status chờ admin. FFmpeg chạy bằng argv, không shell, chỉ file local, không mạng, output và CPU/RAM có giới hạn. Timeout là lỗi có thể tải lại, không tạo pending.
- Backup PostgreSQL và volume cùng cửa sổ nhất quán mỗi ngày; giữ 7 bản, chạy restore thử trước release. Alert job errors, disk >80%, stream 5xx; log request id/revision id/decision id, latency và audio processing failures.
- Purge bản gốc/derivative đã xóa, bị thay thế hoặc từ chối sau 7 ngày; giữ metadata/audit. Không purge blob còn được revision khác tham chiếu. Từ chối có thể sửa thông tin và gửi lại trong cửa sổ này; sau purge cần tải lại tệp. Gỡ/xóa chặn mọi request mới ngay; không thể thu hồi byte đã gửi/buffer ở thiết bị.

## Research Completion

Các điểm chưa biết về auth, media protection, playback codecs, concurrency, player persistence và môi trường chạy đã có quyết định trong [research.md](research.md). Không còn quyết định kỹ thuật bắt buộc chờ trả lời. SMTP/domain/host cụ thể là cấu hình release, không cản thiết kế.

## Dry-Rails Architecture Constraint

User chỉ định dry-rails ngày 2026-10-04. Container là `PleiRails::Container`, injector `PleiRails::Deps` theo namespace hiện tại trong config/application.rb. Cấu hình component dirs rõ trong config/initializers/system.rb; keys theo nhóm `revisions.submit`, `moderation.approve`, `contracts.revisions.submit`, `queries.tracks.public_catalog`, `adapters.audio_processor`. Namespace của class phải khớp Zeitwerk/component dirs, kiểm tra khi boot/reload; config/system chỉ cho dependencies cần lifecycle boot.

Operations là Ruby callable dùng dry-monads Result; orchestration validate → authorize → transaction → enqueue-after-commit. Không mặc định bật dry-transaction (legacy) hoặc DSL matcher. Dry::Operation là lựa chọn bổ sung sau compatibility spike, không dependency bắt buộc. ApplicationContract/dry-validation dùng cho shape/coercion/rules của từng use case; strong params allowlist ở HTTP boundary, không validate trùng shape bằng safe_params và Contract. Tắt safe_params nếu không dùng; bật application_contract/controller_helpers theo API thực tế của bản gem chọn.

Container chỉ giữ component stateless; actor/current user, record, params, upload/IO và request context truyền vào call, không lưu trong singleton. Storage/mail/clock inject qua Deps, không gọi container tùy tiện trong model. Quyết định quyền kiểm tra lại dưới lock cho mutations. Monadic Failure không tự rollback Active Record: trước commit, mọi failure phải rollback rõ ràng; sau commit enqueue không làm operation giả báo rollback. Job enqueue dùng after_commit; worker retry idempotent theo revision id.

Unit tests contract/operation inject doubles trực tiếp; test DB/giao dịch dùng adapter thật. Không global stub container trong parallel Minitest nếu không isolate/restore. Compatibility chưa được xác nhận bằng bundle/runtime: cấm hạ Rails hoặc bỏ dry-rails âm thầm; nếu spike fail, ghi lỗi/dependency matrix và chọn bản compatible để kiểm tra lại trước feature implementation.
