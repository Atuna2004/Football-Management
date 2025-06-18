function showSection(sectionId) {
    const sections = document.querySelectorAll('.section');
    sections.forEach(sec => sec.classList.remove('active'));

    const activeSection = document.getElementById(sectionId);
    if (activeSection) {
        activeSection.classList.add('active');
    }

    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => link.classList.remove('active'));


    const clickedButton = Array.from(navLinks).find(btn =>
        btn.getAttribute('onclick')?.includes(sectionId)
    );
    if (clickedButton) {
        clickedButton.classList.add('active');
    }
}


document.addEventListener("DOMContentLoaded", function () {
    const buttons = document.querySelectorAll(".btn");

    buttons.forEach(button => {
        button.addEventListener("click", function () {
            if (!button.classList.contains("disabled")) {
                button.classList.add("loading");
                button.disabled = true;
                setTimeout(() => {
                    button.classList.remove("loading");
                    button.disabled = false;
                }, 1000);
            }
        });
    });


    const notification = document.getElementById("notification");
    if (notification) {
        const message = notification.dataset.message;
        const type = notification.dataset.type;

        if (message && type) {
            notification.innerHTML = `
                <div class="alert alert-${type === 'error' ? 'danger' : 'success'} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            `;
            setTimeout(() => {
                notification.querySelector(".alert")?.remove();
            }, 5000);
        }
    }
});


function handleFormSubmit(formId, successMessage = "Cập nhật thành công!", errorMessage = "Có lỗi xảy ra.") {
    const form = document.getElementById(formId);
    if (!form)
        return;

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        const formData = new FormData(form);
        const actionUrl = form.action;

        fetch(actionUrl, {
            method: "POST",
            body: new URLSearchParams(formData),
            headers: {
                "X-Requested-With": "XMLHttpRequest"
            }
        })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification(successMessage, "success");
                    } else {
                        showNotification(data.message || errorMessage, "error");
                    }
                })
                .catch(err => {
                    console.error(err);
                    showNotification("Không thể kết nối đến máy chủ.", "error");
                });
    });
}


function showNotification(message, type = "success") {
    const notification = document.getElementById("notification");
    if (!notification)
        return;

    notification.innerHTML = `
        <div class="alert alert-${type === 'error' ? 'danger' : 'success'} alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    `;


    setTimeout(() => {
        const alert = notification.querySelector(".alert");
        if (alert)
            alert.remove();
    }, 5000);
}


function confirmDelete(actionUrl, itemName) {
    if (confirm(`Bạn có chắc chắn muốn xóa "${itemName}" không? Hành động này không thể hoàn tác.`)) {
        window.location.href = actionUrl;
    }
}


function toggleSidebar() {
    const sidebar = document.querySelector(".sidebar");
    if (sidebar) {
        sidebar.classList.toggle("collapsed");
    }
}


function loadDynamicData(url, targetElementId) {
    const target = document.getElementById(targetElementId);
    if (!target)
        return;

    fetch(url)
            .then(response => response.text())
            .then(data => {
                target.innerHTML = data;
            })
            .catch(err => {
                console.error("Lỗi tải dữ liệu:", err);
                target.innerHTML = "<p>Lỗi tải dữ liệu.</p>";
            });
}


document.addEventListener("DOMContentLoaded", function () {
    const forms = document.querySelectorAll("form[id^='form-']");
    forms.forEach(form => {
        const formId = form.id;
        const successMsg = "Dữ liệu đã được cập nhật.";
        const errorMsg = "Có lỗi xảy ra khi xử lý yêu cầu.";
        handleFormSubmit(formId, successMsg, errorMsg);
    });
});