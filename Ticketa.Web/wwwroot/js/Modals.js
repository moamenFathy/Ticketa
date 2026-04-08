function openEditModal(id, url) {
    fetch(url)
        .then(res => {
            if (!res.ok) {
                throw new Error("Failed to load hall data.");
            }

            return res.text();
        })
        .then(html => {
            document.getElementById("modalContent").innerHTML = html;
            const form = $("#editForm");
            form.removeData("validator");
            form.removeData("unobtrusiveValidation");
            $.validator.unobtrusive.parse(form);
            // Open DaisyUI modal
            document.getElementById("edit-modal").checked = true;
        })
        .catch(() => {
            document.getElementById("modalContent").innerHTML = `<p class='text-error'>Could not load hall details.</p>
                                                                             <div class="modal-action">
                                                                                <label for="edit-modal" class="btn btn-ghost">Cancel</label>
                                                                             </div>`;
            document.getElementById("edit-modal").checked = true;
        });
}

document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") {
        const editModal = document.getElementById("edit-modal");
        if (editModal) {
            editModal.checked = false;
        }
    }
});

document.addEventListener("click", function (e) {
    const modalWrapper = document.getElementsByClassName("edit-modal-wrapper");
    const editModal = document.getElementById("edit-modal");

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

    console.log(e.target);
    // Each form declares its own url via data attribute
    const url = form.dataset.submitUrl;
    if (!url) return;

    e.preventDefault();

    if ($(form).valid && !$(form).valid()) return;

    const modalId = form.dataset.modalId;
    const modalContent = form.dataset.modalContentId;

    await handleModalFormSubmit(form, url, modalId, modalContent);
});

async function handleModalFormSubmit(form, url, modalId, modalContentId) {
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
            document.getElementById(modalContentId).innerHTML = html || "<p class='text-danger'>Request failed.</p>";

            const failedForm = $(`#${form.id}`);
            failedForm.removeData("validator").removeData("unobtrusiveValidation");
            $.validator.unobtrusive.parse(failedForm);
            return;
        }

        // Success → JSON
        const result = await response.json();
        if (result.success) {
            document.getElementById(modalId).checked = false;
            location.reload();
        }

    } catch (error) {
        console.error("Submit error:", error);
    }
}