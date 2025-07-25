<%-- 
    Document   : home
    Created on : May 15, 2025
    Author     : ADMIN
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Smart Pitch System</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="./css/home.css"/>

        <style>
            #chat-button {
                position: fixed;
                bottom: 20px;
                right: 20px;
                width: 60px;
                height: 60px;
                border-radius: 50%;
                background: linear-gradient(135deg, #007bff, #00c6ff);
                color: #fff;
                border: none;
                font-size: 28px;
                cursor: pointer;
                z-index: 1000;
                box-shadow: 0 6px 16px rgba(0, 0, 0, 0.3);
                display: flex;
                align-items: center;
                justify-content: center;
                transition: background 0.3s ease;
            }

            #chat-button:hover {
                background: linear-gradient(135deg, #0056b3, #0096c7);
            }

            #chat-box {
                position: fixed;
                bottom: 90px;
                right: 20px;
                width: 360px;
                height: 500px;
                background-color: #fff;
                border-radius: 16px;
                display: none;
                flex-direction: column;
                z-index: 1000;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
                overflow: hidden;
                font-family: 'Roboto', sans-serif;
            }

            #chat-messages {
                flex: 1;
                padding: 15px;
                overflow-y: auto;
                background: #f9f9f9;
                font-size: 14px;
            }

            .user-message, .bot-message {
                max-width: 80%;
                padding: 10px 14px;
                border-radius: 18px;
                margin-bottom: 8px;
                line-height: 1.4;
                word-wrap: break-word;
            }

            .user-message {
                background: #dcf8c6;
                align-self: flex-end;
                margin-left: auto;
                text-align: right;
            }

            .bot-message {
                background: #e2e3e5;
                align-self: flex-start;
                margin-right: auto;
                text-align: left;
            }

            #chat-input {
                display: flex;
                border-top: 1px solid #ddd;
                background: #fff;
                padding: 8px;
            }

            #chat-input input {
                flex: 1;
                border: 1px solid #ccc;
                border-radius: 20px;
                padding: 8px 14px;
                outline: none;
                font-size: 14px;
            }

            #chat-input button {
                background: #007bff;
                color: white;
                border: none;
                border-radius: 20px;
                padding: 8px 16px;
                margin-left: 8px;
                cursor: pointer;
                transition: background 0.3s ease;
            }

            #chat-input button:hover {
                background: #0056b3;
            }
            /* === CSS MỚI CHO NÚT CHAT VỚI NHÂN VIÊN === */
            #human-chat-link {
                position: fixed;
                bottom: 95px; /* Đặt ngay trên nút chatbot cũ */
                right: 20px;
                background: linear-gradient(135deg, #28a745, #28b485); /* Màu xanh lá cây để phân biệt */
                color: #fff;
                padding: 12px 18px;
                border-radius: 25px;
                text-decoration: none;
                font-weight: bold;
                font-size: 14px;
                z-index: 1000;
                box-shadow: 0 6px 16px rgba(0, 0, 0, 0.3);
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
            }

            #human-chat-link:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.35);
            }

            #human-chat-link i {
                margin-right: 8px; /* Thêm khoảng cách cho icon */
            }
        </style>
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
        <%-- Nếu đã đăng nhập, dẫn đến trang chat.jsp --%>
        <a href="${pageContext.request.contextPath}/chat.jsp" id="human-chat-link">
            <i class="fas fa-headset"></i>
            <span>Chat với nhân viên</span>
        </a>
        <% } else { %>
        <%-- Nếu chưa đăng nhập, dẫn đến trang login.jsp --%>
        <a href="${pageContext.request.contextPath}/account/login.jsp" id="human-chat-link">
            <i class="fas fa-sign-in-alt"></i>
            <span>Đăng nhập để Chat</span>
        </a>
        <% } %>
        <!-- Chatbot button -->
        <button id="chat-button">💬</button>

        <!-- Chatbot box -->
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

                // thêm tin nhắn người dùng
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

        </script>
    </body>
</html>
