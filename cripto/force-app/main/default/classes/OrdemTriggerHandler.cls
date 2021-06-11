public with sharing class OrdemTriggerHandler extends TriggerHandler
{
    public OrdemTriggerHandler() {}

    protected override void beforeInsert()
    {
        for (Ordem__c o : (List<Ordem__c>)Trigger.New)
        {
            this.verificaSaldo(o);
            this.validaPreco(o);        

            /*Calculo do total*/
            if (o.Total__c != null)
            {
                this.validaQuantidade(o);    
                o.Total__c = o.Quantidade__c * o.Preco__c;
            }
            // Calculo da quantidade
            else 
            {
                o.Quantidade__c = o.Total__c / o.Preco__c;           
            }
        }
    }

    protected override void beforeUpdate()
    {
        for (Ordem__c o : (List<Ordem__c>)Trigger.New)
        {
            this.verificaSaldo(o);
            this.validaPreco(o);
            this.validaQuantidade(o);

            Ordem__c oOld = (Ordem__c)Trigger.oldMap.get(o.Id);
            /*verifica se o total foi alterado*/
            if ( (o.Total__c != oOld.Total__c) && 
                (o.Total__c != o.Quantidade__c * o.Preco__c)){
                o.addError('O Total não pode ser alterado');
            }

            /*Verifica se mudou a quantidade ou o valor e recalcula o total*/
            if ((o.Quantidade__c != oOld.Quantidade__c) || 
                (o.Preco__c != oOld.Preco__c))
            {
                o.Total__c = o.Quantidade__c * o.Preco__c;
            }
        }
    }

    private void validaPreco(Ordem__c o)
    {
        if(o.Preco__c == null) {
            o.addError('Preço deve ser informado');    
        }
    }

    private void validaQuantidade(Ordem__c o)
    {
        if(o.Quantidade__c == null) {
            o.addError('Quantidade deve ser informado');    
        }
    }    
    
    private void verificaSaldo(Ordem__c o)
    {
        if (o.Status__c == 'Executada') {
            List<Ativo_da_Carteira__c> a = new List<Ativo_da_Carteira__c>();
            decimal Quantidade = 0;
            if (o.Type__c == 'Buy') {
                a = [select id, saldo__c from Ativo_da_Carteira__c where Name = :o.MoedaSecundaria__c and Carteira__c = :o.Carteira__c];
                Quantidade = o.Total__c;
            } else {
                a = [select id, saldo__c from Ativo_da_Carteira__c where Name = :o.MoedaPrimaria__c and Carteira__c = :o.Carteira__c];
                Quantidade = o.Quantidade__c;
            }
            
            if(!a.isEmpty()) {
                if (a[0].Saldo__c - Quantidade < 0) {
                    o.addError('Saldo Insuficiente.');
                }  
            }
        }
    }
}
