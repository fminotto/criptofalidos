trigger HistoricoPrecosTrigger on Historico_de_Precos__c (after insert) 
{
    new HistoricoPrecosTriggerHandler().run();  
}