using DotNetEnv;

Env.Load();

var builder = WebApplication.CreateBuilder(args);

//Agregamos los servicos de el contenedor
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();
builder.Services.AddControllers();

builder.Services.AddHttpClient();   // Registramos el servicio HttpClient para poder inyectarlo en el ConsultController

//Registro del repositorio para poder inyectarlo en el controlador
builder.Services.AddScoped<backend_II.Database.ProductRepository>();

// Registro de servicios de ProductsServices para poder inyectarlo en el ProductsController
builder.Services.AddScoped<backend_II.Services.ProductsServices>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.MapControllers();

app.Run();
