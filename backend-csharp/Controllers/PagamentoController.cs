using Microsoft.AspNetCore.Mvc;
using PagamentosApp.Models;
using System;
using System.Linq;

namespace PagamentosApp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PagamentoController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PagamentoController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("{mes}")]
        public IActionResult GetPorMes(int mes)
        {
            var pagamentos = _context.Pagamentos
                .Where(p => p.Mes == mes)
                .ToList();
            return Ok(pagamentos);
        }


        [HttpPost]
        public IActionResult Post([FromBody] Pagamento pagamento)
        {
            pagamento.DataPagamento = DateTime.Now;
            _context.Pagamentos.Add(pagamento);
            _context.SaveChanges();
            return Created($"api/pagamento/{pagamento.Id}", pagamento);
        }
    }
}
