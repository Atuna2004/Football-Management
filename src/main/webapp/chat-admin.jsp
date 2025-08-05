<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/account/login.jsp");
        return;
    }
    
    // Only allow regular users to access this page
    if (!currentUser.isUser()) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat với Nhân viên - Hỗ trợ</title>
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
            background: #f8f9fa;
            min-height: 100vh;
            overflow: hidden;
        }

        .chat-container {
            display: flex;
            height: 100vh;
            background: white;
            overflow: hidden;
        }

        /* Staff List Sidebar */
        .staff-list-sidebar {
            width: 400px;
            background: white;
            border-right: 1px solid #e5e7eb;
            display: flex;
            flex-direction: column;
        }

        .staff-list-header {
            padding: 20px 24px;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            border-radius: 0;
        }

        .staff-list-header h2 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .staff-list-header p {
            font-size: 14px;
            opacity: 0.9;
            font-weight: 400;
        }

        .search-box {
            padding: 16px 24px;
            border-bottom: 1px solid #f3f4f6;
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 12px 16px 12px 40px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            background: #f9fafb;
            transition: all 0.2s ease;
            color: #6b7280;
        }

        .search-input:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .search-input::placeholder {
            color: #9ca3af;
        }

        .search-box i {
            position: absolute;
            left: 36px;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
            font-size: 14px;
        }

        .staff-list {
            flex: 1;
            overflow-y: auto;
            padding: 0;
        }

        .staff-item {
            display: flex;
            align-items: center;
            padding: 16px 24px;
            cursor: pointer;
            transition: all 0.2s ease;
            border-bottom: 1px solid #f3f4f6;
            background: white;
        }

        .staff-item:hover {
            background: #f8fafc;
        }

        .staff-item.active {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            border-bottom-color: transparent;
        }

        .staff-avatar {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background: #6b7280;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 14px;
            margin-right: 12px;
            text-transform: uppercase;
        }

        .staff-item.active .staff-avatar {
            background: rgba(255, 255, 255, 0.25);
        }

        .staff-info {
            flex: 1;
            min-width: 0;
        }

        .staff-name {
            font-weight: 500;
            font-size: 14px;
            margin-bottom: 2px;
            color: #1f2937;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .staff-item.active .staff-name {
            color: white;
        }

        .staff-role {
            font-size: 12px;
            color: #6b7280;
            font-weight: 400;
        }

        .staff-item.active .staff-role {
            color: rgba(255, 255, 255, 0.8);
        }

        /* Chat Area */
        .chat-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #f8f9fa;
        }

        .chat-header {
            padding: 20px 24px;
            background: white;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
        }

        .chat-staff-info {
            display: flex;
            align-items: center;
            flex: 1;
        }

        .chat-staff-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 16px;
            margin-right: 12px;
            text-transform: uppercase;
        }

        .chat-staff-details h3 {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 2px;
            color: #1f2937;
        }

        .chat-staff-details p {
            font-size: 13px;
            color: #6b7280;
        }

        .connection-status {
            display: flex;
            align-items: center;
            font-size: 12px;
            font-weight: 500;
            padding: 4px 8px;
            border-radius: 6px;
        }

        .connection-status.connected {
            background: #dcfce7;
            color: #16a34a;
        }

        .connection-status.disconnected {
            background: #fee2e2;
            color: #dc2626;
        }

        .connection-status i {
            margin-right: 4px;
            font-size: 8px;
        }

        .chat-messages {
            flex: 1;
            padding: 24px;
            overflow-y: auto;
            background: #f8f9fa;
            display: flex;
            flex-direction: column;
        }

        .message {
            max-width: 70%;
            margin-bottom: 16px;
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
            padding: 12px 16px;
            border-radius: 16px;
            font-size: 14px;
            line-height: 1.4;
            word-wrap: break-word;
            position: relative;
        }

        .message.sent .message-bubble {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            border-bottom-right-radius: 4px;
        }

        .message.received .message-bubble {
            background: white;
            color: #1f2937;
            border: 1px solid #e5e7eb;
            border-bottom-left-radius: 4px;
        }

        .message-time {
            font-size: 11px;
            color: #9ca3af;
            margin-top: 4px;
            font-weight: 400;
        }

        .message.sent .message-time {
            color: #9ca3af;
        }

        .chat-input-area {
            padding: 16px 24px 24px;
            background: white;
            border-top: 1px solid #e5e7eb;
        }

        .chat-input-container {
            display: flex;
            align-items: flex-end;
            gap: 12px;
            max-width: 100%;
        }

        .chat-input {
            flex: 1;
            padding: 12px 16px;
            border: 1px solid #e5e7eb;
            border-radius: 20px;
            font-size: 14px;
            background: #f9fafb;
            transition: all 0.2s ease;
            resize: none;
            min-height: 44px;
            max-height: 120px;
            font-family: inherit;
        }

        .chat-input:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .chat-input::placeholder {
            color: #9ca3af;
        }

        .send-button {
            width: 44px;
            height: 44px;
            border: none;
            border-radius: 50%;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .send-button:hover:not(:disabled) {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
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
            color: #9ca3af;
            background: #f8f9fa;
        }

        .no-chat-selected i {
            font-size: 64px;
            margin-bottom: 16px;
            opacity: 0.5;
            color: #d1d5db;
        }

        .no-chat-selected h3 {
            font-size: 18px;
            margin-bottom: 8px;
            font-weight: 500;
            color: #6b7280;
        }

        .no-chat-selected p {
            font-size: 14px;
            color: #9ca3af;
        }

        /* Loading States */
        .loading {
            text-align: center;
            padding: 20px;
            color: #9ca3af;
        }

        .loading i {
            font-size: 20px;
            animation: spin 1s linear infinite;
            color: #3b82f6;
            margin-bottom: 8px;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* Welcome Message */
        .welcome-message {
            background: #eff6ff;
            border: 1px solid #dbeafe;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 20px;
            text-align: center;
        }

        .welcome-message i {
            color: #3b82f6;
            margin-bottom: 8px;
            font-size: 20px;
        }

        .welcome-message h4 {
            color: #1e40af;
            margin-bottom: 4px;
            font-size: 14px;
            font-weight: 600;
        }

        .welcome-message p {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.4;
        }

        /* Scrollbar Styling */
        .staff-list::-webkit-scrollbar,
        .chat-messages::-webkit-scrollbar {
            width: 4px;
        }

        .staff-list::-webkit-scrollbar-track,
        .chat-messages::-webkit-scrollbar-track {
            background: #f3f4f6;
        }

        .staff-list::-webkit-scrollbar-thumb,
        .chat-messages::-webkit-scrollbar-thumb {
            background: #d1d5db;
            border-radius: 2px;
        }

        .staff-list::-webkit-scrollbar-thumb:hover,
        .chat-messages::-webkit-scrollbar-thumb:hover {
            background: #9ca3af;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .staff-list-sidebar {
                width: 320px;
            }
            
            .chat-container {
                height: 100vh;
            }
        }

        /* Header for mobile back navigation */
        .mobile-header {
            display: none;
            padding: 16px 20px;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            align-items: center;
            gap: 12px;
        }

        .mobile-header a {
            color: white;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        @media (max-width: 768px) {
            .mobile-header {
                display: flex;
            }
        }
    </style>
</head>
<body>
    <div class="mobile-header">
        <a href="<%= request.getContextPath() %>/home.jsp">
            <i class="fas fa-arrow-left"></i>
            Quay lại
        </a>
        <span>Chat với Nhân viên</span>
        <div class="connection-status" id="connectionStatusMobile">
            <i class="fas fa-circle"></i>
            <span>Đang kết nối...</span>
        </div>
    </div>
    
    <div class="chat-container">
        <!-- Staff List Sidebar -->
        <div class="staff-list-sidebar">
            <div class="staff-list-header">
                <h2>
                    <i class="fas fa-comments"></i>
                    Tin Nhắn
                </h2>
                <p>Quản lý cuộc trò chuyện</p>
            </div>
            
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" class="search-input" id="staffSearch" placeholder="Tìm kiếm người dùng...">
            </div>
            
            <div class="staff-list" id="staffList">
                <div class="loading">
                    <i class="fas fa-spinner"></i>
                    <p>Đang tải danh sách nhân viên...</p>
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
            
            <div id="chatArea" style="display: none; flex: 1; display: flex; flex-direction: column;">
                <div class="chat-header" id="chatHeader">
                    <div class="chat-staff-info">
                        <div class="chat-staff-avatar" id="chatStaffAvatar">HN</div>
                        <div class="chat-staff-details">
                            <h3 id="chatStaffName">Nhân viên</h3>
                            <p id="chatStaffRole">Người dùng</p>
                        </div>
                    </div>
                    <div class="connection-status connected" id="connectionStatus">
                        <i class="fas fa-circle"></i>
                        <span>Đã kết nối</span>
                    </div>
                </div>
                
                <div class="chat-messages" id="chatMessages">
                    <div class="welcome-message">
                        <i class="fas fa-heart"></i>
                        <h4>Chào mừng bạn đến với dịch vụ hỗ trợ!</h4>
                        <p>Chúng tôi sẵn sàng hỗ trợ bạn 24/7. Hãy để lại câu hỏi và chúng tôi sẽ trả lời ngay.</p>
                    </div>
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

    <script>
        // Global variables
        let currentUser = <%= currentUser.getUserID() %>;
        let selectedAdminId = null;
        let socket = null;
        let admins = [];
        let connectionRetryCount = 0;
        let maxRetries = 5;

        // DOM elements
        const staffList = document.getElementById('staffList');
        const staffSearch = document.getElementById('staffSearch');
        const noChatSelected = document.getElementById('noChatSelected');
        const chatArea = document.getElementById('chatArea');
        const chatMessages = document.getElementById('chatMessages');
        const messageInput = document.getElementById('messageInput');
        const sendButton = document.getElementById('sendButton');
        const chatStaffName = document.getElementById('chatStaffName');
        const chatStaffAvatar = document.getElementById('chatStaffAvatar');
        const chatStaffRole = document.getElementById('chatStaffRole');
        const connectionStatus = document.getElementById('connectionStatus');
        const connectionStatusMobile = document.getElementById('connectionStatusMobile');

        // Initialize chat
        document.addEventListener('DOMContentLoaded', function() {
            console.log('=== CHAT INITIALIZATION ===');
            console.log('Current user ID:', currentUser);
            console.log('Context path:', '<%= request.getContextPath() %>');
            
            loadAdminList();
            initializeWebSocket();
            setupEventListeners();
        });

        // Load admin list from API
        function loadAdminList() {
            console.log('Loading admin list...');
            fetch('<%= request.getContextPath() %>/api/admin-list')
                .then(response => {
                    console.log('Admin list response status:', response.status);
                    if (!response.ok) {
                        return response.text().then(text => {
                            throw new Error(`HTTP ${response.status}: ${text}`);
                        });
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Admins loaded successfully:', data);
                    admins = data;
                    displayAdmins(admins);
                })
                .catch(error => {
                    console.error('Error loading admin list:', error);
                    staffList.innerHTML = '<div class="loading"><p style="color: #dc2626;">Lỗi: ' + error.message + '</p></div>';
                });
        }

        // Display admins in the sidebar
        function displayAdmins(adminList) {
            console.log('Displaying admins:', adminList.length);
            if (adminList.length === 0) {
                staffList.innerHTML = '<div class="loading"><p>Không có nhân viên nào</p></div>';
                return;
            }

            var htmlContent = '';
            for (var i = 0; i < adminList.length; i++) {
                var admin = adminList[i];
                htmlContent += '<div class="staff-item" data-admin-id="' + admin.userID + '" style="cursor: pointer;">';
                htmlContent += '<div class="staff-avatar">' + getInitials(admin.fullName) + '</div>';
                htmlContent += '<div class="staff-info">';
                htmlContent += '<div class="staff-name">' + escapeHtml(admin.fullName) + '</div>';
                htmlContent += '<div class="staff-role">Nhân viên hỗ trợ</div>';
                htmlContent += '</div>';
                htmlContent += '</div>';
            }
            staffList.innerHTML = htmlContent;
            
            // Add click event listeners to each admin item
            console.log('Adding click listeners...');
            var staffItems = document.querySelectorAll('.staff-item');
            for (var i = 0; i < staffItems.length; i++) {
                (function(item) {
                    item.addEventListener('click', function(e) {
                        console.log('Staff item clicked!', this);
                        e.preventDefault();
                        var adminId = parseInt(this.getAttribute('data-admin-id'));
                        console.log('Extracted adminId:', adminId);
                        selectAdmin(adminId);
                    });
                })(staffItems[i]);
            }
        }

        // Get user initials for avatar
        function getInitials(name) {
            if (!name) return 'S';
            var words = name.split(' ');
            var initials = '';
            for (var i = 0; i < Math.min(words.length, 2); i++) {
                if (words[i][0]) {
                    initials += words[i][0];
                }
            }
            return initials.toUpperCase();
        }

        // Select an admin to chat with
        function selectAdmin(adminId) {
            console.log('=== SELECTING ADMIN ===');
            console.log('Admin ID:', adminId);
            
            selectedAdminId = adminId;
            var admin = null;
            for (var i = 0; i < admins.length; i++) {
                if (admins[i].userID === adminId) {
                    admin = admins[i];
                    break;
                }
            }
            
            if (!admin) {
                console.error('Admin not found:', adminId);
                return;
            }
            
            console.log('Selected admin:', admin.fullName);
            
            // Update UI
            var staffItems = document.querySelectorAll('.staff-item');
            for (var i = 0; i < staffItems.length; i++) {
                staffItems[i].classList.remove('active');
            }
            
            var selectedItem = document.querySelector('[data-admin-id="' + adminId + '"]');
            if (selectedItem) {
                selectedItem.classList.add('active');
            }
            
            // Show chat area
            noChatSelected.style.display = 'none';
            chatArea.style.display = 'flex';
            
            // Update chat header
            chatStaffName.textContent = admin.fullName;
            chatStaffAvatar.textContent = getInitials(admin.fullName);
            chatStaffRole.textContent = 'Nhân viên hỗ trợ';
            
            // Load chat history
            loadChatHistory(adminId);
        }

        // Load chat history
        function loadChatHistory(adminId) {
            console.log('Loading chat history with admin:', adminId);
            
            chatMessages.innerHTML = '<div class="welcome-message"><i class="fas fa-heart"></i><h4>Chào mừng bạn đến với dịch vụ hỗ trợ!</h4><p>Chúng tôi sẵn sàng hỗ trợ bạn 24/7. Hãy để lại câu hỏi và chúng tôi sẽ trả lời ngay.</p></div><div class="loading"><i class="fas fa-spinner"></i><p>Đang tải tin nhắn...</p></div>';
            
            fetch('<%= request.getContextPath() %>/api/chat-history?withUserId=' + adminId)
                .then(response => {
                    console.log('Chat history response status:', response.status);
                    if (!response.ok) {
                        return response.text().then(text => {
                            throw new Error(`HTTP ${response.status}: ${text}`);
                        });
                    }
                    return response.json();
                })
                .then(messages => {
                    console.log('Chat history loaded:', messages.length, 'messages');
                    displayMessages(messages);
                    scrollToBottom();
                })
                .catch(error => {
                    console.error('Error loading chat history:', error);
                    chatMessages.innerHTML = '<div class="welcome-message"><i class="fas fa-heart"></i><h4>Chào mừng bạn đến với dịch vụ hỗ trợ!</h4><p>Chúng tôi sẵn sàng hỗ trợ bạn 24/7. Hãy để lại câu hỏi và chúng tôi sẽ trả lời ngay.</p></div><div class="loading"><p style="color: #dc2626;">Không thể tải tin nhắn: ' + error.message + '</p></div>';
                });
        }

        // Display messages
        function displayMessages(messages) {
            var welcomeMessage = '<div class="welcome-message"><i class="fas fa-heart"></i><h4>Chào mừng bạn đến với dịch vụ hỗ trợ!</h4><p>Chúng tôi sẵn sàng hỗ trợ bạn 24/7. Hãy để lại câu hỏi và chúng tôi sẽ trả lời ngay.</p></div>';
            
            if (messages.length === 0) {
                chatMessages.innerHTML = welcomeMessage + '<div class="loading"><p>Chưa có tin nhắn nào. Hãy bắt đầu cuộc trò chuyện!</p></div>';
                return;
            }

            var htmlContent = welcomeMessage;
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
            if (socket && socket.readyState === WebSocket.OPEN) {
                console.log('WebSocket already connected');
                return;
            }

            console.log('=== INITIALIZING WEBSOCKET ===');
            
            // Determine protocol
            var protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            var wsUrl = protocol + '//' + window.location.host + '<%= request.getContextPath() %>/ws/chat/' + currentUser;
            
            console.log('WebSocket URL:', wsUrl);
            
            try {
                socket = new WebSocket(wsUrl);
                
                socket.onopen = function(event) {
                    console.log('=== WEBSOCKET CONNECTED ===');
                    console.log('Event:', event);
                    connectionRetryCount = 0;
                    updateConnectionStatus(true);
                };
                
                socket.onmessage = function(event) {
                    console.log('=== WEBSOCKET MESSAGE RECEIVED ===');
                    console.log('Raw data:', event.data);
                    
                    try {
                        var message = JSON.parse(event.data);
                        console.log('Parsed message:', message);
                        
                        if (message.type === 'error') {
                            console.error('WebSocket error message:', message.message);
                            alert('Lỗi: ' + message.message);
                            return;
                        }
                        
                        if (message.type === 'confirmation') {
                            console.log('Message confirmation received');
                            return;
                        }
                        
                        // Regular message from another user
                        if (message.fromUserId && message.content) {
                            var fromUserId = parseInt(message.fromUserId);
                            if (fromUserId === selectedAdminId) {
                                console.log('Adding received message to chat');
                                addNewMessage(message, false);
                                scrollToBottom();
                            } else {
                                console.log('Message from different user, ignoring');
                            }
                        }
                    } catch (e) {
                        console.error('Error parsing WebSocket message:', e);
                    }
                };
                
                socket.onclose = function(event) {
                    console.log('=== WEBSOCKET DISCONNECTED ===');
                    console.log('Code:', event.code);
                    console.log('Reason:', event.reason);
                    console.log('Was clean:', event.wasClean);
                    
                    updateConnectionStatus(false);
                    
                    // Retry connection if not intentionally closed
                    if (connectionRetryCount < maxRetries && event.code !== 1000) {
                        connectionRetryCount++;
                        console.log('Retrying connection... Attempt:', connectionRetryCount);
                        setTimeout(initializeWebSocket, 3000 * connectionRetryCount);
                    }
                };
                
                socket.onerror = function(error) {
                    console.error('=== WEBSOCKET ERROR ===');
                    console.error('Error:', error);
                    updateConnectionStatus(false);
                };
                
            } catch (error) {
                console.error('Failed to create WebSocket:', error);
                updateConnectionStatus(false);
            }
        }

        // Update connection status indicator
        function updateConnectionStatus(connected) {
            var statusElements = [connectionStatus, connectionStatusMobile];
            statusElements.forEach(function(statusEl) {
                if (statusEl) {
                    if (connected) {
                        statusEl.className = 'connection-status connected';
                        statusEl.innerHTML = '<i class="fas fa-circle"></i><span>Đã kết nối</span>';
                    } else {
                        statusEl.className = 'connection-status disconnected';
                        statusEl.innerHTML = '<i class="fas fa-circle"></i><span>Mất kết nối</span>';
                    }
                }
            });
            sendButton.disabled = !connected;
        }

        // Send message
        function sendMessage() {
            console.log('=== SENDING MESSAGE ===');
            console.log('Selected admin ID:', selectedAdminId);
            console.log('Socket state:', socket ? socket.readyState : 'null');
            console.log('Socket ready states: CONNECTING=0, OPEN=1, CLOSING=2, CLOSED=3');
            
            if (!selectedAdminId) {
                alert('Vui lòng chọn nhân viên để nhắn tin');
                return;
            }
            
            if (!socket) {
                alert('Kết nối WebSocket chưa được khởi tạo');
                return;
            }
            
            if (socket.readyState !== WebSocket.OPEN) {
                alert('Kết nối WebSocket chưa sẵn sàng. Trạng thái: ' + socket.readyState);
                return;
            }

            var message = messageInput.value.trim();
            if (!message) {
                alert('Vui lòng nhập tin nhắn');
                return;
            }

            console.log('Message content:', message);
            console.log('Sending to admin ID:', selectedAdminId);

            var messageData = {
                toUserId: selectedAdminId.toString(),
                content: message
            };

            console.log('Message data to send:', messageData);

            try {
                var jsonMessage = JSON.stringify(messageData);
                console.log('JSON message:', jsonMessage);
                
                socket.send(jsonMessage);
                console.log('Message sent successfully via WebSocket');
                
                // Add message to UI immediately
                addNewMessage({
                    fromUserId: currentUser.toString(),
                    content: message,
                    timestamp: Date.now()
                }, true);
                
                messageInput.value = '';
                adjustTextareaHeight();
                scrollToBottom();
                
            } catch (error) {
                console.error('Error sending message:', error);
                alert('Lỗi khi gửi tin nhắn: ' + error.message);
            }
        }

        // Add new message to chat
        function addNewMessage(message, isSent) {
            console.log('Adding new message:', message, 'isSent:', isSent);
            
            var messageElement = document.createElement('div');
            messageElement.className = 'message ' + (isSent ? 'sent' : 'received');
            
            var time;
            if (message.timestamp) {
                time = new Date(message.timestamp).toLocaleTimeString('vi-VN', {
                    hour: '2-digit',
                    minute: '2-digit'
                });
            } else {
                time = new Date().toLocaleTimeString('vi-VN', {
                    hour: '2-digit',
                    minute: '2-digit'
                });
            }

            messageElement.innerHTML = 
                '<div class="message-bubble">' + escapeHtml(message.content) + '</div>' +
                '<div class="message-time">' + time + '</div>';

            // Remove loading message if exists
            var loading = chatMessages.querySelector('.loading');
            if (loading) loading.remove();

            chatMessages.appendChild(messageElement);
            console.log('Message added to DOM');
        }

        // Setup event listeners
        function setupEventListeners() {
            console.log('Setting up event listeners...');
            
            // Send button click
            sendButton.addEventListener('click', function(e) {
                console.log('Send button clicked');
                e.preventDefault();
                sendMessage();
            });
            
            // Enter key to send message
            messageInput.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    console.log('Enter key pressed');
                    e.preventDefault();
                    sendMessage();
                }
            });
            
            // Auto-resize textarea
            messageInput.addEventListener('input', adjustTextareaHeight);
            
            // Staff search
            staffSearch.addEventListener('input', function() {
                var searchTerm = this.value.toLowerCase();
                var filteredAdmins = [];
                for (var i = 0; i < admins.length; i++) {
                    var admin = admins[i];
                    if (admin.fullName.toLowerCase().indexOf(searchTerm) !== -1 ||
                        (admin.email && admin.email.toLowerCase().indexOf(searchTerm) !== -1)) {
                        filteredAdmins.push(admin);
                    }
                }
                displayAdmins(filteredAdmins);
            });
            
            console.log('Event listeners setup complete');
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

        // Debug function to check WebSocket status
        function checkWebSocketStatus() {
            console.log('=== WEBSOCKET STATUS CHECK ===');
            console.log('Socket exists:', !!socket);
            if (socket) {
                console.log('Socket readyState:', socket.readyState);
                console.log('Socket URL:', socket.url);
            }
            console.log('Current user:', currentUser);
            console.log('Selected admin:', selectedAdminId);
            console.log('Connection retry count:', connectionRetryCount);
            console.log('==============================');
        }

        // Make debug function available globally
        window.checkWebSocketStatus = checkWebSocketStatus;
        window.sendTestMessage = function() {
            if (selectedAdminId) {
                messageInput.value = 'Test message at ' + new Date().toLocaleTimeString();
                sendMessage();
            } else {
                alert('Please select an admin first');
            }
        };
    </script>
</body>
</html>