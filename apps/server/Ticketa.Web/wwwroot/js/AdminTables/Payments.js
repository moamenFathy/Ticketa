import { initDataTable } from "../DataTables.js";

initDataTable("/Payments/GetAll", [
  {
    data: "userName",
    className: "align-middle font-semibold"
  },
  {
    data: "userEmail",
    className: "align-middle"
  },
  {
    data: "movieTitle",
    className: "align-middle"
  },
  {
    data: "totalAmount",
    className: "align-middle",
    render: (data) => `${data.toFixed(2)} EGP`
  },
  {
    data: "status",
    className: "align-middle",
    render: (data) => {
      const colorClass = data === "Completed"
        ? "bg-green-100 text-green-800"
        : data === "Refunded"
          ? "bg-yellow-100 text-yellow-800"
          : data === "Pending"
            ? "bg-blue-100 text-blue-800"
            : "bg-gray-100 text-gray-800";
      return `<div class="flex justify-center"><span class="badge badge-sm font-medium border-0 ${colorClass}">${data}</span></div>`;
    }
  },
  {
    data: "createdAt",
    className: "align-middle",
    render: (data) => new Date(data).toLocaleDateString()
  },
  {
    data: "id",
    orderable: false,
    className: "align-middle text-center whitespace-nowrap",
    render: (id, _type, row) => {
      if (row.status === "Refunded")
        return `<span class="text-sm text-gray-500">Refunded ${new Date(row.refundedAt).toLocaleDateString()}</span>`;
      if (row.status !== "Completed") return "";
      return `
        <div class="flex flex-row justify-center items-center gap-2">
          <button type="button" class="refund-btn btn btn-ghost btn-sm" data-payment-id="${id}" data-user-name="${row.userName}" data-movie-title="${row.movieTitle}" data-amount="${row.totalAmount}">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-redo2-icon lucide-redo-2">
                    <path d="m15 14 5-5-5-5" />
                    <path d="M20 9H9.5A5.5 5.5 0 0 0 4 14.5A5.5 5.5 0 0 0 9.5 20H13" />
                </svg>
            Refund
          </button>
        </div>`;
    }
  }
], {
  order: [[5, 'desc']],
  columnDefs: [
    { className: "flex justify-center gap-1", targets: 6 },
  ],
  stateLoadParams: (settings, data) => {
    if (data.columns.length !== 7) {
      localStorage.removeItem(`DataTables_${settings.sTableId}_${window.location.pathname}`);
      return false;
    }
  },
});

document.addEventListener('click', (e) => {
  const btn = e.target.closest('.refund-btn');
  if (!btn) return;

  document.getElementById('refundPaymentId').value = btn.dataset.paymentId;
  document.getElementById('refundDetails').innerHTML =
    `Are you sure you want to refund <span class="font-semibold text-error">${parseFloat(btn.dataset.amount).toFixed(2)} EGP</span> paid by <span class="font-semibold">${btn.dataset.userName}</span> for <span class="font-semibold">${btn.dataset.movieTitle}</span>?`;

  document.getElementById('modal').checked = true;
});
