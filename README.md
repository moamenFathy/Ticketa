# 🎬 Ticketa — Halls & Seats Module

> **Fox Cinema-style app** | ASP.NET Core MVC | by Moamen

---

## 🏗️ Architecture — Layered Solution

```
Ticketa.sln
├── Ticketa.Core           → Entities, Enums, Interfaces, DTOs, Helpers
├── Ticketa.Infrastructure → EF Core, Repositories, UoW, Services
└── Ticketa.Web            → Controllers, ViewModels, Views
```

---

## ✅ القرار المتخذ — Fixed Template per Hall Type

### المشكلة المطروحة

كانت فيه خيارين:

- **Option A — Admin يرسم الـ Map يدوياً**: admin يشوف grid كامل، يحدد إيه الكراسي اللي موجودة وإيه اللي مش موجودة، وبعدين يعيّن category لكل كرسي أو row.
- **Option B — Fixed Template لكل Hall Type**: كل نوع hall (Standard / IMAX / Gold) بيجي بـ layout جاهز. الـ seats بتتولد أوتوماتيك على أساسه وقت إنشاء الـ hall.

### ✅ القرار: Option B — Fixed Template

**السبب:**
- الـ seat map editor في Option A ده feature لوحده — drag to select، toggle existence، bulk assign — ده 2–3 أسابيع شغل لو عملناه صح
- الـ cinema chains الحقيقية (VOX, Cinemark) بتشتغل بنفس الفكرة — pre-configured templates مش بتتغير بعد الـ setup
- الـ HallType بالفعل موجود في الـ Showtime module — نكمّل عليه
- لو في المستقبل hall معين محتاج layout مختلف → نضيف "override mode" فوق الـ template ده بدل ما نبني من الأول

---

## 🎭 Enums — القرارات المتخذة

```csharp
// Ticketa.Core/Enums/HallType.cs
public enum HallType
{
    Standard,
    IMAX,
    Gold
}
```

```csharp
// Ticketa.Core/Enums/SeatCategory.cs
public enum SeatCategory
{
    Regular,
    VIP,
    Premium,
}
```

### Allowed Categories per Hall Type

| Hall Type | Seat Categories المسموح بيها |
|-----------|-------------------------------|
| Standard  | Regular, VIP                  |
| IMAX      | Regular, Premium              |
| Gold      | Regular                       |

---

## 🏛️ Entities

### Hall

```csharp
// Ticketa.Core/Entities/Hall.cs
public class Hall
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;   // "Hall 1", "IMAX Hall"
    public HallType Type { get; set; }
    public int TotalRows { get; set; }      // مشتق من الـ template — بيتحفظ للعرض بس
    public int SeatsPerRow { get; set; }    // مشتق من الـ template — بيتحفظ للعرض بس

    // ❌ ICollection<Seat> Seats — اتشالت، مفيش Seat table في الـ DB
    public ICollection<Showtime> Showtimes { get; set; } = new List<Showtime>();
}
```

### Seat (⚠️ تم التراجع عنها — لا يوجد Seat table في الـ DB)

> **القرار المحدّث**: الـ `Seat` entity اتشالت من الـ DB. بدل ما نحفظ كل كرسي كـ row في الـ database، الـ layout بيتولد on-demand من الـ `HallTypeHelper` template وقت الـ booking. ده بيوفر storage ويبسّط الـ schema — الـ hall type نفسه كافي يحدد الـ layout الكامل.

```
// ❌ مش موجودة في الـ DB بعد كده
public class Seat { ... }
```

> الـ seat selection في الـ Booking phase هتشتغل على الـ template مباشرة — الـ booked seats بيتتتبعوا في جدول `Booking` أو `BookedSeat` مش في جدول `Seat` منفصل.

---

## 🧩 HallTypeHelper

القاعدة اللي بتحدد إيه الـ categories المسموح بيها والـ template الافتراضي بتتحط في **static helper في Core** — مش متفرقة في الـ UI أو الـ service.

```csharp
// Ticketa.Core/Helpers/HallTypeHelper.cs
public static class HallTypeHelper
{
    public static IReadOnlyList<SeatCategory> GetAllowedCategories(HallType type) => type switch
    {
        HallType.Standard => [SeatCategory.Regular, SeatCategory.VIP],
        HallType.IMAX     => [SeatCategory.Regular, SeatCategory.Premium],
        HallType.Gold     => [SeatCategory.Regular],
        _                 => []
    };

    public static HallTemplate GetTemplate(HallType type) => type switch
    {
        HallType.Standard => new HallTemplate
        {
            Rows       = 10,
            SeatsPerRow = 12,
            RowCategoryMap = BuildMap(regularRows: 8, premiumRows: 2,
                regular: SeatCategory.Regular, premium: SeatCategory.VIP)
        },
        HallType.IMAX => new HallTemplate
        {
            Rows        = 14,
            SeatsPerRow = 16,
            RowCategoryMap = BuildMap(regularRows: 10, premiumRows: 4,
                regular: SeatCategory.Regular, premium: SeatCategory.Premium)
        },
        HallType.Gold => new HallTemplate
        {
            Rows        = 6,
            SeatsPerRow = 8,
            RowCategoryMap = BuildMap(regularRows: 3, premiumRows: 3,
                regular: SeatCategory.GoldLounge, premium: SeatCategory.GoldRecliner)
        },
        _ => throw new ArgumentOutOfRangeException()
    };

    private static Dictionary<int, SeatCategory> BuildMap(
        int regularRows, int premiumRows,
        SeatCategory regular, SeatCategory premium)
    {
        var map = new Dictionary<int, SeatCategory>();

        for (int r = 1; r <= regularRows; r++)
            map[r] = regular;

        for (int r = regularRows + 1; r <= regularRows + premiumRows; r++)
            map[r] = premium;

        return map;
    }
}

// Ticketa.Core/Helpers/HallTemplate.cs
public class HallTemplate
{
    public int Rows { get; set; }
    public int SeatsPerRow { get; set; }
    public Dictionary<int, SeatCategory> RowCategoryMap { get; set; } = new();
}
```

---

## 🔧 Hall Service

### IHallService (Core)

```csharp
// Ticketa.Core/Interfaces/IHallService.cs
public interface IHallService
{
    Task<IEnumerable<HallDto>> GetAllAsync();
    Task<string?> CreateAsync(HallCreateDto dto);
    Task<bool> DeleteAsync(int id);
}
```

### HallService — CreateAsync (Infrastructure)

الـ service بتجيب الـ template عشان تحفظ `TotalRows` و`SeatsPerRow` على الـ hall للعرض — مش بتولد seat rows في الـ DB.

```csharp
// Ticketa.Infrastructure/Services/HallService.cs
public async Task<string?> CreateAsync(HallCreateDto dto)
{
    var template = HallTypeHelper.GetTemplate(dto.Type);

    var hall = new Hall
    {
        Name        = dto.Name,
        Type        = dto.Type,
        TotalRows   = template.Rows,
        SeatsPerRow = template.SeatsPerRow
        // ❌ مفيش seat generation هنا — الـ layout بيتجيب من الـ template on-demand
    };

    await _uow.Halls.CreateAsync(hall);
    await _uow.SaveAsync();

    return null; // null = success, string = error message
}
```

> الـ `RowCategoryMap` في الـ template هو المصدر الوحيد للـ seat layout — بيتستخدم وقت الـ booking مش وقت الـ hall creation.

---

## 💰 SeatCategoryPrice (اختياري — للـ Booking Phase)

```csharp
// Ticketa.Core/Entities/SeatCategoryPrice.cs
public class SeatCategoryPrice
{
    public int Id { get; set; }
    public HallType HallType { get; set; }
    public SeatCategory Category { get; set; }
    public decimal Price { get; set; }
}
```

ده بيخلي الـ pricing قابل للتعديل من الـ admin بدل ما يكون hardcoded. بيتبنى في الـ Booking phase مش دلوقتي.

---

## 📐 DTOs

```csharp
// Ticketa.Core/DTOs/Halls/HallCreateDto.cs
public class HallCreateDto
{
    public string Name { get; set; } = string.Empty;
    public HallType Type { get; set; }
}
```

```csharp
// Ticketa.Core/DTOs/Halls/HallDto.cs
public class HallDto
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public HallType Type { get; set; }
    public int TotalRows { get; set; }
    public int SeatsPerRow { get; set; }
    public int TotalSeats => TotalRows * SeatsPerRow;
}
```

---

## 🔄 Admin Flow

```
Create Hall
  └─ Admin يختار: Name + HallType (Standard / IMAX / Gold)
       └─ Service تجيب الـ template للـ type ده
            └─ Seats بتتولد أوتوماتيك (rows × seatsPerRow)
                 └─ كل seat بياخد الـ category بتاعته من الـ RowCategoryMap
                      └─ Hall + Seats بيتحفظوا في transaction واحدة
```

---

## 🗺️ Features المخططة / المتفق عليها (Updated)

- [x] Movie Import (TMDB — popular list + search + trailer fetch)
- [x] Movie Index Table (DataTables.js — server-side, segmented filter, search, ordering)
- [x] Genre — many-to-many مع Movie، بتتاخد تلقائياً من TMDB وقت الـ import
- [x] Showtime Scheduling — CreateAsync مع buffer check (15 min)
- [x] Hall Module — HallType enum، Fixed Template، Seat auto-generation
- [x] Hall CRUD — Create + Index + Delete. الـ Seat entity اتشالت واتعوضت بـ predefined templates جوا `HallTypeHelper` — مفيش seat rows في الـ DB، الـ layout بيتولد on-demand من الـ template وقت الـ booking
- [x] User Authentication — ASP.NET Identity، custom `AppUser`، email verification بـ 6-digit code، Gmail SMTP عبر MailKit
- [ ] Movie Management (Edit / Archive)
- [ ] Seat Selection UI — customer بيختار كرسيه من الـ map وقت الـ booking (layout بيتجيب من الـ template مش من الـ DB)
- [ ] Booking Flow
- [ ] Admin Dashboard
- [ ] SeatCategoryPrice — pricing config per hall type + category
- [ ] Payment (مش متحدد بعد)

---

## 📝 ملاحظات للمستقبل

- الـ `HallTypeHelper` هو المصدر الوحيد للحقيقة بخصوص الـ templates والـ allowed categories — أي تغيير في الـ layout بيتعمل هنا بس
- لو hall معين محتاج layout مختلف → نضيف override flag على الـ `Hall` entity ونعمل admin UI لتعديل الـ seats يدوياً — ده additive مش rewrite
- الـ `SeatCategoryPrice` بيتبنى في الـ Booking phase — مش محتاجه دلوقتي
- الـ seat generation بتحصل مرة واحدة وقت الـ create — مش on-the-fly
- الـ `Seat.Row` و`Seat.Number` كلهم 1-based — consistent مع الـ UI اللي هيعرضهم للـ customer

---

*آخر تحديث: April 2026 — Hall & Seat module design decisions added*
