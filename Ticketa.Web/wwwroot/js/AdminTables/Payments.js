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
      if (row.status !== "Completed") return "";
      return `
        <div class="flex flex-row justify-center items-center gap-2">
          <form method="post" action="/Payments/Refund" class="refund-form">
            <input type="hidden" name="id" value="${id}" />
            <input type="hidden" name="__RequestVerificationToken" value="${window.csrfToken}" />
            <button type="submit" class="btn btn-ghost btn-sm text-orange-500 hover:bg-orange-50" onclick="return confirm('Are you sure you want to refund this payment?')">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21 4v4h-4" />
                <path d="M3.07 13.06A7.97 7.97 0 0 0 12 20a7.98 7.98 0 0 0 7.07-4" />
                <path d="M20.93 10.94A7.97 7.97 0 0 0 12 4a7.97 7.97 0 0 0-7.07 4" />
                <path d="M3 12V8h4" />
              </svg>
              Refund
            </button>
          </form>
        </div>`;
    }
  }
], {
  order: [[5, 'desc']],
  columnDefs: [
    { className: "flex justify-center gap-1", targets: 6 },
  ]
});
