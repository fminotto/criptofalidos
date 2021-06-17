public with sharing class BinanceApi {
    public BinanceApi() {
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
                mercado.CotacaoAtual__c = sp.price;
                update mercado;
                return moedaSecundaria.Name + ' ' + String.valueOf(sp.price);
            } else {
                return 'Erro ao acessar a API do Binance';
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private Class SymbolPrice{
        public String symbol;
        public decimal price;
    }
}
