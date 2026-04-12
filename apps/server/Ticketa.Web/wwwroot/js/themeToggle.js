const toggle = document.getElementById("themeToggle");

if (toggle) {
    toggle.addEventListener("click", () => {
        const html = document.documentElement;
        const newTheme = html.getAttribute("data-theme") === "light" ? "dark" : "light";

        html.setAttribute("data-theme", newTheme);
        document.cookie = `theme=${newTheme}; path=/; max-age=${60 * 60 * 24 * 365}`;

        // Sync with user profile on the server asynchronously
        fetch('/Auth/UpdateTheme', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ theme: newTheme })
        }).catch(err => console.error("Theme sync failed:", err));
    });
}