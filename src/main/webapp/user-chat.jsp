<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>

<%
    // Get current user from session
    User currentUser = (User) session.getAttribute("currentUser");
    
    // Check if user is logged in
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get stadium ID from parameter
    String stadiumIdStr = request.getParameter("stadiumId");
    if (stadiumIdStr == null || stadiumIdStr.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/stadiums");
        return;
    }
    
    // Parse stadium ID
    int stadiumId;
    try {
        stadiumId = Integer.parseInt(stadiumIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect(request.getContextPath() + "/stadiums");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat với chủ sân</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: Arial, sans-serif;
            background: #f0f2f5;
        }
        
        .chat-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            height: 600px;
            display: flex;
            flex-direction: column;
        }
        
        .chat-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 20px;
            border-radius: 10px 10px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .user-info {
            display: flex;
            align-items: center;
        }
        
        .avatar {
            width: 40px;
            height: 40px;
            background: rgba(255,255,255,0.3);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-weight: bold;
        }
        
        .back-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
        }
        
        .chat-messages {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background: #f8f9fa;
        }
        
        .message {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
        }
        
        .message.sent {
            align-items: flex-end;
        }
        
        .message.received {
            align-items: flex-start;
        }
        
        .message-bubble {
            max-width: 70%;
            padding: 12px 16px;
            border-radius: 18px;
            word-wrap: break-word;
        }
        
        .message.sent .message-bubble {
            background: #007bff;
            color: white;
        }
        
        .message.received .message-bubble {
            background: #e9ecef;
            color: #333;
        }
        
        .message-time {
            font-size: 11px;
            color: #666;
            margin-top: 5px;
        }
        
        .chat-input {
            padding: 20px;
            border-top: 1px solid #ddd;
            display: flex;
            gap: 10px;
        }
        
        .chat-input input {
            flex: 1;
            border: 1px solid #ddd;
            border-radius: 20px;
            padding: 10px 15px;
            font-size: 14px;
        }
        
        .chat-input button {
            background: #007bff;
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            cursor: pointer;
        }
        
        .no-messages {
            text-align: center;
            color: #666;
            padding: 40px;
        }
        
        .loading {
            text-align: center;
            color: #666;
            padding: 20px;
        }
        
        .connection-status {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 8px 12px;
            border-radius: 5px;
            font-size: 12px;
            z-index: 1000;
        }
        
        .connection-status.connected {
            background: #28a745;
            color: white;
        }
        
        .connection-status.disconnected {
            background: #dc3545;
            color: white;
        }
        
        .connection-status.connecting {
            background: #ffc107;
            color: black;
        }
    </style>
</head>
<body>
    <!-- Connection Status -->
    <div id="connectionStatus" class="connection-status connecting">
        <i class="fas fa-circle"></i> Đang kết nối...
    </div>

    <div class="chat-container">
        <div class="chat-header">
            <div class="user-info">
                <div class="avatar" id="ownerAvatar">C</div>
                <div>
                    <h3 id="ownerName" style="margin: 0;">Chủ sân</h3>
                    <p id="stadiumName" style="margin: 0; opacity: 0.9; font-size: 14px;">Stadium #<%= stadiumId %></p>
                </div>
            </div>
            <a href="<%= request.getContextPath() %>/stadium-detail?stadiumId=<%= stadiumId %>" class="back-btn">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>
        
        <div class="chat-messages" id="chatMessages">
            <div class="loading">
                <i class="fas fa-spinner fa-spin"></i> Đang tải tin nhắn...
            </div>
        </div>
        
        <div class="chat-input">
            <input type="text" id="messageInput" placeholder="Nhập tin nhắn..." maxlength="500">
            <button onclick="sendMessage()" id="sendButton">
                <i class="fas fa-paper-plane"></i>
            </button>
        </div>
    </div>

    <script>
        // Global variables
        var currentUserId = <%= currentUser.getUserID() %>;
        var stadiumId = <%= stadiumId %>;
        var ownerId = null;
        var socket = null;

        console.log('Chat initialized');
        console.log('User ID:', currentUserId);
        console.log('Stadium ID:', stadiumId);

        // Initialize on page load
        window.onload = function() {
            loadOwnerInfo();
            loadChatHistory();
            initializeWebSocket();
            setupEventListeners();
        };

        // Load owner information
        function loadOwnerInfo() {
            console.log('Loading owner info...');
            
            fetch('<%= request.getContextPath() %>/api/stadium-owner?stadiumId=' + stadiumId)
                .then(function(response) {
                    console.log('Owner API response status:', response.status);
                    return response.json();
                })
                .then(function(data) {
                    console.log('Owner data received:', data);
                    
                    if (data.userId) {
                        ownerId = data.userId;
                        var ownerName = data.fullName || 'Chủ sân';
                        
                        document.getElementById('ownerName').textContent = ownerName;
                        
                        var avatar = document.getElementById('ownerAvatar');
                        if (data.avatarUrl) {
                            avatar.innerHTML = '<img src="' + data.avatarUrl + '" style="width:100%;height:100%;border-radius:50%;object-fit:cover;">';
                        } else {
                            avatar.textContent = ownerName.charAt(0).toUpperCase();
                        }
                        
                        console.log('Owner loaded:', ownerName, 'ID:', ownerId);
                    }
                })
                .catch(function(error) {
                    console.error('Error loading owner:', error);
                    document.getElementById('ownerName').textContent = 'Chủ sân';
                });
        }

        // Load chat history
        function loadChatHistory() {
            console.log('Loading chat history...');
            
            fetch('<%= request.getContextPath() %>/api/stadium-chat-history?stadiumId=' + stadiumId)
                .then(function(response) {
                    console.log('Chat history response status:', response.status);
                    if (!response.ok) throw new Error('Failed to load chat history');
                    return response.json();
                })
                .then(function(messages) {
                    console.log('Chat history loaded:', messages.length, 'messages');
                    displayMessages(messages);
                    scrollToBottom();
                })
                .catch(function(error) {
                    console.error('Error loading chat history:', error);
                    document.getElementById('chatMessages').innerHTML = 
                        '<div class="no-messages"><i class="fas fa-comments"></i><p>Chưa có tin nhắn nào</p><p>Hãy bắt đầu cuộc trò chuyện!</p></div>';
                });
        }

        // Display messages
        function displayMessages(messages) {
            var chatMessages = document.getElementById('chatMessages');
            
            if (messages.length === 0) {
                chatMessages.innerHTML = '<div class="no-messages"><i class="fas fa-comments"></i><p>Chưa có tin nhắn nào</p><p>Hãy bắt đầu cuộc trò chuyện!</p></div>';
                return;
            }

            var htmlContent = '';
            for (var i = 0; i < messages.length; i++) {
                var message = messages[i];
                // Check if message has the correct properties from your MessageDAO
                var isSent = (message.senderID || message.senderId) === currentUserId;
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
            updateConnectionStatus('connecting');
            
            var protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            var wsUrl = protocol + '//' + window.location.host + '<%= request.getContextPath() %>/ws/chat/' + currentUserId;
            
            console.log('WebSocket URL:', wsUrl);
            socket = new WebSocket(wsUrl);
            
            socket.onopen = function() {
                console.log('WebSocket connected successfully');
                updateConnectionStatus('connected');
            };
            
            socket.onmessage = function(event) {
                console.log('WebSocket message received:', event.data);
                try {
                    var message = JSON.parse(event.data);
                    // Check for both possible property names from your WebSocket
                    var fromUserId = parseInt(message.fromUserId || message.senderID || message.senderId);
                    if (fromUserId === ownerId) {
                        addNewMessage(message, false);
                        scrollToBottom();
                    }
                } catch (error) {
                    console.error('Error parsing message:', error);
                }
            };
            
            socket.onclose = function() {
                console.log('WebSocket disconnected, attempting reconnect...');
                updateConnectionStatus('disconnected');
                setTimeout(initializeWebSocket, 3000);
            };
            
            socket.onerror = function(error) {
                console.error('WebSocket error:', error);
                updateConnectionStatus('disconnected');
            };
        }

        // Update connection status
        function updateConnectionStatus(status) {
            var statusElement = document.getElementById('connectionStatus');
            statusElement.className = 'connection-status ' + status;
            
            switch(status) {
                case 'connected':
                    statusElement.innerHTML = '<i class="fas fa-circle"></i> Đã kết nối';
                    setTimeout(function() {
                        statusElement.style.opacity = '0';
                    }, 2000);
                    break;
                case 'connecting':
                    statusElement.innerHTML = '<i class="fas fa-circle"></i> Đang kết nối...';
                    statusElement.style.opacity = '1';
                    break;
                case 'disconnected':
                    statusElement.innerHTML = '<i class="fas fa-exclamation-circle"></i> Mất kết nối';
                    statusElement.style.opacity = '1';
                    break;
            }
        }

        // Send message
        function sendMessage() {
            console.log('Send message clicked');
            
            if (!ownerId) {
                alert('Đang tải thông tin chủ sân. Vui lòng thử lại.');
                return;
            }
            
            if (!socket || socket.readyState !== WebSocket.OPEN) {
                alert('Kết nối chưa sẵn sàng. Vui lòng thử lại.');
                return;
            }

            var messageInput = document.getElementById('messageInput');
            var message = messageInput.value.trim();
            
            if (!message) {
                return;
            }
            
            console.log('Sending message to owner:', ownerId, 'Message:', message);

            var messageData = {
                toUserId: ownerId.toString(),
                content: message
            };

            // Send via WebSocket
            socket.send(JSON.stringify(messageData));
            
            // Add message to UI immediately
            addNewMessage({
                fromUserId: currentUserId.toString(),
                content: message
            }, true);
            
            // Clear input
            messageInput.value = '';
            scrollToBottom();
        }

        // Add new message to chat
        function addNewMessage(message, isSent) {
            var chatMessages = document.getElementById('chatMessages');
            
            // Remove no messages placeholder if exists
            var noMessages = chatMessages.querySelector('.no-messages, .loading');
            if (noMessages) {
                noMessages.remove();
            }
            
            var messageDiv = document.createElement('div');
            messageDiv.className = 'message ' + (isSent ? 'sent' : 'received');
            
            var now = new Date();
            var time = now.getHours().toString().padStart(2, '0') + ':' + 
                      now.getMinutes().toString().padStart(2, '0');
            
            // Handle message content - check for different property names
            var content = message.content || message.messageContent || '';
            
            messageDiv.innerHTML = 
                '<div class="message-bubble">' + escapeHtml(content) + '</div>' +
                '<div class="message-time">' + time + '</div>';
            
            chatMessages.appendChild(messageDiv);
        }

        // Setup event listeners
        function setupEventListeners() {
            var messageInput = document.getElementById('messageInput');
            
            // Allow Enter key to send message
            messageInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    sendMessage();
                }
            });
        }

        // Utility functions
        function scrollToBottom() {
            var chatMessages = document.getElementById('chatMessages');
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