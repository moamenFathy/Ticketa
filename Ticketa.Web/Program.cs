using Microsoft.AspNetCore.Identity;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Infrastructure.Extensions;
using Ticketa.Infrastructure.Service;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

builder.Services.AddTicketaInfrastructure(builder.Configuration);
builder.Services.AddScoped<IAdminManagementService, AdminManagementService>();
builder.Services.AddScoped<IRoleService, RoleService>();

builder.Services.ConfigureApplicationCookie(opt =>
{
  opt.LoginPath = "/Auth/Login";
});

builder.Services.Configure<CookiePolicyOptions>(options =>
{
  options.Secure = CookieSecurePolicy.Always;  // forces Secure on all cookies
  options.MinimumSameSitePolicy = SameSiteMode.Lax;
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

app.UseCookiePolicy();
app.UseAuthentication();
app.UseAuthorization();

app.MapStaticAssets();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Dashboard}/{action=Index}/{id?}");

if (app.Environment.IsDevelopment())
{
  app.MapGet("/env", (IWebHostEnvironment env) => new { env.EnvironmentName });
}

//using (var scope = app.Services.CreateScope())
//{
//  var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<AppRole>>();
//  string[] roles = ["Admin", "User"];
//  foreach (var role in roles)
//  {
//    if (!await roleManager.RoleExistsAsync(role))
//      await roleManager.CreateAsync(new AppRole(role));
//  }
//}

app.Run();