# Feature Specification: Trang nghe và chia sẻ nhạc đơn giản

**Feature Branch**: `main` (nhánh hiện tại; không có hook tạo nhánh)

**Created**: 2026-10-04

**Status**: Clarified — đã hoàn tất 5 câu hỏi, sẵn sàng lập kế hoạch

**Input**: User description: "Tôi muốn xây trang nghe nhạc và chia sẻ nhạc đơn giản, bạn hãy giúp tôi khám phá các chức năng của nó trước"

## Clarifications

### Session 2026-10-04

- Q: Bản đầu có cần lưu bài yêu thích và tạo playlist cá nhân để chia sẻ không? → A: Không. Bản đầu chỉ nghe và chia sẻ từng bài; yêu thích và playlist làm sau.
- Q: Người dùng được sửa bài đã duyệt theo cách nào? → A: Cho sửa và duyệt lại; giữ bản cũ công khai đến khi bản sửa được duyệt, giữ nguyên liên kết chia sẻ.
- Q: Bản đầu sẽ phục vụ bao nhiêu người nghe cùng lúc và chứa khoảng bao nhiêu bài nhạc? → A: 20 người nghe cùng lúc, 1.000 bài nhạc.
- Q: Bản đầu cần nhận những định dạng nhạc nào và giới hạn dung lượng mỗi tệp bao nhiêu? → A: MP3 và M4A, tối đa 30 MB mỗi tệp, áp dụng cho bài mới và bản sửa.
- Q: Ai được tạo tài khoản và tải nhạc lên trong bản đầu? → A: Đăng ký tự do; xác minh email trước khi tải nhạc.

- Chỉ định bổ sung từ người dùng (2026-10-04): sử dụng dry-rails cho kiến trúc; quyết định kỹ thuật và nguồn tham khảo được ghi tại [plan.md](plan.md) và [research.md](research.md).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Tìm và nghe nhạc (Priority: P1)

Khách truy cập xem danh sách nhạc, tìm bài theo tên hoặc nghệ sĩ và chủ động bắt đầu nghe.

**Why this priority**: Nghe được một bài là giá trị cốt lõi của trang.

**Independent Test**: Với một bài có nguồn phát hợp lệ, khách tìm bài và nghe mà không cần tài khoản.

**Acceptance Scenarios**:

1. **Given** có các bài khả dụng, **When** khách mở trang, **Then** thấy tên bài, nghệ sĩ và hành động nghe của từng bài.
2. **Given** có bài phù hợp, **When** khách tìm theo một phần tên bài hoặc nghệ sĩ, **Then** thấy các kết quả phù hợp; truy vấn không phân biệt chữ hoa/chữ thường và bỏ khoảng trắng đầu/cuối.
3. **Given** bài đang phát, **When** người nghe tạm dừng, tiếp tục, tua hoặc chỉnh âm lượng, **Then** thao tác được áp dụng và trạng thái phát phản ánh kết quả.
4. **Given** một bài đang phát, **When** khách chọn bài khác, **Then** bài trước dừng và chỉ một bài được phát.
5. **Given** trang vừa mở, **When** khách chưa chọn nghe, **Then** âm thanh không tự phát.

---

### User Story 2 - Chia sẻ một bài nhạc (Priority: P1)

Người nghe lấy liên kết của một bài và gửi cho bạn bè bằng công cụ họ đang dùng. Người nhận mở đúng bài và chủ động nghe.

**Why this priority**: Chia sẻ là mục tiêu thứ hai được người dùng yêu cầu trực tiếp.

**Independent Test**: Mở liên kết bài trong một phiên truy cập khác và kiểm tra đúng tên bài, nghệ sĩ và hành động nghe.

**Acceptance Scenarios**:

1. **Given** bài khả dụng, **When** người nghe chọn chia sẻ, **Then** nhận liên kết riêng của bài và thông báo sao chép thành công hoặc cách sao chép thủ công khi thao tác thất bại.
2. **Given** liên kết hợp lệ, **When** người nhận mở mà chưa đăng nhập, **Then** thấy đúng bài và có thể chọn nghe.
3. **Given** bài đã bị gỡ hoặc liên kết không tồn tại, **When** mở liên kết, **Then** thấy thông báo không khả dụng và đường quay lại danh sách nhạc.

---

### User Story 3 - Tải nhạc và theo dõi duyệt (Priority: P1)

Người dùng đăng ký tự do, xác minh email, đăng nhập và tải tệp nhạc, điền tên bài và nghệ sĩ, xác nhận mình có quyền chia sẻ, rồi gửi admin duyệt.

**Why this priority**: Cung cấp nội dung cho trang theo lựa chọn của chủ sản phẩm.

**Independent Test**: Tài khoản tải một tệp hợp lệ, gửi duyệt và thấy bài trong danh sách của mình ở trạng thái chờ duyệt, chưa công khai.

**Acceptance Scenarios**:

1. **Given** chưa đăng nhập, **When** chọn tải nhạc, **Then** được yêu cầu đăng nhập; tài khoản mới có thể đăng ký và người quên mật khẩu có thể khôi phục truy cập.
2. **Given** đã đăng nhập và xác minh email, **When** gửi tệp MP3 hoặc M4A tối đa 30 MB với tên bài, nghệ sĩ và xác nhận quyền chia sẻ, **Then** bài ở trạng thái chờ duyệt, chỉ chủ bài và admin được xem/nghe.
3. **Given** tệp không phải MP3/M4A, vượt 30 MB, không đọc được âm thanh hoặc thiếu thông tin bắt buộc, **When** gửi, **Then** thấy lỗi cụ thể và bài không được gửi duyệt.
4. **Given** bài bị từ chối, **When** chủ bài xem danh sách của mình, **Then** thấy lý do; có thể sửa thông tin hoặc thay tệp và gửi lại thành chờ duyệt.
5. **Given** bài thuộc tài khoản khác, **When** người dùng cố sửa, xóa hoặc mở bài chưa công khai, **Then** bị từ chối truy cập.
6. **Given** bài thuộc mình, **When** xóa bài, **Then** bài không còn khả dụng trong danh sách, hàng duyệt và liên kết chia sẻ.
7. **Given** bài đã được duyệt, **When** chủ bài sửa thông tin hoặc thay tệp và gửi duyệt lại, **Then** bản sửa chỉ chủ bài và admin được xem/nghe; khách vẫn nghe bản đã duyệt qua cùng liên kết.
8. **Given** bản sửa bị từ chối, **When** chủ bài xem trạng thái, **Then** thấy lý do và có thể sửa/gửi lại; bản công khai vẫn giữ nguyên.
9. **Given** tài khoản chưa xác minh email, **When** tải bài mới hoặc bản sửa, **Then** bị yêu cầu xác minh email trước và có thể yêu cầu gửi lại thư xác minh.
10. **Given** liên kết xác minh hợp lệ, **When** người dùng mở liên kết, **Then** email được đánh dấu đã xác minh và tài khoản có thể tải nhạc; liên kết hết hạn hoặc không hợp lệ không xác minh tài khoản và cho yêu cầu thư mới.

---

### User Story 4 - Admin duyệt và gỡ nhạc (Priority: P1)

Admin xem hàng chờ, nghe thử, kiểm tra thông tin rồi duyệt hoặc từ chối với lý do.

**Why this priority**: Chỉ nội dung đã qua duyệt được công khai.

**Independent Test**: Với hai bài chờ duyệt, duyệt một và từ chối một; chỉ bài được duyệt xuất hiện với khách.

**Acceptance Scenarios**:

1. **Given** admin đăng nhập, **When** mở hàng chờ, **Then** thấy thông tin bài, người đăng và khả năng nghe thử.
2. **Given** bài chờ duyệt, **When** admin duyệt, **Then** bài công khai trong danh sách, tìm kiếm và liên kết chia sẻ.
3. **Given** bài chờ duyệt, **When** admin từ chối, **Then** phải nhập lý do; bài không công khai và chủ bài thấy lý do.
4. **Given** bài công khai, **When** admin gỡ kèm lý do, **Then** bài không còn cho khách nghe và chủ bài thấy trạng thái bị gỡ cùng lý do.
5. **Given** người dùng thường, **When** truy cập thao tác duyệt hoặc gỡ của admin, **Then** bị từ chối.
6. **Given** bài đã được admin khác xử lý, **When** admin thao tác từ danh sách cũ, **Then** thấy trạng thái hiện tại và không ghi đè quyết định cũ.
7. **Given** bản sửa đang chờ duyệt, **When** admin duyệt, **Then** bản sửa thay thế bản công khai và liên kết bài không đổi; nếu từ chối thì bản công khai không đổi.

---

### Edge Cases

- Không có bài hoặc tìm không có kết quả: hiển thị trạng thái trống và cách quay lại toàn bộ danh sách.
- Tệp đúng 30.000.000 byte được nhận nếu hợp lệ; vượt một byte thì bị từ chối. Tệp rỗng hoặc đổi đuôi thành MP3/M4A nhưng không có âm thanh hợp lệ bị từ chối.
- Đăng ký email đã tồn tại, không phân biệt chữ hoa/thường: không tạo tài khoản trùng; hướng dẫn đăng nhập hoặc khôi phục truy cập.
- Thư xác minh chưa đến: cho yêu cầu gửi lại; gửi thư thất bại không được đánh dấu email đã xác minh.
- Tải tệp bị gián đoạn: cho tải lại, không tạo bài chờ duyệt khi tệp chưa hoàn tất.
- Nguồn phát lỗi hoặc mất kết nối: thông báo lỗi, cho thử lại và chọn bài khác; không hiển thị trạng thái đang phát thành công.
- Bài bị gỡ: liên kết không còn cho nghe, không điều hướng sang một bài khác như thể đó là bài được chia sẻ.
- Sao chép liên kết bị từ chối: cho người dùng chọn và sao chép liên kết thủ công.
- Mỗi bài chỉ có tối đa một bản sửa đang chờ duyệt. Trong lúc chờ, chủ bài không thể sửa tiếp hoặc gửi bản khác; sau quyết định duyệt/từ chối có thể chỉnh sửa tiếp.
- Xóa hoặc gỡ bài có bản sửa đang chờ: bản sửa cũng mất hiệu lực và không thể được duyệt để công khai lại bài.
- Tên bài trùng nhau: liên kết vẫn phân biệt từng bài.
- Người dùng đổi trang trong cùng phiên: việc duyệt danh sách và mở chi tiết không làm mất bài đang nghe.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Trang MUST cho khách xem bài khả dụng với tên bài, nghệ sĩ và hành động nghe (Story 1.1).
- **FR-002**: Trang MUST tìm theo một phần tên bài hoặc nghệ sĩ, không phân biệt chữ hoa/chữ thường, bỏ khoảng trắng đầu/cuối và báo khi không có kết quả (Story 1.2; Edge Cases).
- **FR-003**: Trải nghiệm nghe MUST có phát, tạm dừng, tiếp tục, tua, âm lượng, tiến độ và thời lượng. Nhạc được nghe trực tiếp trên trang (Story 1.3).
- **FR-004**: Trang MUST chỉ phát một bài tại một thời điểm, không tự phát lúc mở trang và duy trì bài đang phát khi duyệt nội dung trong cùng phiên (Story 1.4–1.5; Edge Cases).
- **FR-005**: Mỗi bài MUST có liên kết riêng, cho sao chép và báo kết quả hoặc cung cấp cách sao chép thủ công (Story 2.1).
- **FR-006**: Liên kết chia sẻ MUST mở đúng bài, cho khách chưa đăng nhập chọn nghe, và báo không khả dụng nếu bài bị gỡ hoặc không tồn tại (Story 2.2–2.3).
- **FR-007**: Khi phát thất bại, trang MUST báo lỗi và cho thử lại hoặc chọn bài khác (Edge Cases).
- **FR-008**: Người dùng đã đăng nhập và xác minh email MUST có thể gửi tệp MP3 hoặc M4A tối đa 30 MB, tên bài, nghệ sĩ và xác nhận quyền chia sẻ để admin duyệt; áp dụng cùng giới hạn cho bản sửa; kiểm tra nội dung âm thanh thực tế, không chỉ tên/đuôi tệp, và từ chối tệp không đọc được hoặc đầu vào không hợp lệ với lý do (Story 3.1–3.3, 3.7).
- **FR-010**: Trang MUST có đăng ký tự do bằng email và mật khẩu, đăng nhập, đăng xuất, khôi phục mật khẩu và xác minh email trước khi tải bài mới/bản sửa; phải có gửi lại thư xác minh và xử lý liên kết không hợp lệ/hết hạn; chỉ admin được duyệt/gỡ và chỉ chủ bài hoặc admin được truy cập bài hoặc bản sửa chưa công khai (Story 3.1, 3.5, 3.9–3.10; Story 4.5).
- **FR-011**: Bài mới MUST ở trạng thái chờ duyệt; chỉ bản đã được duyệt hiện trong danh sách công khai, tìm kiếm và liên kết nghe dành cho khách (Story 3.2; Story 4.2).
- **FR-012**: Admin MUST xem hàng chờ, nghe thử, duyệt hoặc từ chối với lý do bắt buộc; quyết định trên trạng thái cũ không được ghi đè quyết định đã xử lý (Story 4.1–4.3, 4.6).
- **FR-013**: Chủ bài MUST xem trạng thái và lý do từ chối, sửa hoặc thay tệp của bài bị từ chối và gửi lại để duyệt; bài đã công khai được sửa thông tin hoặc thay tệp để duyệt lại, giữ bản công khai cũ và liên kết cho đến khi bản sửa được duyệt; bản sửa bị từ chối không thay đổi bản công khai (Story 3.4, 3.7–3.8; Story 4.7).
- **FR-014**: Chủ bài MUST có thể xóa bài của mình; admin MUST có thể gỡ bài công khai với lý do; bài bị xóa/gỡ không còn khả dụng qua liên kết cũ (Story 3.6; Story 4.4).

### Key Entities *(include if feature involves data)*

- **Bài nhạc**: Một bài có định danh riêng, tên, nghệ sĩ, nguồn nghe và trạng thái khả dụng; ảnh bìa là tùy chọn.
- **Phiên bản bài nhạc**: Thông tin và tệp của một lần gửi duyệt, người gửi, thời điểm và trạng thái duyệt. Bài có tối đa một bản công khai và một bản sửa đang chờ; duyệt bản sửa thay bản công khai, từ chối giữ bản công khai cũ.
- **Liên kết chia sẻ**: Địa chỉ trỏ đến đúng một bài, giữ nguyên định danh khi tên bài thay đổi.
- **Tài khoản**: Người đăng nhạc hoặc admin, email duy nhất không phân biệt chữ hoa/thường và trạng thái xác minh email; quyền admin chỉ do chủ trang chỉ định.
- **Người đăng**: Tài khoản sở hữu bài, được gửi duyệt và xem trạng thái bài của mình.
- **Quyết định duyệt**: Admin xử lý, phiên bản được xét duyệt, thời điểm, kết quả và lý do từ chối/gỡ. Trạng thái bài gồm chờ duyệt, được duyệt, bị từ chối và bị gỡ.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-011**: Trong kiểm tra đăng ký và tải nhạc, tất cả tài khoản chưa xác minh bị chặn tải bài mới/bản sửa; tài khoản xác minh thành công được tải và liên kết xác minh không hợp lệ/hết hạn không mở quyền tải.
- **SC-010**: Với kho 1.000 bài công khai và 20 người nghe đồng thời, ít nhất 95% lượt chọn nghe bắt đầu phát trong 3 giây, đo trên kết nối ổn định tối thiểu 10 Mbps mỗi người, độ trễ tối đa 100 ms; mỗi người nghe một bài ít nhất 5 phút, không có lượt phát thất bại do quá tải trong phép thử này.

- **SC-001**: Ít nhất 9/10 người thử lần đầu tìm một bài được chỉ định và bắt đầu nghe trong 60 giây, không cần hướng dẫn; dùng danh sách ít nhất 20 bài.
- **SC-002**: Ít nhất 9/10 người thử lấy liên kết chia sẻ trong 15 giây từ trang bài hát.
- **SC-003**: Với 10 liên kết bài còn khả dụng, cả 10 đều mở đúng bài trong phiên chưa đăng nhập và cho phép chủ động nghe.
- **SC-004**: Với 5 liên kết bài đã gỡ và 5 liên kết không tồn tại, cả 10 đều báo rõ không khả dụng và có đường quay lại danh sách.
- **SC-005**: Ít nhất 8/10 người thử đánh giá trải nghiệm tìm, nghe và chia sẻ là dễ sử dụng (4 hoặc 5 trên thang 5), trên điện thoại hoặc máy tính.
- **SC-007**: Trong bộ kiểm tra gồm 5 bài chờ duyệt, 5 bài bị từ chối và 5 bài được duyệt, chỉ 5 bài được duyệt có thể nghe qua phiên khách.
- **SC-009**: Với một bản sửa được duyệt và một bản sửa bị từ chối, kiểm tra trước và sau quyết định đều giữ cùng liên kết; trước quyết định khách chỉ nghe bản cũ, sau quyết định chỉ trường hợp được duyệt phát bản mới.
- **SC-008**: Ít nhất 9/10 người thử gửi một tệp hợp lệ để duyệt trong 3 phút, không tính thời gian truyền tệp; admin xử lý từng bài trong 60 giây sau khi nghe thử.

## Assumptions

- Quy mô mục tiêu bản đầu được xác nhận: tối đa 20 người nghe đồng thời và kho 1.000 bài công khai; đây là quy mô nghiệm thu, không phải hạn mức cứng cho người dùng.

- Người dùng đã xác nhận: người dùng tải nhạc lên, admin duyệt. Bản đầu gồm các luồng P1: tìm/nghe, chia sẻ từng bài, tải nhạc và admin duyệt/gỡ.
- Đăng ký tự do bằng email/mật khẩu; phải xác minh email trước khi tải bài mới hoặc bản sửa. Phụ thuộc khả năng gửi thư xác minh và khôi phục mật khẩu.
- Khách được nghe và mở liên kết chia sẻ mà không đăng nhập; tài khoản bắt buộc khi đăng nhạc hoặc duyệt nhạc.
- Giao diện sử dụng được trên điện thoại và máy tính; ngôn ngữ mặc định dự kiến là tiếng Việt.
- Chia sẻ trong bản đầu là lấy liên kết; người dùng tự gửi qua ứng dụng họ chọn.
- Nhạc được người dùng tải lên và nghe trực tiếp trên trang sau khi duyệt. Người đăng xác nhận quyền chia sẻ; admin có thể từ chối/gỡ nội dung.
- Định dạng được xác nhận cho bản đầu: MP3 và M4A tối đa 30 MB mỗi tệp (30.000.000 byte, bao gồm đúng giới hạn); bài mới và bản sửa đều cần duyệt trước khi công khai. Bản đã duyệt vẫn công khai trong lúc bản sửa chờ duyệt.
- Admin được chủ trang chỉ định, không có đăng ký tự nhận vai trò admin. Bài bị gỡ không được tự gửi duyệt lại trong bản đầu.
- Dữ liệu hiện tại của dự án là nội dung mẫu, chưa chứng minh có nguồn phát thật.
- Yêu thích, thư viện cá nhân, playlist cá nhân và chia sẻ playlist được người dùng xác nhận để giai đoạn sau; không thuộc yêu cầu hoặc tiêu chí nghiệm thu bản đầu.
- Bình luận, theo dõi nghệ sĩ, bảng xếp hạng, gợi ý cá nhân hóa, tải về/nghe ngoại tuyến, thu phí và ứng dụng di động riêng nằm ngoài phạm vi bản đầu.
- Constitution hiện chỉ là mẫu chưa điền, chưa có nguyên tắc dự án được xác lập.
