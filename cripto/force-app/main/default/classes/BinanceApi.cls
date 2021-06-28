public with sharing class BinanceApi {
    public BinanceApi() {
    }

    @AuraEnabled
    public static String getRecordTypeId(String orderType){
        String rTypeId = Schema.SObjectType.Ordem__c.getRecordTypeInfosByDeveloperName().get(orderType).getRecordTypeId();
        return rTypeId;
    }

    @AuraEnabled
    public static String getPricePair(String mercadoId){
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
            
                return sp.price;
            } else {
                return 'Erro ao acessar a API do Binance';
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<SymbolPrice> getPrice(){
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.binance.com/api/v3/ticker/price');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                List<SymbolPrice> spList = (List<SymbolPrice>)JSON.deserialize(response.getBody(), List<SymbolPrice>.class);
                
                return spList;
            }  else {
                return null;
            }           
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled(cacheable=true)
    public static List<SymbolPrice> getPriceFiltered(String searchKey){
        List<SymbolPrice> assetList = getPrice();
        List<SymbolPrice> assetListResponse = new List<SymbolPrice>();
        for(SymbolPrice asset : assetList){
            if(asset.symbol.startsWithIgnoreCase(searchKey)){
                assetListResponse.add(asset);
            }
        }

        return assetListResponse;
    }
    
    public Class SymbolPrice{
        @AuraEnabled
        public String symbol {get; set;}
        @AuraEnabled
        public String price {get; set;}
    }
}
