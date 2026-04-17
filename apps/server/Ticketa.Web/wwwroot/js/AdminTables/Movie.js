import { initDataTable } from "../DataTables.js";

const imageBase = "https://image.tmdb.org/t/p/w200";

const dataTableElement = document.getElementById("DataTable");

if (dataTableElement) {
    initDataTable("/Admin/Movies/GetAll", [
        {
            data: "posterPath",
            orderable: false,
            className: "align-middle text-center w-24",
            render: (data) => {
                if (data) {
                    return `<img src="${imageBase}${data}" alt="Poster" class="w-16 rounded shadow-sm mx-auto" />`;
                }

                return `<div class="w-16 h-24 bg-base-300 rounded flex items-center justify-center text-xs text-base-content/50 mx-auto">No Image</div>`;
            }
        },
        {
            data: "title",
            className: "align-middle font-semibold",
            render: (data) => (data && data.length > 40) ? data.substring(0, 30) + "..." : data
        },
        {
            data: "overview",
            className: "align-middle whitespace-normal w-64",
            render: (data) => {
                if (!data) return "";
                const truncated = data.substring(0, 35) + "...";
                return `<div class="text-sm text-base-content/80" title="${data.replace(/"/g, "&quot;")}">${truncated}</div>`;
            }
        },
        {
            data: "voteAverage",
            className: "align-middle text-center",
            render: (data) => {
                return `
                        <span class="badge" style="background-color: #FEF3C7; color: #B45309; border: none; padding: 0.75rem 0.5rem; font-weight: 600;">
                            ⭐ ${parseFloat(data).toFixed(1)}
                        </span>
                `;
            }
        },
        {
            data: "releaseDate",
            className: "align-middle text-center whitespace-nowrap",
            render: (data) => {
                if (!data) return "";
                return new Date(data).toLocaleDateString();
            }
        },
        {
            data: "importedAt",
            className: "align-middle text-center whitespace-nowrap",
            render: (data) => {
                if (!data) return "";
                return new Date(data).toLocaleDateString();
            }
        },
        {
            data: "runtimeMinutes",
            render: (minutes) => {
                const h = Math.floor(minutes / 60);
                const m = minutes % 60;
                return h > 0 ? `${h}h ${m}m` : `${m}m`;
            }
        },
        {
            data: "status",
            className: "align-middle text-center whitespace-nowrap",
            render: (data, _type, row) => {
                const activeSel = data === 0 ? "selected" : "";
                const comingSel = data === 1 ? "selected" : "";
                const archivedSel = data === 2 ? "selected" : "";

                const colorClass = data === 0 ? "text-green-700 bg-green-100 border-green-200" :
                    data === 1 ? "text-blue-700 bg-blue-100 border-blue-200" :
                        "text-gray-600 bg-gray-100 border-gray-200";

                return `
                    <div class="relative inline-block">
                        <select class="select select-sm select-bordered w-32 font-semibold focus:outline-none transition-all duration-200 ${colorClass}" onchange="updateMovieStatus(${row.id}, this)">
                            <option value="0" ${activeSel}>✓ Active</option>
                            <option value="1" ${comingSel}>🕐 Coming Soon</option>
                            <option value="2" ${archivedSel}>📦 Archived</option>
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
            render: (id) => `
                        <div class="flex flex-row justify-center items-center gap-2">
                            <div class="tooltip" data-tip="Edit">
                                 <button type="button" class="btn btn-ghost btn-sm text-violet-500 hover:bg-violet-50" onclick="openModal('editForm', '/admin/movies/Upsert/${id}', 'movie')">
                                     <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-pencil-icon lucide-pencil">
                                        <path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"/><path d="m15 5 4 4"/>
                                     </svg>
                                 </button>
                            </div>
                            <div class="tooltip" data-tip="Delete">
                                 <button type="button" class="btn btn-ghost btn-sm text-red-400 hover:bg-red-50" onclick="openModal('deleteForm', '/Admin/Movies/DeleteConfirmation/${id}', 'movie')">
                                            <svg xmlns="http://www.w3.org/2000/svg"
                                                height="16" width="16" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                      d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v3M4 7h16" />
                                            </svg>
                                 </button>
                            </div>
                        </div>
                        `
        }
    ], {
        order: [[5, "desc"]]
    });
}

function initMovieImportPage() {
    const movieSelectElement = document.getElementById("movie-select");
    if (!movieSelectElement || typeof window.TomSelect === "undefined") {
        return;
    }

    function debounce(fn, delay) {
        let timer;
        return function (...args) {
            clearTimeout(timer);
            timer = setTimeout(() => fn.apply(this, args), delay);
        };
    }

    function escapeHtml(value) {
        if (!value) {
            return "";
        }

        return String(value)
            .replaceAll("&", "&amp;")
            .replaceAll("<", "&lt;")
            .replaceAll(">", "&gt;")
            .replaceAll('"', "&quot;")
            .replaceAll("'", "&#39;");
    }

    let searchAbortController;
    const loadingIndicator = document.getElementById("movie-select-loading");
    const previewSection = document.getElementById("preview-section");
    const previewList = document.getElementById("preview-list");
    const previewCount = document.getElementById("preview-count");
    const previewEmpty = document.getElementById("preview-empty");
    const clearAllButton = document.getElementById("clear-all-selection");
    const trailerModal = document.getElementById("trailer-modal");
    const trailerModalPanel = document.getElementById("trailer-modal-panel");
    const trailerModalTitle = document.getElementById("trailer-modal-title");
    const trailerModalIframe = document.getElementById("trailer-modal-iframe");
    const trailerModalCloseButton = document.getElementById("trailer-modal-close");
    let trailerTriggerRect;
    let trailerCloseTimer;
    const trailerKeyCache = new Map();
    let trailerRequestToken = 0;

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

    function setModalPanelRect(rect) {
        trailerModalPanel.style.left = `${rect.left}px`;
        trailerModalPanel.style.top = `${rect.top}px`;
        trailerModalPanel.style.width = `${rect.width}px`;
        trailerModalPanel.style.height = `${rect.height}px`;
        trailerModalPanel.style.borderRadius = `${rect.borderRadius}px`;
    }

    function buildTrailerWatchUrl(videoId) {
        return `https://www.youtube.com/embed/${encodeURIComponent(videoId)}`;
    }

    async function getTrailerKey(tmdbId) {
        if (!tmdbId) {
            return "";
        }

        if (trailerKeyCache.has(tmdbId)) {
            return trailerKeyCache.get(tmdbId);
        }

        const response = await fetch(`/Admin/Movies/GetTrailerKey?tmdbId=${encodeURIComponent(tmdbId)}`);
        if (!response.ok) {
            return "";
        }

        const payload = await response.json();
        const key = payload?.key ?? "";
        trailerKeyCache.set(tmdbId, key);
        return key;
    }

    async function openTrailerModal(title, triggerButton, tmdbId) {
        const sourceRect = triggerButton.getBoundingClientRect();
        trailerTriggerRect = {
            left: sourceRect.left,
            top: sourceRect.top,
            width: sourceRect.width,
            height: sourceRect.height,
            borderRadius: Math.min(sourceRect.width, sourceRect.height) * 0.34
        };

        window.clearTimeout(trailerCloseTimer);
        trailerModal.hidden = false;
        trailerModal.setAttribute("aria-hidden", "false");
        trailerModalTitle.textContent = `${title} trailer`;
        trailerModalIframe.src = "";
        setModalPanelRect(trailerTriggerRect);
        const requestToken = ++trailerRequestToken;

        requestAnimationFrame(() => {
            trailerModal.classList.add("is-open");
            trailerModalPanel.classList.add("is-expanded");
            setModalPanelRect(getModalTargetRect());
        });

        window.setTimeout(async () => {
            const trailerKey = await getTrailerKey(tmdbId);
            if (requestToken !== trailerRequestToken || trailerModal.hidden) {
                return;
            }

            if (!trailerKey) {
                trailerModalTitle.textContent = `${title} trailer unavailable`;
                return;
            }

            trailerModalIframe.src = buildTrailerWatchUrl(trailerKey);
        }, 220);

        document.body.classList.add("trailer-modal-lock");
    }

    function closeTrailerModal() {
        if (trailerModal.hidden) {
            return;
        }

        trailerModal.classList.remove("is-open");
        trailerModalPanel.classList.remove("is-expanded");
        setModalPanelRect(trailerTriggerRect || {
            left: (window.innerWidth / 2) - 28,
            top: (window.innerHeight / 2) - 28,
            width: 56,
            height: 56,
            borderRadius: 18
        });

        trailerCloseTimer = window.setTimeout(() => {
            trailerModal.hidden = true;
            trailerModal.setAttribute("aria-hidden", "true");
            trailerModalIframe.src = "";
            document.body.classList.remove("trailer-modal-lock");
        }, 460);
    }

    function setSelectLoading(isLoading) {
        if (!loadingIndicator) return;
        loadingIndicator.classList.toggle("hidden", !isLoading);
    }

    function updatePreviewState() {
        const count = previewList.children.length;
        previewCount.textContent = `${count} selected`;
        clearAllButton.disabled = count === 0;
        previewSection.classList.toggle("hidden", count === 0);
        previewEmpty.classList.toggle("hidden", count !== 0);
    }

    function getImageSrc(posterPath, size = "w200") {
        return posterPath ? `https://image.tmdb.org/t/p/${size}${posterPath}` : "";
    }

    function addPreviewCard(movie) {
        const cardId = `preview-card-${movie.value}`;
        if (document.getElementById(cardId)) {
            return;
        }

        const card = document.createElement("article");
        card.id = cardId;
        card.className = "preview-card preview-card-enter group flex items-stretch rounded-2xl border border-base-300/70 bg-base-100 shadow-sm transition-shadow hover:shadow-md";
        const poster = getImageSrc(movie.poster);
        const safeTitle = escapeHtml(movie.title);
        const safeOverview = escapeHtml(movie.overview || "No overview available.");
        const safeYear = escapeHtml(movie.year || "N/A");
        const safeRating = escapeHtml(movie.rating || "0.0");

        card.innerHTML = `
            <div class="w-24 sm:w-28 shrink-0 overflow-hidden rounded-l-2xl bg-base-300">
                ${poster
                    ? `<img src="${poster}" alt="${safeTitle}" class="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105" />`
                    : `<div class="h-full w-full"></div>`}
            </div>
            <div class="flex flex-1 items-center justify-between gap-4 p-4">
                <div class="min-w-0 flex-1">
                    <div class="mb-1.5 flex flex-wrap items-center gap-2">
                        <h3 class="truncate text-base font-semibold" title="${safeTitle}">${safeTitle}</h3>
                        <span class="badge badge-sm">${safeYear}</span>
                        <span class="badge badge-sm badge-warning badge-outline">⭐ ${safeRating}</span>
                    </div>
                    <p class="line-clamp-2 text-sm text-base-content/65">${safeOverview}</p>
                </div>
                <button type="button"
                        class="trailer-squircle btn btn-primary btn-sm h-11 w-11 min-h-0 p-0"
                        data-trailer-title="${safeTitle} ${safeYear}"
                        data-tmdb-id="${movie.value}"
                        title="Watch trailer">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                        <path d="M7 6v12l10-6z" />
                    </svg>
                </button>
            </div>`;

        previewList.appendChild(card);
        requestAnimationFrame(() => {
            card.classList.remove("preview-card-enter");
        });
        updatePreviewState();
    }

    function removePreviewCard(value) {
        const card = document.getElementById(`preview-card-${value}`);
        if (!card) {
            updatePreviewState();
            return;
        }

        card.classList.remove("preview-card");
        card.classList.add("preview-card-exit");
        window.setTimeout(() => {
            card.remove();
            updatePreviewState();
        }, 300);
    }

    const debouncedLoad = debounce(function (query, callback) {
        if (!query || query.length < 2) {
            setSelectLoading(false);
            callback();
            return;
        }

        searchAbortController?.abort();
        searchAbortController = new AbortController();
        setSelectLoading(true);

        fetch(`/Admin/Movies/SearchMovies?query=${encodeURIComponent(query)}`, {
            signal: searchAbortController.signal
        })
            .then(res => res.json())
            .then(data => {
                const options = data.map(m => ({
                    value: m.value,
                    text: `${m.text} (${m.year}) — ⭐${m.rating}`,
                    poster: m.poster,
                    overview: m.overview,
                    title: m.text,
                    year: m.year,
                    rating: m.rating
                }));
                callback(options);
            })
            .catch(err => {
                if (err?.name !== "AbortError") {
                    callback();
                }
            })
            .finally(() => setSelectLoading(false));
    }, 300);

    const movieSelect = new window.TomSelect("#movie-select", {
        plugins: ["remove_button", "checkbox_options"],
        valueField: "value",
        labelField: "text",
        searchField: ["text"],
        preload: false,
        shouldLoad: function (query) {
            return query.length >= 2;
        },
        maxOptions: 70,
        load: debouncedLoad,
        render: {
            option: function (data, escape) {
                const imgSrc = getImageSrc(data.poster, "w92");

                return `
                    <div class="flex items-center gap-3 py-1.5">
                        ${imgSrc
                            ? `<img src="${imgSrc}" class="h-14 w-10 shrink-0 rounded object-cover" />`
                            : `<div class="h-14 w-10 shrink-0 rounded bg-base-300"></div>`}
                        <div class="min-w-0">
                            <div class="truncate text-sm font-medium">${escape(data.text)}</div>
                            <div class="line-clamp-2 text-xs text-base-content/60">${escape(data.overview ?? "")}</div>
                        </div>
                    </div>`;
            }
        },
        onItemAdd: function (value) {
            const option = this.options[value];
            if (!option) {
                return;
            }

            addPreviewCard({
                value,
                poster: option.poster,
                overview: option.overview,
                title: option.title ?? option.text,
                year: option.year,
                rating: option.rating
            });
        },
        onItemRemove: function (value) {
            removePreviewCard(value);
        }
    });

    previewList.addEventListener("click", event => {
        const trailerButton = event.target.closest("[data-trailer-title]");
        if (!trailerButton) {
            return;
        }

        const title = trailerButton.getAttribute("data-trailer-title");
        const tmdbId = trailerButton.getAttribute("data-tmdb-id");
        if (!title) {
            return;
        }

        openTrailerModal(title, trailerButton, tmdbId);
    });

    trailerModal.addEventListener("click", event => {
        if (event.target.matches("[data-modal-close]")) {
            closeTrailerModal();
        }
    });

    trailerModalCloseButton.addEventListener("click", closeTrailerModal);

    document.addEventListener("keydown", event => {
        if (event.key === "Escape") {
            closeTrailerModal();
        }
    });

    window.addEventListener("resize", () => {
        if (!trailerModal.hidden) {
            setModalPanelRect(getModalTargetRect());
        }
    });

    clearAllButton.addEventListener("click", () => {
        previewList.querySelectorAll("article").forEach(card => {
            card.classList.remove("preview-card");
            card.classList.add("preview-card-exit");
        });

        window.setTimeout(() => {
            movieSelect.clear();
            previewList.innerHTML = "";
            updatePreviewState();
        }, 220);
    });

    const preselectedOptions = [...document.querySelectorAll("#movie-select option:checked")]
        .map(option => ({
            value: option.value,
            poster: option.getAttribute("data-poster"),
            overview: option.getAttribute("data-overview"),
            title: option.getAttribute("data-title") || option.text,
            year: option.getAttribute("data-year"),
            rating: option.getAttribute("data-rating")
        }));

    preselectedOptions.forEach(addPreviewCard);
    updatePreviewState();
}

initMovieImportPage();

// Attach globally to allow onchange handler in the table
window.updateMovieStatus = async function(id, selectEl) {
    const newStatus = parseInt(selectEl.value, 10);
    const wrapper = selectEl.parentElement;
    const indicator = wrapper.querySelector('.status-indicator');
    
    // Apply new styling immediately
    let colorClass = newStatus === 0 ? "text-green-700 bg-green-100 border-green-200" :
                     newStatus === 1 ? "text-blue-700 bg-blue-100 border-blue-200" :
                     "text-gray-600 bg-gray-100 border-gray-200";
    
    selectEl.className = "select select-sm select-bordered w-32 font-semibold focus:outline-none transition-all duration-200 " + colorClass;
    
    // Show loading state
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

        const response = await fetch('/Admin/Movies/UpdateStatus', {
            method: 'POST',
            body: formData
        });

        if (response.ok) {
            const data = await response.json();
            if (data.success) {
                // Success feedback
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
        console.error("Error updating status:", err);
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