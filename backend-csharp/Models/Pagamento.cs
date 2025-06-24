using System;

namespace PagamentosApp.Models
{
    public class Pagamento
    {
        public int Id { get; set; }
        public int PessoaId { get; set; }
        public Pessoa Pessoa { get; set; } = null!;
        public DateTime DataPagamento { get; set; }
        public int Mes { get; set; }
        public int Ano { get; set; }
    }
}
