// Please see documentation at https://learn.microsoft.com/aspnet/core/client-side/bundling-and-minification
// for details on configuring this project to bundle and minify static web assets.

// Mobile menu toggle
document.addEventListener('DOMContentLoaded', function() {
    const mobileMenuCheckbox = document.getElementById('mobile-menu');
    const mobileNav = document.getElementById('mobile-nav');

    if (mobileMenuCheckbox && mobileNav) {
        mobileNav.style.display = 'none';

        mobileMenuCheckbox.addEventListener('change', function() {
            mobileNav.style.display = this.checked ? 'block' : 'none';
        });
    }

    // Initialize toasts with auto-dismiss
    initToasts();
});

// Toast system
function initToasts() {
    const container = getOrCreateToastContainer();
    const toasts = document.querySelectorAll('[data-toast]');
    toasts.forEach(toast => {
        container.appendChild(toast);
        const duration = parseInt(toast.dataset.toastDuration) || 4000;
        autoDismissToast(toast, duration);
    });
}

function autoDismissToast(toast, duration) {
    // Add enter animation
    toast.classList.add('toast-enter');

    // Add progress bar
    const progress = document.createElement('div');
    progress.className = 'toast-progress';
    progress.style.animationDuration = `${duration}ms`;
    toast.style.position = 'relative';
    toast.appendChild(progress);

    // Auto-dismiss
    setTimeout(() => {
        toast.classList.remove('toast-enter');
        toast.classList.add('toast-exit');
        setTimeout(() => {
            toast.remove();
        }, 300);
    }, duration);
}

// Create toast programmatically
function showToast(message, type = 'success', duration = 4000) {
    const container = getOrCreateToastContainer();
    const toast = createToastElement(message, type, duration);
    container.appendChild(toast);
    autoDismissToast(toast, duration);
    return toast;
}

function getOrCreateToastContainer() {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
    return container;
}

function createToastElement(message, type, duration) {
    const toast = document.createElement('div');
    toast.setAttribute('role', 'alert');
    toast.className = `alert alert-${type} shadow-lg toast-enter`;
    toast.dataset.toast = 'true';
    toast.dataset.toastDuration = duration;
    toast.innerHTML = getToastIcon(type) + `<span>${escapeHtml(message)}</span>`;
    return toast;
}

function getToastIcon(type) {
    const icons = {
        success: `<svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-5 w-5" fill="none" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>`,
        error: `<svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-5 w-5" fill="none" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>`,
        warning: `<svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-5 w-5" fill="none" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
        </svg>`,
        info: `<svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-5 w-5" fill="none" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>`
    };
    return icons[type] || icons.info;
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
