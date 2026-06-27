function togglePassword(inputId, button) {
    const input = document.getElementById(inputId);
    const isPassword = input.type === "password";
    input.type = isPassword ? "text" : "password";
    if (button) {
        button.querySelector(".toggle-eye").classList.toggle("hidden", !isPassword);
        button.querySelector(".toggle-eye-slash").classList.toggle("hidden", isPassword);
    }
}