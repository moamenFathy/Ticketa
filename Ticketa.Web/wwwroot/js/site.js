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
});
