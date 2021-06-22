public with sharing class BinanceApi {
    public BinanceApi() {
    }

    @AuraEnabled
    public static String getRecordTypeId(String orderType){
        String rTypeId = Schema.SObjectType.Ordem__c.getRecordTypeInfosByDeveloperName().get(orderType).getRecordTypeId();
        return rTypeId;
    }

    @AuraEnabled
    public static String getPrice(String mercadoId){
        try {
            Mercado__c mercado = [SELECT id, MoedaPrimaria__c, MoedaSecundaria__c from Mercado__c where id = :mercadoId];
            Moeda__c moedaPrimaria = [select Name from Moeda__c where id = :mercado.MoedaPrimaria__c];
            Moeda__c moedaSecundaria = [select Name from Moeda__c where id = :mercado.MoedaSecundaria__c];
            String pair = moedaPrimaria.Name + moedaSecundaria.Name;
            pair = pair.replace('USD', 'USDT');
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.binance.com/api/v3/ticker/price?symbol=' + pair);
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                system.debug(response.getBody());
                SymbolPrice sp = (SymbolPrice)JSON.deserialize(response.getBody(), SymbolPrice.class);
                return String.valueOf(sp.price);
            } else {
                return 'Erro ao acessar a API do Binance';
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @future (callout=true)
    public static void getPrice(){
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.binance.com/api/v3/ticker/price');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                List<SymbolPrice> spList = (List<SymbolPrice>)JSON.deserialize(response.getBody(), List<SymbolPrice>.class);
        
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
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public Class SymbolPrice{
        public String symbol;
        public decimal price;
    }
}
