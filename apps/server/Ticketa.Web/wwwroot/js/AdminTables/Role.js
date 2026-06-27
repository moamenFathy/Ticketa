import { initDataTable } from "../DataTables.js";

document.addEventListener("change", function (e) {
  var selectAll = e.target.closest(".select-all");
  if (selectAll) {
    var group = selectAll.getAttribute("data-group");
    var card = selectAll.closest(".card");
    var checks = card.querySelectorAll(".perm-check." + group);
    checks.forEach(function (cb) { cb.checked = selectAll.checked; });
    return;
  }

  var permCheck = e.target.closest(".perm-check");
  if (permCheck) {
    var card = permCheck.closest(".card");
    var group = Array.from(permCheck.classList).find(function (c) { return c.startsWith("perm-group-"); });
    if (!group) return;
    var allChecks = card.querySelectorAll(".perm-check." + group);
    var selectAllCb = card.querySelector(".select-all");
    if (selectAllCb) {
      selectAllCb.checked = Array.from(allChecks).every(function (cb) { return cb.checked; });
    }
  }
});

initDataTable("/Role/GetAll", [
  {
    data: "name",
    className: "align-middle font-semibold"
  },
  {
    data: "isAdminRole",
    className: "align-middle",
    render: (data) => {
      if (data) {
        return `<div class="flex justify-center"><span class="badge badge-sm font-medium border-0 bg-purple-100 text-purple-800">Admin</span></div>`;
      }
      return `<div class="flex justify-center"><span class="badge badge-sm font-medium border-0 bg-base-200 text-base-content/60">Standard</span></div>`;
    }
  },
  {
    data: "permissionCount",
    className: "align-middle",
    render: (data) => {
      return `<div class="flex justify-center"><span class="badge badge-sm font-medium border-0 bg-blue-100 text-blue-800">${data}</span></div>`;
    }
  },
  {
    data: "userCount",
    className: "align-middle"
  },
  {
    data: "id",
    orderable: false,
    className: "align-middle text-center whitespace-nowrap",
    render: (id, _type, row) => `
      <div class="flex flex-row justify-center items-center gap-2">
        <div class="tooltip" data-tip="Edit">
          <button type="button" class="btn btn-ghost btn-sm text-violet-500 hover:bg-violet-50" onclick="openModal('roleForm', '/Role/LoadForEdit/${id}', 'role')">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"/>
              <path d="m15 5 4 4"/>
            </svg>
          </button>
        </div>
        <div class="tooltip" data-tip="${row.userCount > 0 ? 'Cannot delete: role has assigned users' : 'Delete'}">
          <button type="button"
                  class="btn btn-ghost btn-sm text-red-400 hover:bg-red-50 ${row.userCount > 0 ? 'btn-disabled opacity-30' : ''}"
                  ${row.userCount > 0 ? 'disabled' : ''}
                  onclick="openModal('deleteForm', '/Role/DeleteConfirmation/${id}', 'role')">
            <svg xmlns="http://www.w3.org/2000/svg" height="16" width="16" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </button>
        </div>
      </div>`
  }
], {
  order: [[0, 'asc']],
  columnDefs: [
    { className: "flex justify-center gap-1", targets: 4 }
  ]
});
