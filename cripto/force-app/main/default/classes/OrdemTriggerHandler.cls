public with sharing class OrdemTriggerHandler extends TriggerHandler
{
    public OrdemTriggerHandler() {}

    protected override void beforeInsert()
    {
        for (Ordem__c o : (List<Ordem__c>)Trigger.New)
        {
            OrdemDomain ordem = new OrdemDomain(o);    
            ordem.verificaSaldo();
            if(ordem.isFieldNull(Schema.Ordem__c.Total__c)) {
                ordem.RecalculaTotal();
            } else {
                ordem.RecalculaQuantidade();
            }
        }
    }

    protected override void beforeUpdate()
    {
        for (Ordem__c o : (List<Ordem__c>)Trigger.New)
        {
            OrdemDomain ordem = new OrdemDomain(o); 
            ordem.verificaSaldo();

            Ordem__c oOld = (Ordem__c)Trigger.oldMap.get(o.Id);
            if(ordem.isFieldDifferent(Schema.Ordem__c.Total__c, oOld)){
                o.addError('O Total não pode ser alterado');
            }

            if(ordem.isFieldDifferent(Schema.Ordem__c.Quantidade__c, oOld)||
               ordem.isFieldDifferent(Schema.Ordem__c.Preco__c, oOld) ){
                ordem.validaQuantidade();   
                ordem.validaPreco(); 
                ordem.RecalculaTotal();
            }
        }
    }
}