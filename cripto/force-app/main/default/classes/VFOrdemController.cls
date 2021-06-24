public class VFOrdemController {
    public List<Ordem__c> ordemList {get; set; }
    public String cotacao_atual {get; set; }
    public Transient List<BinanceApi.SymbolPrice> spList {get; set; }
    public DateTime dataAtual {get; set; }

    public VFOrdemController() {

    }

    public VFOrdemController(ApexPages.StandardController controller) {
        Mercado__c mercado = (Mercado__c)controller.getRecord();
        ordemList = [SELECT Id, Name, OperacaoMercado__c, toLabel(Type__c), Status__c, Quantidade__c, Preco__c, Total__c , ValidadeOrdem__c
                       FROM Ordem__c 
                      WHERE Mercado__c = :mercado.id];

        for(Ordem__c o : ordemList) {
           o.Quantidade__c = o.Quantidade__c.setScale(6);
           o.Total__c = o.Total__c.setScale(6);
        }
                    
        cotacao_atual = BinanceApi.getPrice(mercado.id);
        spList = BinanceApi.getPrice();

        for(BinanceApi.SymbolPrice sp : spList) {
            sp.price = sp.price.setScale(6);
         }

         dataAtual = DateTime.now();
    }

}
