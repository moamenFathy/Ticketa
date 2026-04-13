import { initDataTable } from "../DataTables.js";

const imageBase = "https://image.tmdb.org/t/p/w200";

initDataTable("/Admin/Movies/GetAll", [
    {
        data: 'posterPath',
        orderable: false,
        className: 'align-middle text-center w-24',
        render: (data) => {
            if (data) {
                return `<img src="${imageBase}${data}" alt="Poster" class="w-16 rounded shadow-sm mx-auto" />`;
            }
            return `<div class="w-16 h-24 bg-base-300 rounded flex items-center justify-center text-xs text-base-content/50 mx-auto">No Image</div>`;
        }
    },
    { 
        data: 'title',
        className: 'align-middle font-semibold'
    },
    {
        data: 'overview',
        className: 'align-middle whitespace-normal w-64',
        render: (data) => {
            if (!data) return '';
            const truncated = data.substring(0, 35) + "..."
            return `<div class="text-sm text-base-content/80" title="${data.replace(/"/g, '&quot;')}">${truncated}</div>`;
        }
    },
    {
        data: 'voteAverage',
        className: 'align-middle text-center',
        render: (data) => {
            return `
                    <span class="badge" style="background-color: #FEF3C7; color: #B45309; border: none; padding: 0.75rem 0.5rem; font-weight: 600;">
                        ⭐ ${parseFloat(data).toFixed(1)}
                    </span>
            `;
        }
    },
    {
        data: 'releaseDate',
        className: 'align-middle text-center whitespace-nowrap',
        render: (data) => {
            if (!data) return '';
            return new Date(data).toLocaleDateString();
        }
    },
    {
        data: 'importedAt',
        className: 'align-middle text-center whitespace-nowrap',
        render: (data) => {
            if (!data) return '';
            return new Date(data).toLocaleDateString();
        }
    },
    {
        data: 'id',
        orderable: false,
        className: 'align-middle text-center whitespace-nowrap',
        render: (id) => `
                    <div class="flex flex-row justify-center items-center gap-2">
                        <div class="tooltip" data-tip="Edit">
                             <button type="button" class="btn btn-ghost btn-sm text-violet-500 hover:bg-violet-50" onclick="openModal('editForm', '/admin/movies/Upsert/${id}')">
                                 <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-pencil-icon lucide-pencil">
                                    <path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"/><path d="m15 5 4 4"/>
                                 </svg>
                             </button>
                        </div>
                        <div class="tooltip" data-tip="Delete">
                             <button type="button" class="btn btn-ghost btn-sm text-red-400 hover:bg-red-50" onclick="openModal('deleteForm', '/admin/movies/DeleteConfirmation/${id}')">
                                        <svg xmlns="http://www.w3.org/2000/svg"
                                            height="16" width="16" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                        </svg>
                             </button>
                        </div>
                    </div>
                    `
    }
], {
    order: [[5, 'desc']]
});