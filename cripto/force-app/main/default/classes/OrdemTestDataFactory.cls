public with sharing class OrdemTestDataFactory {
    public static List<Account> CriaOrdensCompra(Integer numOrdens) {
        List<Ordem__c> ordens = new List<Ordem__c>();
        
        for(Integer i=0;i<numOrdens;i++) {
            Ordem__c o = new Ordem__c();
            ordens.add(a);
        }
        insert ordens;
        
        return ordens;
    }
}
