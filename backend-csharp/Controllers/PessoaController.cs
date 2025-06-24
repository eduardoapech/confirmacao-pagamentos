using Microsoft.AspNetCore.Mvc;
using PagamentosApp.Models;
using System.Linq;

namespace PagamentosApp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PessoaController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PessoaController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Get() => Ok(_context.Pessoas.ToList());

        [HttpPost]
        public IActionResult Post([FromBody] Pessoa pessoa)
        {
            _context.Pessoas.Add(pessoa);
            _context.SaveChanges();
            return Created($"api/pessoa/{pessoa.Id}", pessoa);
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var pessoa = _context.Pessoas.Find(id);
            if (pessoa == null) return NotFound();
            _context.Pessoas.Remove(pessoa);
            _context.SaveChanges();
            return NoContent();
        }
    }
}
