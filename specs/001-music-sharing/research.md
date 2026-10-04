# Research: Nghe và chia sẻ nhạc

Ngày: 2026-10-04. Nghiên cứu từ repo và tài liệu chính thức; không cài dependency hoặc chạy migration. Skill yêu cầu research agent: một agent nghiên cứu audio/private delivery, kết quả hợp nhất ở đây.

## 1. Rails monolith và authentication

**Decision**: Giữ Rails 8.1.4, Ruby 3.4.4, PostgreSQL, Hotwire, Slim/Phlex/Tailwind hiện có. Dùng Rails authentication generator + bcrypt cho session/password reset; bổ sung registration và email verification riêng. Email normalize strip/downcase + unique DB index. Verification token purpose-bound, hạn 24 giờ, invalidated bởi verified_at; reset token 15 phút và invalidated khi đổi password. GET token chỉ hiện trang xác nhận, POST thực hiện để tránh mail scanner xác minh tự động. Password tối thiểu 12 ký tự, tối đa 72 byte; revoke sessions sau reset. Admin được cấp qua console/ops, không public signup.

**Rationale**: Generator là nền tảng cơ bản, không cung cấp registration/email confirmation hoàn chỉnh; không coi đăng nhập là đã xác minh email. Tái sử dụng giảm dependency.

**Alternatives considered**: Devise đầy đủ nhưng thêm framework auth; OAuth/social login ngoài scope.

**Sources**: [Rails security/authentication](https://guides.rubyonrails.org/security.html), [Getting started](https://guides.rubyonrails.org/getting_started.html). Chỉ dựa phần generator/auth/reset, không suy diễn generator có email verification.

## 2. Track và revision riêng

**Decision**: Track giữ UUID share link và pointer public revision; revision giữ metadata/tệp/status; duyệt chuyển pointer trong transaction khóa Track rồi Revision. Bản sửa không mutate public revision; mỗi lần gửi là revision bất biến sau submit. Partial unique index chặn nhiều processing/pending cùng Track. Decision append-only; pending stale xử lý 409.

**Rationale**: Giữ link và bản cũ trong lúc chờ; khóa cùng thứ tự cho duyệt/gỡ/xóa, bảo đảm gỡ không bị thao tác stale publish lại.

**Alternatives considered**: Overwrite một row làm lộ bản chưa duyệt; copy toàn bộ Track làm đổi link. Không dùng event sourcing.

**Source**: [Active Record pessimistic locking](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html). Invariants và schema là quyết định thiết kế cho spec.

## 3. Private storage và HTTP Range

**Decision**: Active Storage Disk trên volume riêng tư; tắt default routes bằng `config.active_storage.draw_routes = false`. Không direct upload và không public signed blob/disk routes. App-owned GET/HEAD media checks Track visibility và revision permission ở mọi request, hỗ trợ single byte Range 206/416 và streaming theo chunk; full file không vào memory. Cache-Control private,no-store; không CDN/public cache hoặc redirect storage URL. Public media endpoint chứa revision id và kiểm tra nó vẫn là public pointer; old revision bị thay thế không dùng được cho request mới.

**Rationale**: Signed URLs là bearer access chứ không phải policy; moderation removal phải chặn request mới. Disk đủ cho một host/quy mô v1, không phải lựa chọn cho multi-host.

**Alternatives considered**: Default Active Storage proxy/redirect dễ bypass moderation; S3/CDN thêm cấu hình và revoke/cache complexity. Có thể nghiên cứu offload nội bộ Nginx khi performance thử không đạt.

**Sources**: [Active Storage authenticated controllers](https://guides.rubyonrails.org/active_storage_overview.html#authenticated-controllers), [HTTP Range](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Range_requests).

## 4. Nội dung audio thực và M4A playback

**Decision**: Kiểm tra extension MP3/M4A, byte size 1..30.000.000 và nội dung container/stream bằng ffprobe; decode đầy đủ bằng ffmpeg để phát hiện corrupt. MP3 stream codec MP3; M4A container MP4 family có audio và không video chuyển động (ảnh bìa attached-picture được bỏ qua); không giới hạn ngầm M4A chỉ AAC. Input mà FFmpeg runtime giải mã được được normalize thành MP3 derivative private, 192 kbps, không metadata/embedded image, để browser phát ổn định. Chấp nhận M4A AAC và ALAC qua fixtures. Tệp container khác giả đuôi, DRM/encrypted, decode error hoặc timeout phải báo lỗi. Không dùng analyzer tự động làm bằng chứng tệp hợp lệ.

**Rationale**: M4A là container, browser codec support khác nhau. Probe metadata không chứng minh toàn file decode được; normalization tránh codec riêng của thiết bị. UI processing rõ, chỉ chuyển pending khi derivative sẵn sàng.

**Alternatives considered**: Chỉ phát bản gốc khiến ALAC/browser không ổn định; chỉ nhận AAC âm thầm thu hẹp yêu cầu. Transcoding thêm CPU và storage nhưng phù hợp giới hạn tệp/quy mô này.

**Sources**: [ffprobe](https://ffmpeg.org/ffprobe.html), [ffmpeg](https://ffmpeg.org/ffmpeg.html), [Audio codec guide](https://developer.mozilla.org/en-US/docs/Web/Media/Guides/Formats/Audio_codecs). Timeout/concurrency/bitrate là defaults thiết kế, phải benchmark thực tế.

## 5. Persistent player và UI

**Decision**: Một HTMLAudioElement trong layout có stable id + data-turbo-permanent; Stimulus quản lý state và lựa chọn bài. Tất cả trang cùng shell, không replace player khi Turbo navigation. Event listeners không nhân đôi sau reconnect. Play user-initiated, capture rejected play promises; loading/error/retry, native progress và keyboard controls. Logout dừng private preview. Volume iOS dùng volume hệ thống khi browser không cho chỉnh programmatically; UI thông báo thay vì giả thành công.

**Rationale**: Không cần SPA, giữ audio node qua page visits. Share dùng clipboard HTTPS và fallback text field.

**Alternatives considered**: Full page reload reset audio; SPA tăng scope; iframe riêng làm auth/state phức tạp.

**Source**: [Turbo permanent elements](https://turbo.hotwired.dev/handbook/building#persisting-elements-across-page-loads). Browser behavior phải xác minh thật, không chỉ DOM assertion.

## 6. Operational dependencies và kiểm chứng

**Decision**: Single-host volume backup, PostgreSQL backup, Solid Queue worker cho audio/mail; FFmpeg trong runtime image; SMTP configurable không chọn nhà cung cấp lúc này. Bảo vệ route `/jobs` hiện có chỉ admin. Test theo FR bằng Minitest và browser; SC-010 phải load test chứ không giả đạt qua capacity estimate.

**Rationale**: Repo production hiện Disk, mail host example.com, chưa bật HTTPS; Procfile.dev chỉ build assets nên chạy Rails và worker ở terminal riêng. Các cấu hình thiếu này phải được bổ sung khi implement trước release.

**Alternatives considered**: Hosted music platform, object storage/CDN, third-party search không cần cho 1.000 bài. Query SQL parameterized ILIKE escaped wildcard, pagination 25 rows; query lọc theo public pointer trước.

**Sources**: Repo `Gemfile.lock`, `config/storage.yml`, `config/environments/production.rb`, `Procfile.dev`, `docker-compose.yml`; [Action Mailer](https://guides.rubyonrails.org/action_mailer_basics.html).

## Resolved Unknowns

Auth/verification, private media/Range, codec normalization, schema lifecycle/concurrency, persistent player và setup/run strategy đều đã quyết định. Cấu hình SMTP/domain/volume cụ thể cần giá trị môi trường trước production; không có NEEDS CLARIFICATION chưa giải quyết.

## 7. Dry-rails architecture — user directive 2026-10-04

**Decision**: Adopt dry-rails for Rails integration/container/reloading and Deps injection; dry-validation ApplicationContract for use-case inputs; dry-monads Result for operations. Rails controllers/jobs delegate to stateless operations with explicit actor/input; keep Active Record/PostgreSQL, Slim/Phlex/Hotwire. Component grouping and application boundaries are project design choices, not folders imposed by the library.

**Rationale**: User explicitly selected dry-rails. Documentation describes configurable component directories, application-namespaced Container/Deps and optional features. Separate input validation and workflow from persistence without migrating framework/ORM.

**Alternatives considered**: Plain Rails services superseded by user directive. ROM/Hanami not required by dry-rails. Dry transaction/matcher are legacy per getting-started; use Result without matcher DSL. Dry Operation is optional after compatibility check, not assumed provided by dry-rails.

**Compatibility evidence/limit**: v0.7 docs label pre-1.0 beta and installation example still says ~>0.3. These pages do not demonstrate Rails 8.1/Ruby 3.4 compatibility. No gem install, dependency resolution or runtime smoke test performed in this documentation phase. Next implementation gate: select released dry-rails/dependency versions with Bundler, inspect resolved gemspec, boot dev/test/prod eager-load and workers, verify reload/injection, then commit lockfile. Do not copy old sample constraint or silently downgrade Rails. Attempts to fetch upstream gemspec via raw GitHub were unavailable; no version claim is inferred from those failed fetches.

**Sources read**: [Dry overview](https://hanakai.org/dry), [dry-rails v0.7](https://hanakai.org/learn/dry/dry-rails/v0.7), [Getting started](https://hanakai.org/learn/dry/getting-started). Technical details kept in plan/research rather than functional requirements.
