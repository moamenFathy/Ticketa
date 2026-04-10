const toggle = document.getElementById("themeToggle");

toggle.addEventListener("click", (e) => {
    const html = document.documentElement;
    html.setAttribute(
        "data-theme",
        html.getAttribute("data-theme") === "light" ? "dark" : "light"
    );
});