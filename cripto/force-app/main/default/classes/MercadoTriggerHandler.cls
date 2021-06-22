public with sharing class MercadoTriggerHandler extends TriggerHandler {
    public MercadoTriggerHandler() {
    }

    protected override void afterUpdate() 
    {
        this.executaOrdem();
    }

    private void executaOrdem(){
        List<Ordem__c> listUpdate = new List<Ordem__c>();
        for(Ordem__c ordem : [select id, Preco__c, Mercado__c  
                                from Ordem__c 
                               where Mercado__c in :Trigger.newMap.keySet() 
                                 and status__c = 'Aguardando']){
            decimal precoNovo = recuperaPrecoNovo(ordem.Mercado__c);
            decimal precoAntigo = recuperaPrecoAntigo(ordem.Mercado__c);     
            if(precoAntigo<>precoNovo) {
                if((ordem.Preco__c >= precoAntigo && ordem.Preco__c <= precoNovo) || (ordem.Preco__c <= precoAntigo && ordem.Preco__c >= precoNovo)) 
                {
                    listUpdate.add(new Ordem__c(id=ordem.id, status__c = 'Executada', Preco__c = precoNovo));
                }
            } 
        }

        if(listUpdate.size()>0){
            update listUpdate;
        }
    }

    private decimal recuperaPrecoNovo(string id) {
        Mercado__c m = (Mercado__c)trigger.newMap.get(id);
        return m.CotacaoAtual__c;
    }

    private decimal recuperaPrecoAntigo(string id) {
        Mercado__c m = (Mercado__c)trigger.oldMap.get(id);
        return m.CotacaoAtual__c;
    }
}