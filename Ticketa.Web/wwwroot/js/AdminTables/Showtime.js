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
    return `https://www.youtube.com/embed/${encodeURIComponent(videoId)}?autoplay=1`;
}

async function resolveTrailerKey(initialKey, tmdbId) {
    if (initialKey) return initialKey;
    if (!tmdbId) return "";
    if (trailerKeyCache.has(tmdbId)) return trailerKeyCache.get(tmdbId);

    const response = await fetch(`/Movies/GetTrailerKey?tmdbId=${encodeURIComponent(tmdbId)}`);
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
    initDataTable("/Showtime/GetAll", [
        {
            data: null,
            orderable: false,
            className: "p-0 border-0 bg-transparent align-top",
            render: function (data, type, row) {
                if (type === 'display') {
                    const poster = row.posterPath ? `<img src="${imageBase}${row.posterPath}" alt="Poster" class="w-12 h-16 object-cover rounded shadow-sm shrink-0" />` : `<div class="w-12 h-16 bg-base-300 rounded flex items-center justify-center text-[10px] text-base-content/50 shrink-0 border border-base-300">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="opacity-30"><rect width="18" height="18" x="3" y="3" rx="2" ry="2"/><circle cx="9" cy="9" r="2"/><path d="m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"/></svg>
                    </div>`;

                    const initials = row.title.substring(0, 2).toUpperCase();

                    let showtimesHtml = '';
                    if (row.showtimes && row.showtimes.length > 0) {
                        showtimesHtml = row.showtimes.map(st => {
                            const start = new Date(st.startTime);
                            const startDate = start.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
                            const startTimeStr = start.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });

                            const end = new Date(st.endTime);
                            const endDate = end.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
                            const endTimeStr = end.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });

                            const priceFormatted = `${st.price.toFixed(2)} $`;

                            const scheduledSel = st.status === 0 ? "selected" : "";
                            const soldOutSel = st.status === 1 ? "selected" : "";
                            const completedSel = st.status === 2 ? "selected" : "";

                            let colorClass = "";
                            if (st.status === 0) colorClass = "text-blue-700 bg-blue-100 border-blue-200";
                            else if (st.status === 1) colorClass = "text-yellow-700 bg-yellow-100 border-yellow-200";
                            else if (st.status === 2) colorClass = "text-green-700 bg-green-100 border-green-200";

                            const statusHtml = `
                                <div class="relative inline-flex items-center">
                                    <select class="select select-sm select-bordered w-36 rounded-full font-semibold focus:outline-none transition-all duration-200 ${colorClass}" onchange="updateShowtimeStatus(${st.id}, this)">
                                        <option value="0" ${scheduledSel}>• Scheduled</option>
                                        <option value="1" ${soldOutSel}>• Sold Out</option>
                                        <option value="2" ${completedSel}>• Completed</option>
                                    </select>
                                    <span class="status-indicator absolute -right-1 -top-1 hidden"></span>
                                </div>
                            `;

                            const fiveHoursFromNow = new Date(new Date().getTime() + (5 * 60 * 60 * 1000));
                            const canEditTime = start > fiveHoursFromNow;
                            const canEditStatus = st.status !== 2 && st.status !== 1;
                            let canEdit = true;
                            let tooltipMsg = "Edit";
                            if (!canEditStatus) {
                                canEdit = false;
                                tooltipMsg = "Cannot edit this status right now";
                            } else if (!canEditTime) {
                                canEdit = false;
                                tooltipMsg = "Cannot edit within 5 hours of starting";
                            }

                            const editButton = canEdit
                                ? `<button type="button" class="btn btn-square btn-outline btn-sm border-base-300 text-violet-500 hover:bg-violet-50 hover:bg-base-200 hover:border-base-400 tooltip" data-tip="${tooltipMsg}" onclick="openModal('createForm', '/showtime/Upsert/' + ${st.id}, 'showtime')">
                                     <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"/><path d="m15 5 4 4"/></svg>
                                   </button>`
                                : `<button type="button" class="btn btn-square btn-outline btn-sm border-base-300 text-base-content/30 cursor-not-allowed tooltip" data-tip="${tooltipMsg}" disabled>
                                     <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"/><path d="m15 5 4 4"/></svg>
                                   </button>`;

                            const canDelete = st.status === 2;
                            const deleteTooltipMsg = canDelete ? "Delete" : "Cannot delete incomplete showtimes";
                            const deleteBtnClass = canDelete ? "btn-square btn-outline btn-sm border-base-300 text-red-500 hover:bg-red-50 hover:border-red-200" : "btn-square btn-outline btn-sm border-base-300 text-base-content/30 cursor-not-allowed";
                            const deleteOnclick = canDelete ? `onclick="openModal('deleteForm', '/Showtime/DeleteConfirmation/${st.id}', 'showtime')"` : "disabled";

                            const deleteButton = `
                                <button type="button" class="btn ${deleteBtnClass} tooltip" data-tip="${deleteTooltipMsg}" ${deleteOnclick}>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v3M4 7h16" /></svg>
                                </button>`;

                            const trailerButton = `
                                <button type="button" class="btn btn-square btn-outline btn-sm border-base-300 text-indigo-600 hover:bg-blue-50 hover:border-base-400 tooltip" data-tip="Trailer" onclick="openMovieTrailer(this, '${(row.title ?? "Movie").replace(/'/g, "&#39;")}', '${st.trailerKey ?? ""}', '${row.tmdbId ?? ""}')">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <polygon points="5 3 19 12 5 21 5 3"/>
                                    </svg>
                                </button>`;

                            const mapButton = `
                                <button type="button" class="btn btn-square btn-outline btn-sm border-base-300 text-blue-500 hover:bg-blue-50 hover:border-base-400 tooltip" data-tip="View Hall Map" onclick="openModal('viewMapForm', '/hall/ViewMap/${st.hallId}', 'seat map')">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="3" rx="2"/><path d="M3 12h18"/><path d="M12 3v18"/></svg>
                                </button>`;

                            return `
                                <div class="flex p-10 items-center flex-wrap md:flex-nowrap gap-6 p-5 border-b border-base-300 last:border-b-0 hover:bg-base-200/30 transition-colors">
                                    <div class="flex flex-col min-w-[120px]">
                                        <span class="text-[10px] font-bold text-base-content/60 uppercase tracking-wider mb-1">Hall</span>
                                        <span class="font-bold text-base">${st.hallName}</span>
                                        <span class="text-xs text-base-content/60 mt-0.5">${st.totalSeats} seats</span>
                                    </div>
                                    
                                    <div class="flex flex-col min-w-[140px]">
                                        <span class="text-[10px] font-bold text-base-content/60 uppercase tracking-wider mb-1">Start</span>
                                        <span class="font-bold text-base">${startDate}</span>
                                        <span class="text-xs text-base-content/60 mt-0.5">${startTimeStr}</span>
                                    </div>
                                    
                                    <div class="flex flex-col min-w-[140px]">
                                        <span class="text-[10px] font-bold text-base-content/60 uppercase tracking-wider mb-1">End</span>
                                        <span class="font-bold text-base">${endDate}</span>
                                        <span class="text-xs text-base-content/60 mt-0.5">${endTimeStr}</span>
                                    </div>
                                    
                                    <div class="flex flex-col min-w-[80px]">
                                        <span class="text-[10px] font-bold text-base-content/60 uppercase tracking-wider mb-1">Price</span>
                                        <span class="font-bold text-base">${priceFormatted}</span>
                                    </div>
                                    
                                    <div class="flex-1 flex justify-center min-w-[150px]">
                                        ${statusHtml}
                                    </div>
                                    
                                    <div class="flex items-center gap-2 justify-end">
                                        ${editButton}
                                        ${trailerButton}
                                        ${mapButton}
                                        ${deleteButton}
                                    </div>
                                </div>
                            `;
                        }).join('');
                    }

                    return `
                    <details class="group border border-base-300 bg-base-100 rounded-xl overflow-hidden [&_summary::-webkit-details-marker]:hidden mb-4 shadow-sm w-full block">
                        <summary class="flex items-center gap-4 p-4 cursor-pointer hover:bg-base-200/50 transition-colors list-none outline-none">
                            ${poster}
                            <div class="flex-1 font-semibold text-xl truncate">${row.title}</div>
                            <div class="badge badge-outline border-base-300 bg-base-200/50 text-sm whitespace-nowrap px-3 py-3">${row.showtimeCount} showtimes</div>
                            <div class="text-base-content/50 transition-transform duration-200 group-open:-rotate-180">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m6 9 6 6 6-6"/></svg>
                            </div>
                        </summary>
                        <div class="border-t border-base-300 flex flex-col">
                            ${showtimesHtml}
                        </div>
                    </details>
                    `;
                }

                // For filter/search
                return row.title + " " + (row.showtimes || []).map(st => st.hallName).join(" ");
            }
        }
    ], {
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
        serverSide: false,
        responsive: false,
        ordering: false,
        bSort: false
    });
}

window.updateShowtimeStatus = async function (id, selectEl) {
    const newStatus = parseInt(selectEl.value, 10);
    const wrapper = selectEl.parentElement;
    const indicator = wrapper.querySelector('.status-indicator');

    let colorClass = "";
    if (newStatus === 0) colorClass = "text-blue-700 bg-blue-100 border-blue-200";
    else if (newStatus === 1) colorClass = "text-yellow-700 bg-yellow-100 border-yellow-200";
    else if (newStatus === 2) colorClass = "text-green-700 bg-green-100 border-green-200";

    selectEl.className = "select select-sm select-bordered w-36 rounded-full font-semibold focus:outline-none transition-all duration-200 " + colorClass;

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

        const response = await fetch('/Showtime/UpdateStatus', {
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