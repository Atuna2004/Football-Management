<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Smart Pitch System</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    </head>
    <body>
        <%@ include file="/includes/header.jsp" %>
        <main>
            <div class="box">
                <div class="bg-home">
                    <img src="./images/bg-home.jpg" alt="background home" class="img-fluid w-100"/>
                </div>
            </div>      

            <div class="container my-5">
                <div class="row text-center">
                    <div class="col-md-4 mb-4">
                        <img src="./images/sub-intro1.png" alt="Tìm kiếm sân" class="img-fluid mb-2"/>
                        <h3>Tìm kiếm vị trí sân</h3>
                        <p>Dữ liệu sân đấu dồi dào, liên tục cập nhật, giúp bạn dễ dàng tìm kiếm theo khu vực mong muốn.</p>
                    </div>
                    <div class="col-md-4 mb-4">
                        <img src="./images/sub-intro2.png" alt="Đặt lịch" class="img-fluid mb-2"/>
                        <h3>Đặt lịch online</h3>
                        <p>Không cần đến trực tiếp hay gọi điện, bạn có thể đặt sân bất kỳ đâu có internet.</p>
                    </div>
                    <div class="col-md-4 mb-4">
                        <img src="./images/sub-intro3.png" alt="Tìm đối" class="img-fluid mb-2"/>
                        <h3>Tìm đối, bắt cặp đấu</h3>
                        <p>Kết nối và giao lưu với cộng đồng bóng đá để xây dựng những trận cầu sôi động.</p>
                    </div>
                </div>
            </div>
        </main>
        <%@ include file="/includes/footer.jsp" %>
        <% if (currentUser != null) { %>

        <a href="${pageContext.request.contextPath}/chat.jsp" id="human-chat-link">
            <i class="fas fa-headset"></i>
            <span>Chat với nhân viên</span>
        </a>
        <% } else { %>

        <a href="${pageContext.request.contextPath}/account/login.jsp" id="human-chat-link">
            <i class="fas fa-sign-in-alt"></i>
            <span>Đăng nhập để Chat</span>
        </a>
        <% } %>

        <button id="chat-button">💬</button>


        <div id="chat-box">
            <div id="chat-messages"></div>
            <div id="chat-input">
                <input type="text" id="user-message" placeholder="Nhập tin nhắn...">
                <button id="send">Gửi</button>
            </div>
        </div>

        <script>
            const chatButton = document.getElementById("chat-button");
            const chatBox = document.getElementById("chat-box");
            const messages = document.getElementById("chat-messages");
            const input = document.getElementById("user-message");
            const sendBtn = document.getElementById("send");

            let greeted = false;

            chatButton.addEventListener("click", () => {
                const isOpen = chatBox.style.display === "flex";
                chatBox.style.display = isOpen ? "none" : "flex";
                chatBox.style.flexDirection = "column";

                if (!isOpen && !greeted) {
                    const botMsg = document.createElement("div");
                    botMsg.style.textAlign = "left";
                    botMsg.style.margin = "5px";
                    botMsg.innerHTML = "<b>Bot:</b> Xin chào! Tôi là trợ lý ảo của SmartPitch. Tôi có thể hỗ trợ bạn tìm sân, đặt sân, hỏi giờ trống hoặc các chương trình khuyến mãi. Bạn cần hỗ trợ gì?";
                    messages.appendChild(botMsg);
                    messages.scrollTop = messages.scrollHeight;
                    greeted = true;
                }
            });

            input.addEventListener("keyup", e => {
                if (e.key === "Enter")
                    sendBtn.click();
            });

            sendBtn.addEventListener("click", async () => {
                const message = input.value.trim();
                if (!message)
                    return;


                const userMsg = document.createElement("div");
                userMsg.style.textAlign = "right";
                userMsg.style.margin = "5px";
                userMsg.innerHTML = "<b>Bạn:</b> " + escapeHtml(message);
                messages.appendChild(userMsg);
                messages.scrollTop = messages.scrollHeight;

                input.value = "";

                try {
                    const res = await fetch("ChatBotServlet", {
                        method: "POST",
                        headers: {"Content-Type": "application/x-www-form-urlencoded"},
                        body: "message=" + encodeURIComponent(message)
                    });
                    const data = await res.json();

                    const botMsg = document.createElement("div");
                    botMsg.style.textAlign = "left";
                    botMsg.style.margin = "5px";
                    botMsg.innerHTML = "<b>Bot:</b> " + escapeHtml(data.reply);
                    messages.appendChild(botMsg);
                    messages.scrollTop = messages.scrollHeight;

                } catch (e) {
                    const botMsg = document.createElement("div");
                    botMsg.style.textAlign = "left";
                    botMsg.style.margin = "5px";
                    botMsg.innerHTML = "<b>Bot:</b> Lỗi kết nối.";
                    messages.appendChild(botMsg);
                    messages.scrollTop = messages.scrollHeight;
                }
            });

            function escapeHtml(text) {
                const div = document.createElement("div");
                div.textContent = text;
                return div.innerHTML;
            }

            document.addEventListener('DOMContentLoaded', function() {
                const userDropdown = document.querySelector('.user-dropdown');
                const dropdownMenu = document.querySelector('.dropdown-menu');

                if (userDropdown) {
                    userDropdown.addEventListener('click', function(e) {
                        e.stopPropagation();
                        dropdownMenu.classList.toggle('show');
                    });

                    document.addEventListener('click', function(e) {
                        if (!userDropdown.contains(e.target)) {
                            dropdownMenu.classList.remove('show');
                        }
                    });
                }
            });
        </script>
    </body>
</html>
