public with sharing class SchedulerGetPrecoHelper {
    public SchedulerGetPrecoHelper() {

    }

    @future (callout=true)
    public static void atualziaCotacaoAtualTodosMercadosAtivos(){
        List<BinanceApi.SymbolPrice> spList = BinanceApi.getPrice();
        Map<String, decimal> priceMap = new Map<String, decimal>();
        for(BinanceApi.SymbolPrice sp : spList){
            priceMap.put(sp.symbol, sp.price);
        }
        
        List<Historico_de_Precos__c> historicoList = new List<Historico_de_Precos__c>();
        for(Mercado__c mercado : [SELECT ID, Pair__c 
                                            FROM Mercado__c 
                                            WHERE Ativo__c = true 
                                            AND Pair__c in :priceMap.keySet()]){
            historicoList.add(new Historico_de_Precos__c(Mercado__c = mercado.Id, Preco__c = priceMap.get(mercado.Pair__c)));
        }

        if(historicoList.size()>0){
            insert historicoList;
        }  
    }
}
