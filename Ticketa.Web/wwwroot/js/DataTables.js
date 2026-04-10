export function initDataTable(url, columns, options = {}) {
    const applyDaisyPagination = (container) => {
        if (!container) {
            return;
        }

        const paging = container.querySelector('.dt-paging');
        const nav = container.querySelector('.dt-paging nav');

        if (!paging || !nav) {
            return;
        }

        paging.classList.add('flex', 'justify-center', 'my-2');
    };

    const initialize = () => {
        new DataTable('#DataTable', {
            ajax: {
                url: url,
                type: 'GET',
            },
            columns,
            columnDefs: [
                { className: "flex justify-center gap-1", targets: 3 }
            ],
            dom: "<'flex flex-col md:flex-row md:items-center md:justify-between gap-3 mb-4'<''l><'flex items-center gap-2'f>>t<i'mt-5 flex flex-col items-center gap-3'<'text-sm opacity-70'p>>",
            drawCallback: function () {
                applyDaisyPagination(this.api().table().container());
            },
            infoCallback: function () {
                const pageInfo = this.api().page.info();
                return `Page ${pageInfo.page + 1} of ${pageInfo.pages}`;
            },
            initComplete: function () {
                applyDaisyPagination(this.api().table().container());
            },
            stateSave: true,
            ...options
        });
    };

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initialize, { once: true });
    } else {
        initialize();
    }
}