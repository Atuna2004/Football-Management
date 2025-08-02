<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.isFieldOwner()) {
        response.sendRedirect(request.getContextPath() + "/fieldOwner/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tin Nhắn - Field Owner Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            min-height: 100vh;
        }

        /* Override sidebar positioning for chat page */
        .navigation-sidebar {
            top: 0 !important;
            height: 100vh !important;
        }

        .main-content {
            margin-left: 300px;
            min-height: 100vh;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
        }

        .chat-container {
            display: flex;
            height: 100vh;
            background: white;
            border-radius: 20px;
            margin: 20px;
            box-shadow: 0 20px 40px rgba(59, 130, 246, 0.1);
            overflow: hidden;
        }

        /* User List Sidebar */
        .user-list-sidebar {
            width: 350px;
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
            border-right: 1px solid rgba(59, 130, 246, 0.1);
            display: flex;
            flex-direction: column;
        }

        .user-list-header {
            padding: 30px 25px 20px;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            position: relative;
        }

        .user-list-header h2 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .user-list-header p {
            font-size: 14px;
            opacity: 0.9;
        }

        .search-box {
            padding: 20px 25px;
            border-bottom: 1px solid rgba(59, 130, 246, 0.1);
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 12px 16px 12px 45px;
            border: 2px solid rgba(59, 130, 246, 0.1);
            border-radius: 12px;
            font-size: 14px;
            background: rgba(59, 130, 246, 0.02);
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .search-box i {
            position: absolute;
            left: 40px;
            top: 50%;
            transform: translateY(-50%);
            color: #64748b;
            font-size: 14px;
        }

        .users-list {
            flex: 1;
            overflow-y: auto;
            padding: 10px;
        }

        .user-item {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            margin: 5px 0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid transparent;
        }

        .user-item:hover {
            background: rgba(59, 130, 246, 0.05);
            border-color: rgba(59, 130, 246, 0.1);
            transform: translateX(5px);
        }

        .user-item.active {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(59, 130, 246, 0.3);
        }

        .user-avatar {
            width: 45px;
            height: 45px;
            border-radius: 12px;
            background: linear-gradient(135deg, #64748b, #475569);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 16px;
            margin-right: 15px;
        }

        .user-item.active .user-avatar {
            background: rgba(255, 255, 255, 0.2);
        }

        .user-info {
            flex: 1;
        }

        .user-name {
            font-weight: 600;
            font-size: 15px;
            margin-bottom: 4px;
        }

        .user-role {
            font-size: 12px;
            opacity: 0.7;
            padding: 2px 8px;
            border-radius: 6px;
            background: rgba(59, 130, 246, 0.1);
            display: inline-block;
        }

        .user-item.active .user-role {
            background: rgba(255, 255, 255, 0.2);
        }

        /* Chat Area */
        .chat-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
            position: relative;
            z-index: 1;
        }

        .chat-header {
            padding: 25px 30px;
            background: white;
            border-bottom: 1px solid rgba(59, 130, 246, 0.1);
            display: flex;
            align-items: center;
            position: relative;
            z-index: 1;
        }

        .chat-user-info {
            display: flex;
            align-items: center;
            flex: 1;
        }

        .chat-user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 15px;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 18px;
            margin-right: 15px;
            position: relative;
            z-index: 1;
        }

        .chat-user-details h3 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .chat-user-details p {
            font-size: 14px;
            color: #64748b;
        }

        .chat-messages {
            flex: 1;
            padding: 20px 30px;
            overflow-y: auto;
            background: linear-gradient(180deg, #f8fafc 0%, #ffffff 100%);
            position: relative;
            z-index: 1;
        }

        .message {
            max-width: 70%;
            margin-bottom: 12px;
            display: flex;
            flex-direction: column;
        }

        .message.sent {
            margin-left: auto;
            align-items: flex-end;
        }

        .message.received {
            align-items: flex-start;
        }

        .message-bubble {
            padding: 12px 18px;
            border-radius: 18px;
            font-size: 14px;
            line-height: 1.4;
            word-wrap: break-word;
        }

        .message.sent .message-bubble {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            border-bottom-right-radius: 6px;
        }

        .message.received .message-bubble {
            background: white;
            color: #1e293b;
            border: 1px solid rgba(59, 130, 246, 0.1);
            border-bottom-left-radius: 6px;
        }

        .message-time {
            font-size: 11px;
            color: #64748b;
            margin-top: 4px;
            opacity: 0.7;
        }

        .message.sent .message-time {
            color: rgba(255, 255, 255, 0.7);
        }

        .chat-input-area {
            padding: 20px 30px;
            background: white;
            border-top: 1px solid rgba(59, 130, 246, 0.1);
        }

        .chat-input-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .chat-input {
            flex: 1;
            padding: 15px 20px;
            border: 2px solid rgba(59, 130, 246, 0.1);
            border-radius: 25px;
            font-size: 14px;
            background: rgba(59, 130, 246, 0.02);
            transition: all 0.3s ease;
            resize: none;
            min-height: 50px;
            max-height: 120px;
        }

        .chat-input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .send-button {
            width: 50px;
            height: 50px;
            border: none;
            border-radius: 50%;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            font-size: 18px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .send-button:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(59, 130, 246, 0.4);
        }

        .send-button:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        /* No Chat Selected */
        .no-chat-selected {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            flex: 1;
            color: #64748b;
        }

        .no-chat-selected i {
            font-size: 80px;
            margin-bottom: 20px;
            opacity: 0.3;
        }

        .no-chat-selected h3 {
            font-size: 24px;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .no-chat-selected p {
            font-size: 16px;
            opacity: 0.7;
        }

        /* Loading States */
        .loading {
            text-align: center;
            padding: 20px;
            color: #64748b;
        }

        .loading i {
            font-size: 24px;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* Scrollbar Styling */
        .users-list::-webkit-scrollbar,
        .chat-messages::-webkit-scrollbar {
            width: 6px;
        }

        .users-list::-webkit-scrollbar-track,
        .chat-messages::-webkit-scrollbar-track {
            background: rgba(59, 130, 246, 0.05);
        }

        .users-list::-webkit-scrollbar-thumb,
        .chat-messages::-webkit-scrollbar-thumb {
            background: rgba(59, 130, 246, 0.3);
            border-radius: 3px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
            }
            
            .chat-container {
                margin: 10px;
                border-radius: 15px;
            }
            
            .user-list-sidebar {
                width: 300px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/fieldOwner/FieldOwnerSB.jsp" />
    
    <div class="main-content">
        <div class="chat-container">
            <!-- User List Sidebar -->
            <div class="user-list-sidebar">
                <div class="user-list-header">
                    <h2><i class="fas fa-comments"></i> Tin Nhắn</h2>
                    <p>Giao tiếp với khách hàng và quản trị viên</p>
                </div>
                
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" class="search-input" id="userSearch" placeholder="Tìm kiếm người dùng...">
                </div>
                
                <div class="users-list" id="usersList">
                    <div class="loading">
                        <i class="fas fa-spinner"></i>
                        <p>Đang tải danh sách người dùng...</p>
                    </div>
                </div>
            </div>
            
            <!-- Chat Area -->
            <div class="chat-area">
                <div id="noChatSelected" class="no-chat-selected">
                    <i class="fas fa-comments"></i>
                    <h3>Chọn cuộc trò chuyện</h3>
                    <p>Chọn một người dùng để bắt đầu nhắn tin</p>
                </div>
                
                <div id="chatArea" style="display: none; flex: 1; flex-direction: column; position: relative; z-index: 1;">
                    <div class="chat-header" id="chatHeader">
                        <div class="chat-user-info">
                            <div class="chat-user-avatar" id="chatUserAvatar">A</div>
                            <div class="chat-user-details">
                                <h3 id="chatUserName">Người dùng</h3>
                                <p id="chatUserRole">Vai trò</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="chat-messages" id="chatMessages">
                        <!-- Messages will be loaded here -->
                    </div>
                    
                    <div class="chat-input-area">
                        <div class="chat-input-container">
                            <textarea class="chat-input" id="messageInput" placeholder="Nhập tin nhắn..." rows="1"></textarea>
                            <button class="send-button" id="sendButton" type="button">
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Global variables
        let currentUser = <%= currentUser.getUserID() %>;
        let selectedUserId = null;
        let socket = null;
        let users = [];

        // DOM elements
        const usersList = document.getElementById('usersList');
        const userSearch = document.getElementById('userSearch');
        const noChatSelected = document.getElementById('noChatSelected');
        const chatArea = document.getElementById('chatArea');
        const chatMessages = document.getElementById('chatMessages');
        const messageInput = document.getElementById('messageInput');
        const sendButton = document.getElementById('sendButton');
        const chatUserName = document.getElementById('chatUserName');
        const chatUserRole = document.getElementById('chatUserRole');
        const chatUserAvatar = document.getElementById('chatUserAvatar');

        // Initialize chat
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded, initializing chat...');
            console.log('Current user ID:', currentUser);
            
            loadUsers();
            initializeWebSocket();
            setupEventListeners();
        });

        // Load users from API
        function loadUsers() {
            console.log('Loading users...');
            fetch('<%= request.getContextPath() %>/api/chatusers')
                .then(response => {
                    console.log('Response status:', response.status);
                    if (!response.ok) throw new Error('Failed to load users');
                    return response.json();
                })
                .then(data => {
                    console.log('Users loaded:', data);
                    users = data;
                    displayUsers(users);
                })
                .catch(error => {
                    console.error('Error loading users:', error);
                    usersList.innerHTML = '<div class="loading"><p>Lỗi: ' + error.message + '</p></div>';
                });
        }

        // Display users in the sidebar
        function displayUsers(userList) {
            console.log('Displaying users:', userList.length);
            if (userList.length === 0) {
                usersList.innerHTML = '<div class="loading"><p>Không có người dùng nào</p></div>';
                return;
            }

            var htmlContent = '';
            for (var i = 0; i < userList.length; i++) {
                var user = userList[i];
                htmlContent += '<div class="user-item" data-user-id="' + user.userID + '" style="cursor: pointer;">';
                htmlContent += '<div class="user-avatar">' + getInitials(user.fullName) + '</div>';
                htmlContent += '<div class="user-info">';
                htmlContent += '<div class="user-name">' + escapeHtml(user.fullName) + '</div>';
                htmlContent += '<div class="user-role">' + getRoleDisplayName(user.roles) + '</div>';
                htmlContent += '</div>';
                htmlContent += '</div>';
            }
            usersList.innerHTML = htmlContent;
            
            // Add click event listeners to each user item
            console.log('Adding click listeners...');
            var userItems = document.querySelectorAll('.user-item');
            for (var i = 0; i < userItems.length; i++) {
                (function(item) {
                    item.addEventListener('click', function(e) {
                        console.log('User item clicked!', this);
                        e.preventDefault();
                        var userId = parseInt(this.getAttribute('data-user-id'));
                        console.log('Extracted userId:', userId);
                        selectUser(userId);
                    });
                })(userItems[i]);
            }
        }

        // Get user initials for avatar
        function getInitials(name) {
            if (!name) return 'U';
            var words = name.split(' ');
            var initials = '';
            for (var i = 0; i < Math.min(words.length, 2); i++) {
                if (words[i][0]) {
                    initials += words[i][0];
                }
            }
            return initials.toUpperCase();
        }

        // Get role display name
        function getRoleDisplayName(roles) {
            if (!roles || roles.length === 0) return 'Người dùng';
            var role = roles[0];
            var roleName = role.roleName.toLowerCase();
            switch(roleName) {
                case 'admin': return 'Quản trị viên';
                case 'owner': return 'Chủ sân';
                case 'user': return 'Khách hàng';
                default: return role.roleName;
            }
        }

        // Select a user to chat with
        function selectUser(userId) {
            console.log('Selecting user:', userId);
            selectedUserId = userId;
            var user = null;
            for (var i = 0; i < users.length; i++) {
                if (users[i].userID === userId) {
                    user = users[i];
                    break;
                }
            }
            
            if (!user) {
                console.error('User not found:', userId);
                return;
            }
            
            console.log('Selected user:', user.fullName);
            
            // Update UI
            var userItems = document.querySelectorAll('.user-item');
            for (var i = 0; i < userItems.length; i++) {
                userItems[i].classList.remove('active');
            }
            
            var selectedItem = document.querySelector('[data-user-id="' + userId + '"]');
            if (selectedItem) {
                selectedItem.classList.add('active');
            }
            
            // Show chat area
            noChatSelected.style.display = 'none';
            chatArea.style.display = 'flex';
            
            // Update chat header
            chatUserName.textContent = user.fullName;
            chatUserRole.textContent = getRoleDisplayName(user.roles);
            chatUserAvatar.textContent = getInitials(user.fullName);
            
            // Load chat history
            loadChatHistory(userId);
        }

        // Load chat history
        function loadChatHistory(userId) {
            chatMessages.innerHTML = '<div class="loading"><i class="fas fa-spinner"></i><p>Đang tải tin nhắn...</p></div>';
            
            fetch('<%= request.getContextPath() %>/api/chat-history?withUserId=' + userId)
                .then(response => {
                    if (!response.ok) throw new Error('Failed to load chat history');
                    return response.json();
                })
                .then(messages => {
                    displayMessages(messages);
                    scrollToBottom();
                })
                .catch(error => {
                    console.error('Error loading chat history:', error);
                    chatMessages.innerHTML = '<div class="loading"><p>Không thể tải tin nhắn</p></div>';
                });
        }

        // Display messages
        function displayMessages(messages) {
            if (messages.length === 0) {
                chatMessages.innerHTML = '<div class="loading"><p>Chưa có tin nhắn nào</p></div>';
                return;
            }

            var htmlContent = '';
            for (var i = 0; i < messages.length; i++) {
                var message = messages[i];
                var isSent = message.senderId === currentUser;
                var messageClass = isSent ? 'sent' : 'received';
                var time = new Date(message.timestamp).toLocaleTimeString('vi-VN', {
                    hour: '2-digit',
                    minute: '2-digit'
                });

                htmlContent += '<div class="message ' + messageClass + '">';
                htmlContent += '<div class="message-bubble">' + escapeHtml(message.content) + '</div>';
                htmlContent += '<div class="message-time">' + time + '</div>';
                htmlContent += '</div>';
            }
            chatMessages.innerHTML = htmlContent;
        }

        // Initialize WebSocket connection
        function initializeWebSocket() {
            console.log('Initializing WebSocket...');
            var protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            var wsUrl = protocol + '//' + window.location.host + '<%= request.getContextPath() %>/ws/chat/' + currentUser;
            
            console.log('WebSocket URL:', wsUrl);
            socket = new WebSocket(wsUrl);
            
            socket.onopen = function() {
                console.log('WebSocket connected successfully');
            };
            
            socket.onmessage = function(event) {
                console.log('WebSocket message received:', event.data);
                var message = JSON.parse(event.data);
                if (message.fromUserId == selectedUserId) {
                    addNewMessage(message, false);
                    scrollToBottom();
                }
            };
            
            socket.onclose = function() {
                console.log('WebSocket disconnected, attempting reconnect...');
                setTimeout(initializeWebSocket, 3000);
            };
            
            socket.onerror = function(error) {
                console.error('WebSocket error:', error);
            };
        }

        // Send message
        function sendMessage() {
            console.log('Send message clicked');
            console.log('Selected user ID:', selectedUserId);
            console.log('Socket state:', socket ? socket.readyState : 'null');
            
            if (!selectedUserId) {
                alert('Vui lòng chọn người dùng để nhắn tin');
                return;
            }
            
            if (!socket || socket.readyState !== WebSocket.OPEN) {
                alert('Kết nối WebSocket chưa sẵn sàng');
                return;
            }

            var message = messageInput.value.trim();
            if (!message) {
                alert('Vui lòng nhập tin nhắn');
                return;
            }

            console.log('Sending message:', message);

            var messageData = {
                toUserId: selectedUserId.toString(),
                content: message
            };

            socket.send(JSON.stringify(messageData));
            
            // Add message to UI immediately
            addNewMessage({
                fromUserId: currentUser.toString(),
                content: message
            }, true);
            
            messageInput.value = '';
            adjustTextareaHeight();
            scrollToBottom();
        }

        // Add new message to chat
        function addNewMessage(message, isSent) {
            var messageElement = document.createElement('div');
            messageElement.className = 'message ' + (isSent ? 'sent' : 'received');
            
            var time = new Date().toLocaleTimeString('vi-VN', {
                hour: '2-digit',
                minute: '2-digit'
            });

            messageElement.innerHTML = 
                '<div class="message-bubble">' + escapeHtml(message.content) + '</div>' +
                '<div class="message-time">' + time + '</div>';

            // Remove loading message if exists
            var loading = chatMessages.querySelector('.loading');
            if (loading) loading.remove();

            chatMessages.appendChild(messageElement);
        }

        // Setup event listeners
        function setupEventListeners() {
            // Send button click
            sendButton.addEventListener('click', sendMessage);
            
            // Enter key to send message
            messageInput.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    sendMessage();
                }
            });
            
            // Auto-resize textarea
            messageInput.addEventListener('input', adjustTextareaHeight);
            
            // User search
            userSearch.addEventListener('input', function() {
                var searchTerm = this.value.toLowerCase();
                var filteredUsers = [];
                for (var i = 0; i < users.length; i++) {
                    var user = users[i];
                    if (user.fullName.toLowerCase().indexOf(searchTerm) !== -1) {
                        filteredUsers.push(user);
                    }
                }
                displayUsers(filteredUsers);
            });
        }

        // Utility functions
        function adjustTextareaHeight() {
            messageInput.style.height = 'auto';
            messageInput.style.height = Math.min(messageInput.scrollHeight, 120) + 'px';
        }

        function scrollToBottom() {
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        function escapeHtml(text) {
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
    </script>
</body>
</html>