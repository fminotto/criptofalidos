public with sharing class ExemploBatchable implements Database.Batchable<sObject> {
    //public ExemploBatchable() {}
    public Database.QueryLocator start(Database.BatchableContext bc) {
        system.debug('start');
        return database.getQueryLocator('SELECT id, Revisao__c FROM Historico_de_Precos__c');
    }

    public void execute(Database.BatchableContext BC,  List<Historico_de_Precos__c> scope){
        system.debug('execute');
        system.debug(scope);
        system.debug('Quantidade de Históricos atualziados: ' + scope.size());
        
        for(Historico_de_Precos__c sc : scope) {
            if(sc.Revisao__c == null) {
                sc.Revisao__c = 0;
            } else {
                sc.Revisao__c++;
            }
        }

        update scope;
    }

    public void finish(Database.BatchableContext BC){
        system.debug('finish');
    }
    
}
