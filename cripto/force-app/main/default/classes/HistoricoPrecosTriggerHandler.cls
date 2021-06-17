public with sharing class HistoricoPrecosTriggerHandler extends TriggerHandler{
    public HistoricoPrecosTriggerHandler() {

    }

    protected override void afterInsert()
    {
        this.atualizaPrecoMercado();
    }

    private void atualizaPrecoMercado() {
        Map<id, Mercado__c> mapUpdate = new Map<id, Mercado__c>();
        for (Historico_de_Precos__c hp : (List<Historico_de_Precos__c>)Trigger.New) {
            mapUpdate.put(hp.Mercado__c, new Mercado__c(id=hp.Mercado__c, CotacaoAtual__c=hp.preco__c));
        }
        update mapUpdate.values();
    }
}