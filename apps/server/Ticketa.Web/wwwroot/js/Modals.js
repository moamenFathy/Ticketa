function openModal(formId, url) {
    fetch(url)
        .then(res => {
            if (!res.ok) {
                throw new Error("Failed to load hall data.");
            }

            return res.text();
        })
        .then(html => {
            document.getElementById("modalContent").innerHTML = html;
            const form = $(`#${formId}`);
            form.removeData("validator");
            form.removeData("unobtrusiveValidation");
            $.validator.unobtrusive.parse(form);
            // Open DaisyUI modal
            document.getElementById("modal").checked = true;

            // Focus autofocus elements manually after injection
            const autofocusInput = document.querySelector("#modalContent [autofocus]");
            if (autofocusInput) autofocusInput.focus();
        })
        .catch(() => {
            document.getElementById("modalContent").innerHTML = `<p class='text-error'>Could not load hall details.</p>
                                                                             <div class="modal-action">
                                                                                <label for="modal" class="btn btn-ghost">Cancel</label>
                                                                             </div>`;
            document.getElementById("modal").checked = true;
        });
}

document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") {
        const editModal = document.getElementById("modal");
        if (editModal) {
            editModal.checked = false;
        }
    }
});

document.addEventListener("click", function (e) {
    const modalWrapper = document.getElementsByClassName("modal-wrapper");
    const editModal = document.getElementById("modal");

    if (!modalWrapper || !editModal || !editModal.checked) {
        return;
    }

    if (e.target === modalWrapper) {
        editModal.checked = false;
    }
});

// One global listener handles all modals
document.addEventListener("submit", async (e) => {
    e.preventDefault();
    const form = e.target;

    // Each form declares its own url via data attribute
    const url = form.dataset.submitUrl;
    if (!url) return;

    e.preventDefault();

    if ($(form).valid && !$(form).valid()) return;

    await handleModalFormSubmit(form, url);
});

async function handleModalFormSubmit(form, url) {
    const formData = new FormData(form);

    try {
        const response = await fetch(url, {
            method: 'POST',
            body: formData
        });

        // Validation failed or server error → re-render form with errors
        const contentType = response.headers.get("content-type");
        if (!response.ok || contentType?.includes("text/html")) {
            const html = await response.text();
            document.getElementById("modalContent").innerHTML = html || "<p class='text-danger'>Request failed.</p>";

            const failedForm = $(`#${form.id}`);
            failedForm.removeData("validator").removeData("unobtrusiveValidation");
            $.validator.unobtrusive.parse(failedForm);
            return;
        }

        // Success → JSON
        const result = await response.json();
        if (result.success) {
            document.getElementById("modal").checked = false;
            location.reload();
        }

    } catch (error) {
        console.error("Submit error:", error);
    }
}