
using Microsoft.AspNetCore.Mvc;

namespace backend_II.Controllers
{
    [ApiController]
    [Route("consult")]
    public class ConsultController : ControllerBase
    {
        private readonly IHttpClientFactory _httpClientFactory;

        public ConsultController(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }

        [HttpGet("pokemons")]
        public async Task<IActionResult> GetPokemons()
        {
            var client = _httpClientFactory.CreateClient();

            var response = await client.GetAsync(
                "https://pokeapi.co/api/v2/pokemon"
            );

            if (!response.IsSuccessStatusCode)
            {
                return StatusCode(
                    (int)response.StatusCode,
                    "Error al consultar PokeAPI."
                );
            }

            var json = await response.Content.ReadAsStringAsync();

            return Content(json, "application/json");
        }
    }
}
