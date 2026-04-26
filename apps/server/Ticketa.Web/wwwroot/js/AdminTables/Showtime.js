import { initDataTable } from "../DataTables.js";

const imageBase = "https://image.tmdb.org/t/p/w200";
const trailerKeyCache = new Map();

function toDataTableDate(value) {
    if (!value) return "";
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return "";

    const options = {
        year: 'numeric', month: 'short', day: 'numeric',
        hour: '2-digit', minute: '2-digit'
    };
    return date.toLocaleDateString(undefined, options);
}

function getTrailerModalElements() {
    return {
        trailerModal: document.getElementById("trailer-modal"),
        trailerModalPanel: document.getElementById("trailer-modal-panel"),
        trailerModalTitle: document.getElementById("trailer-modal-title"),
        trailerModalIframe: document.getElementById("trailer-modal-iframe"),
        trailerModalCloseButton: document.getElementById("trailer-modal-close")
    };
}

function getModalTargetRect() {
    const viewportPadding = 20;
    const maxWidth = Math.min(window.innerWidth - (viewportPadding * 2), 1080);
    const maxHeight = Math.min(window.innerHeight - (viewportPadding * 2), 620);

    return {
        left: Math.max((window.innerWidth - maxWidth) / 2, viewportPadding),
        top: Math.max((window.innerHeight - maxHeight) / 2, viewportPadding),
        width: maxWidth,
        height: maxHeight,
        borderRadius: 16
    };
}

function setModalPanelRect(panel, rect) {
    panel.style.left = `${rect.left}px`;
    panel.style.top = `${rect.top}px`;
    panel.style.width = `${rect.width}px`;
    panel.style.height = `${rect.height}px`;
    panel.style.borderRadius = `${rect.borderRadius}px`;
}

function buildTrailerEmbedUrl(videoId) {
    return `https://www.youtube.com/embed/${encodeURIComponent(videoId)}`;
}

async function resolveTrailerKey(initialKey, tmdbId) {
    if (initialKey) return initialKey;
    if (!tmdbId) return "";
    if (trailerKeyCache.has(tmdbId)) return trailerKeyCache.get(tmdbId);

    const response = await fetch(`/Admin/Movies/GetTrailerKey?tmdbId=${encodeURIComponent(tmdbId)}`);
    if (!response.ok) return "";

    const payload = await response.json();
    const key = payload?.key ?? "";
    trailerKeyCache.set(tmdbId, key);
    return key;
}

const trailerModalRuntime = {
    triggerRect: null,
    closeTimer: null,
    requestToken: 0,
    initialized: false
};

function closeMovieTrailerModal() {
    const { trailerModal, trailerModalPanel, trailerModalIframe } = getTrailerModalElements();
    if (!trailerModal || !trailerModalPanel || !trailerModalIframe || trailerModal.hidden) return;

    trailerModal.classList.remove("is-open");
    trailerModalPanel.classList.remove("is-expanded");
    setModalPanelRect(trailerModalPanel, trailerModalRuntime.triggerRect || {
        left: (window.innerWidth / 2) - 28,
        top: (window.innerHeight / 2) - 28,
        width: 56,
        height: 56,
        borderRadius: 18
    });

    trailerModalRuntime.closeTimer = window.setTimeout(() => {
        trailerModal.hidden = true;
        trailerModal.setAttribute("aria-hidden", "true");
        trailerModalIframe.src = "";
        document.body.classList.remove("trailer-modal-lock");
    }, 460);
}

function ensureTrailerModalHandlers() {
    if (trailerModalRuntime.initialized) return;

    const { trailerModal, trailerModalCloseButton, trailerModalPanel } = getTrailerModalElements();
    if (!trailerModal || !trailerModalCloseButton || !trailerModalPanel) return;

    trailerModal.addEventListener("click", event => {
        if (event.target.matches("[data-modal-close]")) closeMovieTrailerModal();
    });

    trailerModalCloseButton.addEventListener("click", closeMovieTrailerModal);

    document.addEventListener("keydown", event => {
        if (event.key === "Escape") closeMovieTrailerModal();
    });

    window.addEventListener("resize", () => {
        if (!trailerModal.hidden) setModalPanelRect(trailerModalPanel, getModalTargetRect());
    });

    trailerModalRuntime.initialized = true;
}

window.openMovieTrailer = async function (triggerButton, title, trailerKey = "", tmdbId = "") {
    const { trailerModal, trailerModalPanel, trailerModalTitle, trailerModalIframe } = getTrailerModalElements();
    if (!trailerModal || !trailerModalPanel || !trailerModalTitle || !trailerModalIframe || !triggerButton) return;

    ensureTrailerModalHandlers();

    const sourceRect = triggerButton.getBoundingClientRect();
    trailerModalRuntime.triggerRect = {
        left: sourceRect.left,
        top: sourceRect.top,
        width: sourceRect.width,
        height: sourceRect.height,
        borderRadius: Math.min(sourceRect.width, sourceRect.height) * 0.34
    };

    window.clearTimeout(trailerModalRuntime.closeTimer);
    trailerModal.hidden = false;
    trailerModal.setAttribute("aria-hidden", "false");
    trailerModalTitle.textContent = `${title} trailer`;
    trailerModalIframe.src = "";
    setModalPanelRect(trailerModalPanel, trailerModalRuntime.triggerRect);
    const requestToken = ++trailerModalRuntime.requestToken;

    requestAnimationFrame(() => {
        trailerModal.classList.add("is-open");
        trailerModalPanel.classList.add("is-expanded");
        setModalPanelRect(trailerModalPanel, getModalTargetRect());
    });

    window.setTimeout(async () => {
        const key = await resolveTrailerKey(trailerKey, tmdbId);
        if (requestToken !== trailerModalRuntime.requestToken || trailerModal.hidden) return;

        if (!key) {
            trailerModalTitle.textContent = `${title} trailer unavailable`;
            return;
        }
        trailerModalIframe.src = buildTrailerEmbedUrl(key);
    }, 220);

    document.body.classList.add("trailer-modal-lock");
};

function initSegmentedFilter(onChange) {
    const segmentedRoot = document.getElementById("mySegmentedFilter");
    if (!segmentedRoot) return;

    const mountSegmentedFilter = () => {
        const host = document.querySelector(".segmentedFilter");
        if (!host) return false;

        if (segmentedRoot.parentElement !== host) {
            host.appendChild(segmentedRoot);
            segmentedRoot.style.display = "";
            segmentedRoot.classList.remove("hidden");
        }
        return true;
    };

    if (!mountSegmentedFilter()) {
        const observer = new MutationObserver(() => {
            if (mountSegmentedFilter()) observer.disconnect();
        });
        observer.observe(document.body, { childList: true, subtree: true });
        window.setTimeout(() => observer.disconnect(), 5000);
    }

    const segmented = segmentedRoot.querySelector(".msf-track");
    if (!segmented) return;

    const pill = segmented.querySelector(".msf-pill");
    const items = Array.from(segmented.querySelectorAll(".msf-btn"));
    if (!pill || items.length === 0) return;

    const movePillTo = (item) => {
        pill.style.width = `${item.offsetWidth}px`;
        pill.style.transform = `translateX(${item.offsetLeft}px)`;
    };

    const getActiveItem = () => segmented.querySelector(".msf-btn.is-active") ?? items[0];

    const setActive = (item) => {
        items.forEach(button => {
            const isCurrent = button === item;
            button.classList.toggle("is-active", isCurrent);
            button.setAttribute("aria-selected", isCurrent ? "true" : "false");
        });
        movePillTo(item);
        if (typeof onChange === 'function') {
            onChange(item.dataset.segment || "all");
        }
    };

    items.forEach(item => {
        item.addEventListener("mouseenter", () => movePillTo(item));
        item.addEventListener("focus", () => movePillTo(item));
        item.addEventListener("click", () => setActive(item));
    });

    segmented.addEventListener("mouseleave", () => movePillTo(getActiveItem()));
    window.addEventListener("resize", () => movePillTo(getActiveItem()));
    movePillTo(getActiveItem());
}

const dataTableElement = document.getElementById("DataTable");

// Initialize TomSelect inside modal safely
const observeModalForTomSelect = () => {
    const modalContent = document.getElementById("modalContent");
    if (!modalContent) return;

    const observer = new MutationObserver(() => {
        const dropdown = document.getElementById("movie-select-dropdown");
        if (dropdown && !dropdown.classList.contains("tomselected") && typeof window.TomSelect !== "undefined") {
            new window.TomSelect("#movie-select-dropdown", {
                render: {
                    option: function (data, escape) {
                        const poster = data.dataset && data.dataset.poster;
                        const imgSrc = poster ? `https://image.tmdb.org/t/p/w92${poster}` : '';
                        return `
                            <div class="flex items-center gap-3 py-1.5">
                                ${imgSrc
                                ? `<img src="${imgSrc}" class="h-10 w-7 shrink-0 rounded object-cover" />`
                                : `<div class="h-10 w-7 shrink-0 rounded bg-base-300"></div>`}
                                <div class="min-w-0">
                                    <div class="truncate text-sm font-medium">${escape(data.text)}</div>
                                </div>
                            </div>`;
                    },
                    item: function (data, escape) {
                        const poster = data.dataset && data.dataset.poster;
                        const imgSrc = poster ? `https://image.tmdb.org/t/p/w92${poster}` : '';
                        return `
                            <div class="flex items-center gap-2">
                                ${imgSrc
                                ? `<img src="${imgSrc}" class="h-6 w-4 shrink-0 rounded object-cover" />`
                                : ``}
                                <div class="truncate font-medium">${escape(data.text)}</div>
                            </div>`;
                    }
                }
            });
        }
    });

    observer.observe(modalContent, { childList: true, subtree: true });
};

observeModalForTomSelect();

if (dataTableElement) {
    let currentFilter = "all";
    initDataTable("/Admin/Showtime/GetAll", [
        {
            data: "moviePoster",
            orderable: false,
            className: "align-middle text-center w-24",
            render: (data) => {
                if (data) return `<img src="${imageBase}${data}" alt="Poster" class="w-16 rounded shadow-sm mx-auto" />`;
                return `<div class="w-16 h-24 bg-base-300 rounded flex items-center justify-center text-xs text-base-content/50 mx-auto">No Image</div>`;
            }
        },
        {
            data: "movieTitle",
            orderable: false,
            className: "align-middle font-semibold",
            render: (data) => (data && data.length > 40) ? data.substring(0, 30) + "..." : data
        },
        {
            data: "hallName",
            orderable: false,
            className: "align-middle",
            render: (data, type, row) => `<div class="font-semibold">${data}</div><div class="text-xs text-gray-500">${row.totalSeats} seats</div>`
        },
        {
            data: "startTime",
            className: "align-middle text-center whitespace-nowrap",
            render: (data) => toDataTableDate(data)
        },
        {
            data: "endTime",
            className: "align-middle text-center whitespace-nowrap",
            render: (data) => toDataTableDate(data)
        },
        {
            data: "price",
            className: "align-middle text-center whitespace-nowrap",
            render: (data) => `$${parseFloat(data).toFixed(2)}`
        },
        {
            data: "status",
            orderable: false,
            className: "align-middle text-center whitespace-nowrap",
            render: (data, _type, row) => {
                const scheduledSel = data === 0 ? "selected" : "";
                const soldOutSel = data === 1 ? "selected" : "";
                const cancelledSel = data === 2 ? "selected" : "";
                const completedSel = data === 3 ? "selected" : "";

                let colorClass = "";
                if (data === 0) colorClass = "text-blue-700 bg-blue-100 border-blue-200";
                else if (data === 1) colorClass = "text-yellow-700 bg-yellow-100 border-yellow-200";
                else if (data === 2) colorClass = "text-red-700 bg-red-100 border-red-200";
                else if (data === 3) colorClass = "text-green-700 bg-green-100 border-green-200";

                return `
                    <div class="relative inline-block">
                        <select class="select select-sm select-bordered w-36 font-semibold focus:outline-none transition-all duration-200 ${colorClass}" onchange="updateShowtimeStatus(${row.id}, this)">
                            <option value="0" ${scheduledSel}>✓ Scheduled</option>
                            <option value="1" ${soldOutSel}>🎟️ Sold Out</option>
                            <option value="2" ${cancelledSel}>🚫 Cancelled</option>
                            <option value="3" ${completedSel}>✅ Completed</option>
                        </select>
                        <span class="status-indicator absolute -right-1 -top-1 hidden"></span>
                    </div>
                `;
            }
        },
        {
            data: "id",
            orderable: false,
            className: "align-middle text-center whitespace-nowrap",
            render: (id, _type, row) => `
                <div class="flex flex-row justify-center items-center gap-2">
                    <div class="tooltip" data-tip="Trailer">
                         <button type="button" class="btn btn-ghost btn-sm hover:bg-blue-50 text-bold" onclick="openMovieTrailer(this, '${(row.movieTitle ?? "Movie").replace(/'/g, "&#39;")}', '${row.trailerKey ?? ""}', '${row.tmdbId ?? ""}')">
                            <svg xmlns="http://www.w3.org/2000/svg" height="18" width="18" fill="currentColor" viewBox="0 0 24 24" stroke="none" class="file-current text-indigo-600">
                                <path d="M5 5a2 2 0 0 1 3.008-1.728l11.997 6.998a2 2 0 0 1 .003 3.458l-12 7A2 2 0 0 1 5 19z"/>
                            </svg>
                         </button>
                    </div>
                    <div class="tooltip" data-tip="Edit">
                         <button type="button" class="btn btn-ghost btn-sm text-violet-500 hover:bg-violet-50" onclick="openModal('createForm', '/admin/showtime/create', 'showtime')">
                             <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-pencil-icon lucide-pencil">
                                <path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"/><path d="m15 5 4 4"/>
                             </svg>
                         </button>
                    </div>
                    <div class="tooltip" data-tip="Delete">
                         <button type="button" class="btn btn-ghost btn-sm text-red-400 hover:bg-red-50" onclick="openModal('deleteForm', '/Admin/Showtime/DeleteConfirmation/${id}', 'showtime')">
                                    <svg xmlns="http://www.w3.org/2000/svg"
                                        height="18" width="18" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v3M4 7h16" />
                                    </svg>
                         </button>
                    </div>
                </div>
            `
        }
    ], {
        order: [[3, "desc"]],
        ajaxData: function () {
            return { segmentedFilter: currentFilter };
        },
        initComplete: function () {
            const api = this.api();
            initSegmentedFilter((filter) => {
                currentFilter = filter;
                api.ajax.reload();
            });
        },
        serverSide: true
    });
}

window.updateShowtimeStatus = async function (id, selectEl) {
    const newStatus = parseInt(selectEl.value, 10);
    const wrapper = selectEl.parentElement;
    const indicator = wrapper.querySelector('.status-indicator');

    let colorClass = "";
    if (newStatus === 0) colorClass = "text-blue-700 bg-blue-100 border-blue-200";
    else if (newStatus === 1) colorClass = "text-yellow-700 bg-yellow-100 border-yellow-200";
    else if (newStatus === 2) colorClass = "text-red-700 bg-red-100 border-red-200";
    else if (newStatus === 3) colorClass = "text-green-700 bg-green-100 border-green-200";

    selectEl.className = "select select-sm select-bordered w-36 font-semibold focus:outline-none transition-all duration-200 " + colorClass;

    selectEl.disabled = true;
    selectEl.style.opacity = '0.7';
    selectEl.style.cursor = 'wait';
    indicator.innerHTML = '⟳';
    indicator.className = 'status-indicator absolute -right-1 -top-1 text-xs animate-spin text-violet-600';
    indicator.classList.remove('hidden');

    try {
        const formData = new FormData();
        formData.append('id', id);
        formData.append('status', newStatus);

        const response = await fetch('/Admin/Showtime/UpdateStatus', {
            method: 'POST',
            body: formData
        });

        if (response.ok) {
            const data = await response.json();
            if (data.success) {
                indicator.innerHTML = '✓';
                indicator.className = 'status-indicator absolute -right-1 -top-1 text-xs text-green-600';
                setTimeout(() => indicator.classList.add('hidden'), 1500);
            } else {
                showError();
            }
        } else {
            showError();
        }
    } catch (err) {
        showError();
    } finally {
        selectEl.disabled = false;
        selectEl.style.opacity = '1';
        selectEl.style.cursor = 'default';
    }

    function showError() {
        indicator.innerHTML = '✕';
        indicator.className = 'status-indicator absolute -right-1 -top-1 text-xs text-red-600';
        selectEl.classList.add('animate-pulse');
        setTimeout(() => {
            indicator.classList.add('hidden');
            selectEl.classList.remove('animate-pulse');
        }, 2000);
    }
};