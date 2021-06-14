public with sharing class OrdemTriggerHandler extends TriggerHandler
{

    List<Ativo_da_Carteira__c> ativosCarteiras;

    public OrdemTriggerHandler() {}

    protected override void beforeInsert()
    {
        for (Ordem__c o : (List<Ordem__c>)Trigger.New)
        {
            this.verificaSaldo(o);
            this.validaPreco(o);        

            /*Calculo do total*/
            if (o.Total__c == null)
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
            if ( ((oOld.Total__c != null) && (o.Total__c != oOld.Total__c)) && 
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
            if ((this.ativosCarteiras == null)||(this.ativosCarteiras.size() == 0)) {
                this.ativosCarteiras = [select Carteira__c, Name, saldo__c from Ativo_da_Carteira__c];
            }
            
            decimal quantidade = ((o.Type__c == 'Buy') ? o.Total__c : o.Quantidade__c);
            decimal saldo = getSaldoMoedaCarteira(((o.Type__c == 'Buy') ? o.MoedaSecundaria__c : o.MoedaPrimaria__c), o.Carteira__c);
            if (saldo - quantidade < 0) {
                o.addError('Saldo Insuficiente.');
            }  
        }
    }

    private decimal getSaldoMoedaCarteira(String moeda, id carteira) {
        decimal saldo = 0;
        for (Ativo_da_Carteira__c ativoCarteira : this.ativosCarteiras) {
            if ((ativoCarteira.Name == moeda) && (ativoCarteira.Carteira__c == carteira)) {
                saldo = ativoCarteira.saldo__c;
                break;
            }
        }
        return saldo;
    }
}