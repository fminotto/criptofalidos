public with sharing class OrdemListController {
    @AuraEnabled
    public static List<Ordem__c> getOrdemList(String mercadoId) {
        return [select Id, Name, OperacaoMercado__c, Preco__c, Type__c, Status__c, Quantidade__c, Total__c, ValidadeOrdem__c 
                from Ordem__c where Mercado__c = :mercadoId
                order by createddate desc];
    }
}
