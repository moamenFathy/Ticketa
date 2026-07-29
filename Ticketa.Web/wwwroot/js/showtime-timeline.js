const COLORS = 12;
const HOUR_WIDTH = 70;
const ROW_HEIGHT = 68;
const AXIS_START = 0;
const AXIS_END = 24;
const TOTAL_HOURS = AXIS_END - AXIS_START;
const SNAP_MINUTES = 15;
const SNAP_PX = (SNAP_MINUTES / 60) * HOUR_WIDTH;

let editMode = false;
let originalHalls = null;
let moviesCache = [];
let changes = [];
let clientIdCounter = 0;
let currentDateStr = '';
let currentHalls = null;
let onSaveCallback = null;
let isSaving = false;

function getMovieColor(movieId) {
  return `timeline-palette-${Math.abs(movieId) % COLORS}`;
}

function formatTime24(isoString) {
  const d = new Date(isoString);
  return d.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: false });
}

function formatHour24(hour) {
  const d = new Date();
  d.setHours(hour, 0, 0, 0);
  return d.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: false });
}

function snapToGrid(px) {
  return Math.round(px / SNAP_PX) * SNAP_PX;
}

function toPixels(isoString) {
  const d = new Date(isoString);
  const hours = d.getHours() + d.getMinutes() / 60;
  return (hours - AXIS_START) * HOUR_WIDTH;
}

function pixelsToLocalTime(px, dateStr) {
  const hours = AXIS_START + px / HOUR_WIDTH;
  const h = Math.floor(hours);
  const m = Math.round((hours - h) * 60);
  const snappedM = Math.round(m / SNAP_MINUTES) * SNAP_MINUTES;
  const finalH = h + Math.floor(snappedM / 60);
  const finalM = snappedM % 60;
  const pad = n => String(n).padStart(2, '0');
  return `${dateStr}T${pad(finalH)}:${pad(finalM)}`;
}

function durationPixels(startIso, endIso) {
  const start = new Date(startIso);
  const end = new Date(endIso);
  const diffMs = end - start;
  const diffHours = diffMs / (1000 * 60 * 60);
  return Math.max(diffHours * HOUR_WIDTH, 20);
}

function getMinGapPixels() {
  return (SNAP_MINUTES / 60) * HOUR_WIDTH;
}

function isPinned(isoString) {
  const start = new Date(isoString);
  const now = new Date();
  return (start.getTime() - now.getTime()) <= 5 * 60 * 60 * 1000;
}

function getStatusDot(status, isArchived) {
  if (isArchived) return '<span class="tl-status-dot tl-status-completed" title="Completed"></span>';
  if (status === 1) return '<span class="tl-status-dot tl-status-soldout" title="Sold Out"></span>';
  return '<span class="tl-status-dot tl-status-scheduled" title="Scheduled"></span>';
}

function renderNowLine(headerHeight, totalHeight) {
  const now = new Date();
  const hours = now.getHours() + now.getMinutes() / 60;
  if (hours < AXIS_START || hours >= AXIS_END) return '';
  const left = (hours - AXIS_START) * HOUR_WIDTH;
  return `
    <div class="tl-now-line" style="left:${left}px">
      <div class="tl-now-label">${formatHour24(Math.floor(hours))}</div>
      <div class="tl-now-bar" style="height:${totalHeight}px"></div>
    </div>`;
}

function hasCollision(barLeft, barWidth, hallId, excludeId) {
  if (!currentHalls) return false;
  const hall = currentHalls.find(h => h.hallId === hallId);
  if (!hall) return false;
  const changedIds = changes.filter(c => c.action === 'delete').map(c => c.showtimeId);
  return hall.showtimes.some(st => {
    if (st.id === excludeId) return false;
    if (changedIds.includes(st.id)) return false;
    const l = toPixels(st.startTime);
    const w = durationPixels(st.startTime, st.endTime);
    return l < barLeft + barWidth && l + w > barLeft;
  });
}

function getClientId() {
  return `c_${++clientIdCounter}`;
}

// ── Batch Save ──────────────────────────────────────────────────

async function saveChanges(wrapper, dateStr) {
  if (isSaving) return;
  if (changes.length === 0) return;

  const btn = document.getElementById('saveBtn');
  if (btn) { btn.disabled = true; btn.textContent = 'Saving...'; }

  isSaving = true;
  const body = {
    date: dateStr,
    changes: changes.map(c => ({
      action: c.action,
      showtimeId: c.showtimeId,
      movieId: c.movieId,
      hallId: c.hallId,
      startTime: c.startTime,
      price: c.price,
      clientId: c.clientId
    }))
  };

  wrapper.querySelectorAll('.timeline-bar.save-error').forEach(el => el.classList.remove('save-error'));

  try {
    const res = await fetch('/Showtime/SaveBatch', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'RequestVerificationToken': window.csrfToken },
      body: JSON.stringify(body)
    });
    const result = await res.json();

    if (result.errors && result.errors.length > 0) {
      const errorClientIds = new Set(result.errors.map(e => e.clientId).filter(Boolean));
      const errorShowtimeIds = new Set(result.errors.map(e => e.showtimeId).filter(Boolean));

      result.errors.forEach(err => {
        let el = null;
        if (err.clientId) el = wrapper.querySelector(`[data-client-id="${err.clientId}"]`);
        else if (err.showtimeId) el = wrapper.querySelector(`[data-showtime-id="${err.showtimeId}"]`);
        if (el) {
          el.classList.add('save-error');
          el.dataset.errorMsg = err.message;
        }
      });

      changes = changes.filter(c => !errorClientIds.has(c.clientId) && !errorShowtimeIds.has(c.showtimeId));

      if (changes.length > 0) {
        showErrorToast(`${result.errors.length} change(s) failed. ${changes.length} remaining.`);
        if (btn) { btn.disabled = false; btn.textContent = 'Save'; }
        isSaving = false;
        return;
      }
    }

    if (result.success) {
      changes = [];
      isSaving = false;
      resetEditMode();
      if (typeof onSaveCallback === 'function') onSaveCallback(dateStr);
    } else {
      showErrorToast('Save failed. Please try again.');
    }
  } catch {
    showErrorToast('Network error. Please try again.');
  } finally {
    isSaving = false;
    if (btn) { btn.disabled = false; btn.textContent = 'Save'; }
  }
}

function showErrorToast(msg) {
  const container = document.getElementById('timelineContainer');
  if (!container) return;
  let toast = container.querySelector('.tl-toast-error');
  if (!toast) {
    toast = document.createElement('div');
    toast.className = 'tl-toast-error';
    container.prepend(toast);
  }
  toast.textContent = msg;
  toast.style.display = 'block';
  clearTimeout(toast._hide);
  toast._hide = setTimeout(() => { toast.style.display = 'none'; }, 5000);
}

// ── Inline Movie Picker ─────────────────────────────────────────

function createInlinePicker(targetEl, hallId, dateStr) {
  const existing = document.querySelector('.tl-picker');
  if (existing) existing.remove();

  const picker = document.createElement('div');
  picker.className = 'tl-picker';
  const rect = targetEl.getBoundingClientRect();
  const containerRect = targetEl.closest('.timeline-wrapper').getBoundingClientRect();
  picker.style.top = `${rect.top - containerRect.top + rect.height + 4}px`;
  picker.style.left = `${Math.max(0, rect.left - containerRect.left)}px`;

  picker.innerHTML = '<div class="tl-picker-loading">Loading movies...</div>';
  targetEl.closest('.timeline-wrapper').appendChild(picker);

  const left = parseInt(targetEl.style.left, 10);

  fetch('/Showtime/ActiveMoviesDropdown')
    .then(r => r.json())
    .then(movies => {
      moviesCache = movies;
      picker.innerHTML = movies.map(m => `
        <div class="tl-picker-item" data-movie-id="${m.id}" data-runtime="${m.runtime}">
          <img src="https://image.tmdb.org/t/p/w45${m.posterPath}" alt="" class="tl-picker-poster" onerror="this.style.display='none'">
          <span>${m.title}</span>
        </div>
      `).join('') + '<div class="tl-picker-cancel">Cancel</div>';

      picker.querySelectorAll('.tl-picker-item').forEach(item => {
        item.addEventListener('click', () => {
          const movieId = parseInt(item.dataset.movieId);
          const runtime = parseInt(item.dataset.runtime);
          const movie = movies.find(m => m.id === movieId);
          if (!movie) return;

          const startLocal = pixelsToLocalTime(left, dateStr);
          const startDate = new Date(startLocal);
          const endDate = new Date(startDate.getTime() + (runtime + 15) * 60000);
          const width = durationPixels(startDate.toISOString(), endDate.toISOString());

          // Check available space in the row
          const row = targetEl.closest('.tl-row');
          const existing = Array.from(row.querySelectorAll('.timeline-bar:not(.is-deleted)'))
            .map(b => ({ left: parseInt(b.style.left, 10), width: parseInt(b.style.width, 10) }))
            .sort((a, b) => a.left - b.left);
          const nextBar = existing.find(b => b.left > left);
          const availableWidth = nextBar ? nextBar.left - left : Infinity;

          if (width > availableWidth) {
            picker.innerHTML = '<div class="tl-picker-item" style="color:#ef4444;justify-content:center">Not enough space for this movie</div><div class="tl-picker-cancel">Cancel</div>';
            picker.querySelector('.tl-picker-cancel').addEventListener('click', () => picker.remove());
            return;
          }

          const clientId = getClientId();
          changes.push({
            action: 'create',
            clientId,
            movieId,
            hallId,
            startTime: startLocal,
            price: 10.00
          });

          targetEl.outerHTML = `<div class="timeline-bar ${getMovieColor(movieId)} is-staged"
            data-client-id="${clientId}"
            data-movie-id="${movieId}"
            data-hall-id="${hallId}"
            data-start="${startLocal}"
            data-price="10.00"
            style="left:${left}px;width:${width}px"
            title="${movie.title}">
            <div class="tl-status-dot tl-status-scheduled"></div>
            <div class="tl-bar-content">
              <div class="tl-bar-title">${movie.title}</div>
              <div class="tl-bar-time">${formatTime24(startDate.toISOString())}</div>
            </div>
          </div>`;

          picker.remove();
          const newBar = document.querySelector(`[data-client-id="${clientId}"]`);
          if (newBar) {
            newBar.addEventListener('pointerdown', e => startDrag(newBar, e));
            const delBtn = document.createElement('button');
            delBtn.className = 'tl-bar-delete-btn';
            delBtn.innerHTML = '✕';
            delBtn.title = 'Remove';
            delBtn.addEventListener('click', e => {
              e.stopPropagation();
              deleteBar(newBar);
            });
            newBar.appendChild(delBtn);
            const row = newBar.closest('.tl-row');
            if (row) renderGhostSlots(row, hallId);
          }
        });
      });

      picker.querySelector('.tl-picker-cancel').addEventListener('click', () => picker.remove());
    })
    .catch(() => {
      picker.innerHTML = '<div class="tl-picker-item tl-picker-cancel" style="color:#ef4444">Failed to load</div>';
      picker.querySelector('.tl-picker-cancel').addEventListener('click', () => picker.remove());
    });

  const closePicker = e => {
    if (!picker.contains(e.target) && e.target !== targetEl) {
      picker.remove();
      document.removeEventListener('click', closePicker);
    }
  };
  setTimeout(() => document.addEventListener('click', closePicker), 100);
}

// ── Delete Bar ──────────────────────────────────────────────────

function deleteBar(bar) {
  if (bar.classList.contains('is-pinned') || bar.classList.contains('has-bookings')) return;
  if (bar.dataset.clientId) {
    const idx = changes.findIndex(c => c.clientId === bar.dataset.clientId);
    if (idx >= 0) changes.splice(idx, 1);
    bar.remove();
    return;
  }
  const showtimeId = parseInt(bar.dataset.showtimeId);
  if (!showtimeId) return;
  changes.push({ action: 'delete', showtimeId, clientId: getClientId() });
  bar.classList.add('is-deleted');
  bar.classList.remove('is-staged');
}

// ── Drag Logic ──────────────────────────────────────────────────

let dragState = null;
function attachDragHandlers() {
  if (!editMode) return;
  document.querySelectorAll('.timeline-bar:not(.is-deleted)').forEach(bar => {
    bar.style.cursor = 'grab';
  });
}

function startDrag(bar, e) {
  if (!editMode || bar.classList.contains('is-deleted') || bar.classList.contains('is-pinned') || bar.classList.contains('has-bookings') || e.button !== 0) return;
  if (e.target.closest('.tl-bar-delete-btn')) return;
  e.preventDefault();
  const rect = bar.getBoundingClientRect();
  const scrollLeft = bar.closest('.timeline-scroll').scrollLeft;
  const containerLeft = bar.closest('.timeline-body').getBoundingClientRect().left;
  const left = parseInt(bar.style.left, 10);

  dragState = {
    bar,
    startX: e.clientX,
    startLeft: left,
    scrollLeft,
    row: bar.parentElement
  };

  bar.classList.add('is-dragging');
  bar.style.cursor = 'grabbing';
  bar.style.zIndex = 10;

  try { bar.setPointerCapture(e.pointerId); } catch (_) {} // handle simulated events

  document.addEventListener('pointermove', onDrag);
  document.addEventListener('pointerup', endDrag);
}

function onDrag(e) {
  if (!dragState) return;
  const { bar, startX, startLeft, row } = dragState;
  const dx = e.clientX - startX;
  let newLeft = snapToGrid(startLeft + dx);
  const rowWidth = row.offsetWidth;
  const barWidth = parseInt(bar.style.width, 10);
  newLeft = Math.max(0, Math.min(newLeft, rowWidth - barWidth));

  bar.style.left = `${newLeft}px`;

  const hallId = parseInt(bar.dataset.hallId || bar.closest('[data-hall-id]')?.dataset.hallId || 0);
  const excludeId = parseInt(bar.dataset.showtimeId);
  const clientId = bar.dataset.clientId;
  const conflict = hasCollision(newLeft, barWidth, hallId || currentHalls[0]?.hallId, excludeId);

  bar.classList.toggle('has-conflict', conflict);
  bar.classList.toggle('is-valid', !conflict);
}

function endDrag(e) {
  if (!dragState) return;
  const { bar, row } = dragState;

  bar.classList.remove('is-dragging');
  bar.style.cursor = 'grab';
  bar.style.zIndex = '';
  try { bar.releasePointerCapture(e.pointerId); } catch (_) {}

  document.removeEventListener('pointermove', onDrag);
  document.removeEventListener('pointerup', endDrag);

  const newLeft = parseInt(bar.style.left, 10);
  const hallId = parseInt(bar.dataset.hallId || row.closest('[data-hall-id]')?.dataset.hallId || 0);
  const hall = currentHalls?.find(h => h.hallId === hallId);
  const barWidth = parseInt(bar.style.width, 10);

  const conflict = hasCollision(newLeft, barWidth, hallId || hall?.hallId, parseInt(bar.dataset.showtimeId));

  if (conflict) {
    showErrorToast('Cannot place showtime here — conflict with another showtime.');
    bar.classList.remove('has-conflict', 'is-valid');
    dragState = null;
    return;
  }

  bar.classList.remove('has-conflict', 'is-valid');
  const newTime = pixelsToLocalTime(newLeft, currentDateStr);
  const showtimeId = parseInt(bar.dataset.showtimeId);
  const clientId = bar.dataset.clientId;

  if (showtimeId) {
    const existing = changes.find(c => c.showtimeId === showtimeId && c.action === 'update');
    if (existing) {
      existing.startTime = newTime;
    } else {
      changes.push({ action: 'update', showtimeId, startTime: newTime, clientId: getClientId() });
    }
    bar.dataset.start = newTime;
    bar.classList.add('is-staged');
  } else if (clientId) {
    const existing = changes.find(c => c.clientId === clientId);
    if (existing) existing.startTime = newTime;
    bar.dataset.start = newTime;
  }

  const startDate = new Date(newTime);
  const titleEl = bar.querySelector('.tl-bar-title');
  const timeEl = bar.querySelector('.tl-bar-time');
  if (timeEl) timeEl.textContent = formatTime24(startDate.toISOString());
  if (titleEl) bar.title = titleEl.textContent + '\n' + formatTime24(startDate.toISOString());

  // Re-sort bars in the row by position
  const bars = Array.from(row.querySelectorAll('.timeline-bar:not(.is-deleted)'));
  bars.sort((a, b) => parseInt(a.style.left, 10) - parseInt(b.style.left, 10));
  bars.forEach(b => row.appendChild(b));

  // Re-render ghost slots
  renderGhostSlots(row, hallId);

  dragState = null;
}

function renderGhostSlots(row, hallId) {
  row.querySelectorAll('.timeline-bar-ghost').forEach(el => el.remove());
  const bars = Array.from(row.querySelectorAll('.timeline-bar:not(.is-deleted)'));
  const sorted = bars.map(b => ({
    left: parseInt(b.style.left, 10),
    width: parseInt(b.style.width, 10)
  })).sort((a, b) => a.left - b.left);

  for (let i = 0; i < sorted.length - 1; i++) {
    const gapStart = sorted[i].left + sorted[i].width;
    const gapEnd = sorted[i + 1].left;
    const gapWidth = gapEnd - gapStart;
    if (gapWidth > getMinGapPixels()) {
      const ghost = document.createElement('div');
      ghost.className = 'timeline-bar-ghost';
      ghost.dataset.emptyHall = hallId;
      ghost.style.cssText = `left:${gapStart}px;width:${gapWidth}px`;
      ghost.title = 'Click to add showtime';
      ghost.textContent = '+';
      if (editMode) {
        ghost.addEventListener('click', () => createInlinePicker(ghost, hallId, currentDateStr));
      }
      row.appendChild(ghost);
    }
  }

  // Add trailing ghost
  if (sorted.length > 0) {
    const last = sorted[sorted.length - 1];
    const lastEnd = last.left + last.width;
    const rowWidth = row.offsetWidth;
    const trailWidth = Math.max(0, rowWidth - lastEnd);
    if (trailWidth > getMinGapPixels()) {
      const ghost = document.createElement('div');
      ghost.className = 'timeline-bar-ghost';
      ghost.dataset.emptyHall = hallId;
      ghost.style.cssText = `left:${lastEnd}px;width:${trailWidth}px`;
      ghost.title = 'Click to add showtime';
      ghost.textContent = '+';
      if (editMode) {
        ghost.addEventListener('click', () => createInlinePicker(ghost, hallId, currentDateStr));
      }
      row.appendChild(ghost);
    }
  }
}

// ── Edit Mode ───────────────────────────────────────────────────

export function enterEditMode(wrapper) {
  if (editMode) return;
  editMode = true;
  originalHalls = JSON.parse(JSON.stringify(currentHalls));

  wrapper.classList.add('edit-mode');

  document.querySelectorAll('.timeline-bar:not(.is-deleted):not(.has-bookings)').forEach(bar => {
    bar.style.cursor = 'grab';

    const deleteBtn = document.createElement('button');
    deleteBtn.className = 'tl-bar-delete-btn';
    deleteBtn.innerHTML = '✕';
    deleteBtn.title = 'Delete showtime';
    deleteBtn.addEventListener('click', e => {
      e.stopPropagation();
      deleteBar(bar);
    });
    bar.appendChild(deleteBtn);

    bar.addEventListener('pointerdown', e => startDrag(bar, e));
  });

  document.querySelectorAll('.timeline-bar-ghost').forEach(ghost => {
    const hallId = parseInt(ghost.dataset.emptyHall);
    ghost.addEventListener('click', () => createInlinePicker(ghost, hallId, currentDateStr));
  });

  document.querySelectorAll('.timeline-wrapper').forEach(w => {
    w.classList.add('edit-mode');
  });
}

export function exitEditMode(wrapper) {
  if (!editMode) return;
  editMode = false;
  changes = [];

  wrapper.classList.remove('edit-mode');
  document.querySelectorAll('.timeline-wrapper').forEach(w => w.classList.remove('edit-mode'));

  if (originalHalls) {
    currentHalls = originalHalls;
    renderTimeline(document.getElementById('timelineContainer'), originalHalls, currentDateStr);
    originalHalls = null;
  }
}

export function setOnSave(cb) {
  onSaveCallback = cb;
}

export function resetEditMode() {
  editMode = false;
  changes = [];
}

export { saveChanges };

// ── Main Render ─────────────────────────────────────────────────

export function renderTimeline(container, halls, dateStr) {
  container.innerHTML = '';
  currentDateStr = dateStr;
  currentHalls = halls;

  if (!halls || halls.length === 0) {
    container.innerHTML = '<div class="timeline-empty">No showtimes for this date.</div>';
    return;
  }

  const wrapper = document.createElement('div');
  wrapper.className = 'timeline-wrapper';

  const now = new Date();
  const todayLocal = `${now.getFullYear()}-${String(now.getMonth()+1).padStart(2,'0')}-${String(now.getDate()).padStart(2,'0')}`;
  const isToday = dateStr === todayLocal;
  const headerHeight = 44;
  const totalRowsHeight = halls.length * ROW_HEIGHT;

  wrapper.innerHTML = `
    <div class="timeline-grid">
      <div class="timeline-labels">
        <div class="tl-header-spacer"></div>
        ${halls.map(h => `
          <div class="tl-hall-label" title="${h.hallType}" data-hall-id="${h.hallId}">
            <span class="tl-hall-name">${h.hallName}</span>
            <span class="tl-hall-type">${h.hallType}</span>
          </div>`).join('')}
      </div>
      <div class="timeline-scroll">
        <div class="timeline-body">
          <div class="timeline-header" style="height:${headerHeight}px">
            ${Array.from({ length: TOTAL_HOURS }, (_, i) => {
              const hour = AXIS_START + i;
              return `<div class="tl-hour ${hour === 12 ? 'tl-hour-mid' : ''}">${formatHour24(hour)}</div>`;
            }).join('')}
            <div class="tl-hour tl-hour-end">${formatHour24(AXIS_END)}</div>
          </div>

          ${isToday ? renderNowLine(headerHeight, totalRowsHeight) : ''}

          <div class="timeline-rows">
            ${halls.map((hall, hi) => {
              const bars = hall.showtimes.map(st => {
                const left = toPixels(st.startTime);
                const width = durationPixels(st.startTime, st.endTime);
                const colorClass = getMovieColor(st.movieId);
                const statusClass = st.status === 1 ? 'sold-out' : st.status === 2 || st.isArchived ? 'completed' : '';
                const pinnedClass = isPinned(st.startTime) ? 'is-pinned' : '';
                const bookingsClass = st.hasBookings ? 'has-bookings' : '';

                const timeLabel = width > 120
                  ? `<div class="tl-bar-time">${formatTime24(st.startTime)} – ${formatTime24(st.endTime)}</div>`
                  : '';

                return `<div class="timeline-bar ${colorClass} ${statusClass} ${pinnedClass} ${bookingsClass}"
                  data-showtime-id="${st.id}"
                  data-movie-id="${st.movieId}"
                  data-hall-id="${hall.hallId}"
                  data-start="${st.startTime}"
                  data-end="${st.endTime}"
                  data-tmdb-id="${st.tmdbId}"
                  data-trailer-key="${st.trailerKey || ''}"
                  data-title="${st.movieTitle.replace(/"/g, '&quot;')}"
                  data-poster="${st.posterPath || ''}"
                  data-price="${st.price}"
                  data-status="${st.status}"
                  data-runtime="${st.runtimeMinutes}"
                  style="left:${left}px;width:${width}px"
                  title="${st.movieTitle}\n${formatTime24(st.startTime)} – ${formatTime24(st.endTime)}">
                  ${getStatusDot(st.status, st.isArchived)}
                  <div class="tl-bar-content">
                    <div class="tl-bar-title">${st.movieTitle}</div>
                    ${timeLabel}
                  </div>
                </div>`;
              }).join('');

              return `<div class="tl-row ${hi % 2 === 1 ? 'tl-row-striped' : ''}" data-hall-id="${hall.hallId}">${bars}</div>`;
            }).join('')}
          </div>
        </div>
      </div>
    </div>
  `;

  container.appendChild(wrapper);

  // Render ghost slots
  wrapper.querySelectorAll('.tl-row').forEach(row => {
    const hallId = parseInt(row.dataset.hallId);
    renderGhostSlots(row, hallId);
  });

  // Click bar → edit modal (view mode only)
  wrapper.querySelectorAll('.timeline-bar').forEach(el => {
    el.addEventListener('click', e => {
      if (editMode || el.classList.contains('is-pinned') || el.classList.contains('has-bookings')) return;
      const id = el.dataset.showtimeId;
      window.openModal('createForm', `/Showtime/Upsert/${id}`, 'showtime');
    });
    if (!editMode) {
      el.style.cursor = (el.classList.contains('is-pinned') || el.classList.contains('has-bookings')) ? 'not-allowed' : 'pointer';
    }
  });

  // Scroll to now on today
  const scrollArea = wrapper.querySelector('.timeline-scroll');
  if (isToday) {
    const hours = now.getHours() + now.getMinutes() / 60;
    if (hours >= AXIS_START && hours < AXIS_END) {
      scrollArea.scrollLeft = Math.max(0, (hours - AXIS_START - 2) * HOUR_WIDTH);
    }
  }

  // Cross-highlight hover
  let hoveredId = null;
  wrapper.addEventListener('mouseover', e => {
    if (editMode) return;
    const bar = e.target.closest('.timeline-bar');
    if (!bar) {
      if (hoveredId !== null) {
        wrapper.querySelectorAll(`[data-movie-id="${hoveredId}"]`).forEach(el => el.classList.remove('highlight'));
        hoveredId = null;
      }
      return;
    }
    const id = bar.dataset.movieId;
    if (id !== hoveredId) {
      if (hoveredId !== null) {
        wrapper.querySelectorAll(`[data-movie-id="${hoveredId}"]`).forEach(el => el.classList.remove('highlight'));
      }
      hoveredId = id;
      wrapper.querySelectorAll(`[data-movie-id="${id}"]`).forEach(el => el.classList.add('highlight'));
    }
  });

    if (editMode) {
    wrapper.classList.add('edit-mode');
    document.querySelectorAll('.timeline-bar:not(.is-deleted):not(.is-pinned):not(.has-bookings)').forEach(bar => {
      bar.style.cursor = 'grab';
      const deleteBtn = document.createElement('button');
      deleteBtn.className = 'tl-bar-delete-btn';
      deleteBtn.innerHTML = '✕';
      deleteBtn.title = 'Delete showtime';
      deleteBtn.addEventListener('click', e => {
        e.stopPropagation();
        deleteBar(bar);
      });
      bar.appendChild(deleteBtn);
      bar.addEventListener('pointerdown', e => startDrag(bar, e));
    });
    document.querySelectorAll('.timeline-bar-ghost').forEach(ghost => {
      const hallId = parseInt(ghost.dataset.emptyHall);
      ghost.addEventListener('click', () => createInlinePicker(ghost, hallId, dateStr));
    });
  }
}
