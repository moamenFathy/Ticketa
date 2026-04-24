using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Polly;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Interfaces.Services;
using Ticketa.Core.Mapping;
using Ticketa.Core.Settings;
using Ticketa.Infrastructure.Data;
using Ticketa.Infrastructure.Repositories;
using Ticketa.Infrastructure.Service;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

builder.Services.AddDbContext<ApplicationDbContext>((opt) =>
{
  opt.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
});

builder.Services.AddIdentity<AppUser, IdentityRole>(opt =>
{
  opt.User.RequireUniqueEmail = true;
  opt.SignIn.RequireConfirmedEmail = true;
}).AddEntityFrameworkStores<ApplicationDbContext>().AddDefaultTokenProviders();

builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
builder.Services.AddScoped<IMoviesService, MoviesService>();
builder.Services.AddScoped<IAuthService, AuthService>();

// Email settings
builder.Services.Configure<EmailSettings>(builder.Configuration.GetSection("EmailSettings"));
builder.Services.AddScoped(sp => sp.GetRequiredService<IOptions<EmailSettings>>().Value);

builder.Services.AddOptions();
builder.Services.Configure<EmailSettings>(builder.Configuration.GetSection("EmailSettings"));

// Your service
builder.Services.AddScoped<IEmailService, EmailService>();


builder.Services.AddAutoMapper(cfg =>
{
  cfg.AddMaps(typeof(MovieProfile).Assembly);
});

builder.Services.AddHttpClient<ITmdbService, TmdbService>(opt =>
{
  opt.BaseAddress = new Uri("https://api.themoviedb.org/3/");
  opt.Timeout = TimeSpan.FromSeconds(10);
}).AddTransientHttpErrorPolicy(policy =>
    policy.WaitAndRetryAsync(3, retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt))));

builder.Services.ConfigureApplicationCookie(opt =>
{
  opt.LoginPath = "/Auth/Login";
});


var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
  app.UseExceptionHandler("/Home/Error");
  // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
  app.UseHsts();
}

app.UseHttpsRedirection();
app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapStaticAssets();

app.MapControllerRoute(
    name: "default",
    pattern: "{area=Customer}/{controller=Home}/{action=Index}/{id?}")
    .WithStaticAssets();

app.MapControllerRoute(
    name: "areas",
    pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();

using (var scope = app.Services.CreateScope())
{
  var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();

  string[] roles = ["Admin", "User"];

  foreach (var role in roles)
    if (!await roleManager.RoleExistsAsync(role))
      await roleManager.CreateAsync(new IdentityRole(role));
}