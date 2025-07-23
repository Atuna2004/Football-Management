<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/account/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Hệ thống Chat</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                font-family: sans-serif;
                display: flex;
                height: 100vh;
                margin: 0;
            }
            .sidebar {
                width: 30%;
                border-right: 1px solid #ccc;
                overflow-y: auto;
                background-color: #f8f9fa;
            }
            .user-list-item {
                padding: 15px;
                cursor: pointer;
                border-bottom: 1px solid #eee;
                transition: background-color 0.2s;
            }
            .user-list-item:hover {
                background-color: #e9ecef;
            }
            .user-list-item.active {
                background-color: #007bff;
                color: white;
            }
            .chat-area {
                width: 70%;
                display: flex;
                flex-direction: column;
            }
            .chat-container {
                width: 100%;
                height: 100%;
                display: flex;
                flex-direction: column;
            }
            .chat-header {
                padding: 15px;
                background-color: #f7f7f7;
                border-bottom: 1px solid #ccc;
                font-weight: bold;
            }
            .chat-messages {
                flex-grow: 1;
                padding: 15px;
                overflow-y: auto;
                display: flex;
                flex-direction: column;
            }
            .message {
                padding: 10px 15px;
                border-radius: 18px;
                max-width: 70%;
                margin-bottom: 10px;
                word-wrap: break-word;
            }
            .message.sent {
                background-color: #007bff;
                color: white;
                align-self: flex-end;
                border-bottom-right-radius: 4px;
            }
            .message.received {
                background-color: #e9e9eb;
                color: #333;
                align-self: flex-start;
                border-bottom-left-radius: 4px;
            }
            .chat-form {
                display: flex;
                padding: 10px;
                border-top: 1px solid #ccc;
                background-color: #fff;
            }
            #message-input {
                flex-grow: 1;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 20px;
                outline: none;
            }
            #send-button {
                padding: 10px 20px;
                border: none;
                background-color: #007bff;
                color: white;
                border-radius: 20px;
                cursor: pointer;
                margin-left: 10px;
            }
        </style>
    </head>

    <body>
        <div class="sidebar">
            <div class="user-list" id="user-list"></div>
        </div>
        <div class="chat-area">
            <div class="chat-container" id="chat-container" style="display: none;">
                <div class="chat-header" id="chat-header"></div>
                <div class="chat-messages" id="chat-messages"></div>
                <form class="chat-form" id="chat-form">
                    <input type="text" id="message-input" placeholder="Chọn một người để chat..." autocomplete="off" disabled>
                    <button type="submit" id="send-button" disabled>Gửi</button>
                </form>
            </div>
            <div id="welcome-message" style="margin: auto; color: #888;">Vui lòng chọn một người để bắt đầu cuộc trò chuyện.</div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Chuyển tất cả các biến vào trong DOMContentLoaded để đảm bảo thứ tự
                const currentUserId = "<%= currentUser.getUserID() %>";
                const contextPath = "<%= request.getContextPath() %>";

                console.log("DEBUG: UserID from JSP:", currentUserId);
                console.log("DEBUG: ContextPath from JSP:", contextPath);

                let recipientId = null;
                let socket = null;

                const userListDiv = document.getElementById('user-list');
                const chatContainer = document.getElementById('chat-container');
                const chatHeader = document.getElementById('chat-header');
                const chatMessages = document.getElementById('chat-messages');
                const chatForm = document.getElementById('chat-form');
                const messageInput = document.getElementById('message-input');
                const welcomeMessage = document.getElementById('welcome-message');
                const sendButton = document.getElementById('send-button');

                function loadChatableUsers() {
                    // Kiểm tra contextPath trước khi gọi fetch
                    if (!contextPath || contextPath.trim() === "") {
                        console.error("Context Path rỗng! Không thể tải danh sách người dùng. Vui lòng kiểm tra lại cấu hình server.");
                        userListDiv.innerHTML = '<p style="padding: 15px; color: red;">Lỗi cấu hình: Không thể tải danh sách người dùng.</p>';
                        return;
                    }

                    fetch(`${contextPath}/api/chatusers`)
                            .then(response => response.ok ? response.json() : Promise.reject('Network response was not ok'))
                            .then(users => {
                                userListDiv.innerHTML = '';
                                users.forEach(user => {
                                    const userItem = document.createElement('div');
                                    userItem.className = 'user-list-item';
                                    userItem.dataset.userid = user.userID;
                                    userItem.dataset.username = user.fullName;
                                    userItem.textContent = user.fullName;
                                    userListDiv.appendChild(userItem);
                                });
                            })
                            .catch(error => {
                                console.error('Lỗi khi tải danh sách người dùng:', error);
                                userListDiv.innerHTML = '<p style="padding: 15px; color: red;">Không thể tải danh sách người dùng.</p>';
                            });
                }

                function connectWebSocket() {
                    if (socket && socket.readyState !== WebSocket.CLOSED) {
                        socket.close();
                    }

                    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
                    const host = window.location.host;
                    const wsUrl = `${protocol}//${host}${contextPath}/ws/chat/${currentUserId}`;

                                console.log("Đang kết nối tới WebSocket URL:", wsUrl);
                                socket = new WebSocket(wsUrl);

                                socket.onopen = () => console.log("WebSocket đã kết nối thành công.");
                                socket.onerror = (event) => console.error("Lỗi kết nối WebSocket:", event);

                                socket.onmessage = (event) => {
                                    const data = JSON.parse(event.data);
                                    if (String(data.fromUserId) === String(recipientId)) {
                                        displayMessage(data.content, 'received');
                                    }
                                };
                            }

                            function displayMessage(text, type) {
                                const msgDiv = document.createElement('div');
                                msgDiv.className = `message ${type}`;
                                msgDiv.textContent = text;
                                chatMessages.appendChild(msgDiv);
                                chatMessages.scrollTop = chatMessages.scrollHeight;
                            }

                            userListDiv.addEventListener('click', function (e) {
                                const target = e.target.closest('.user-list-item');
                                if (target) {
                                    document.querySelectorAll('.user-list-item').forEach(item => item.classList.remove('active'));
                                    target.classList.add('active');

                                    recipientId = target.dataset.userid;
                                    const recipientName = target.dataset.username;

                                    chatContainer.style.display = 'flex';
                                    welcomeMessage.style.display = 'none';
                                    chatHeader.textContent = `Chat với ${recipientName}`;
                                    chatMessages.innerHTML = '';

                                    messageInput.disabled = false;
                                    sendButton.disabled = false;
                                    messageInput.placeholder = `Nhập tin nhắn tới ${recipientName}...`;
                                    messageInput.focus();

                                    fetch(`${contextPath}/api/chat-history?withUserId=${recipientId}`)
                                                            .then(response => response.ok ? response.json() : Promise.reject('Failed to load history'))
                                                            .then(history => {
                                                                history.forEach(msg => {
                                                                    const type = String(msg.senderId) === currentUserId ? 'sent' : 'received';
                                                                    displayMessage(msg.content, type);
                                                                });
                                                            });
                                                }
                                            });

                                            chatForm.addEventListener('submit', function (e) {
                                                e.preventDefault();
                                                const content = messageInput.value.trim();
                                                if (content && recipientId && socket && socket.readyState === WebSocket.OPEN) {
                                                    const message = {toUserId: recipientId, content: content};
                                                    socket.send(JSON.stringify(message));
                                                    displayMessage(content, 'sent');
                                                    messageInput.value = '';
                                                }
                                            });

                                            loadChatableUsers();
                                            connectWebSocket();
                                        });
        </script>
    </body>
</html>