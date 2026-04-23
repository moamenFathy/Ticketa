document.addEventListener('DOMContentLoaded', function () {
    const otpInputsContainer = document.getElementById('otp-inputs');
    const inputs = [...otpInputsContainer.querySelectorAll('input')];
    const hiddenCodeInput = document.querySelector('input[name="Code"]');

    function updateHiddenInput() {
        const code = inputs.map(input => input.value).join('');
        hiddenCodeInput.value = code;
    }

    otpInputsContainer.addEventListener('input', (e) => {
        const target = e.target;
        const value = target.value;

        // Move to next input if a number is entered
        if (isNaN(value)) {
            target.value = '';
            return;
        }

        updateHiddenInput();

        const next = target.nextElementSibling;
        if (next && value) {
            next.focus();
        }
    });

    otpInputsContainer.addEventListener('keydown', (e) => {
        const target = e.target;
        // Move to previous input on backspace if current is empty
        if (e.key === 'Backspace' && !target.value) {
            const prev = target.previousElementSibling;
            if (prev) {
                prev.focus();
                prev.value = '';
                updateHiddenInput();
            }
        }
    });

    otpInputsContainer.addEventListener('paste', (e) => {
        e.preventDefault();
        const paste = (e.clipboardData || window.clipboardData).getData('text').trim().slice(0, 6);
        inputs.forEach((input, i) => {
            input.value = paste[i] || '';
        });
        updateHiddenInput();

        // Focus the next empty input or the last one
        const lastInput = inputs.find(input => !input.value);
        if (lastInput) {
            lastInput.focus();
        } else {
            inputs[5].focus();
        }
    });

    // On first load, focus the first input
    if (inputs.length > 0) {
        inputs[0].focus();
    }
});
