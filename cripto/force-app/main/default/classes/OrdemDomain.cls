public with sharing class OrdemDomain {
    private Ordem__c ordem;
    private List<Ativo_da_Carteira__c> ativosCarteiras;

    public OrdemDomain(Ordem__c ordem) {
        this.ordem = ordem;
    }

    public void recalculaTotal() {
        this.validaQuantidade();   
        this.validaPreco();   
        this.ordem.Total__c = this.ordem.Quantidade__c * this.ordem.Preco__c;
    }

    public void recalculaQuantidade(){
        this.validaPreco(); 
        if (this.isFieldNull(Schema.Ordem__c.Total__c))
        {
            this.ordem.Quantidade__c = this.ordem.Total__c / this.ordem.Preco__c; 
        }   
    }

    public void validaPreco()
    {
        if(this.isFieldNull(Schema.Ordem__c.Preco__c)) {
            this.ordem.addError('Preço deve ser informado');    
        }
    }

    public void validaQuantidade()
    {
        if(this.isFieldNull(Schema.Ordem__c.Quantidade__c)) {
            this.ordem.addError('Quantidade deve ser informado');    
        }
    }  

    public void verificaSaldo()
    {
        if (this.ordem.Status__c == 'Executada') {
            if ((this.ativosCarteiras == null)||(this.ativosCarteiras.size() == 0)) {
                this.ativosCarteiras = [select Carteira__c, Name, saldo__c from Ativo_da_Carteira__c];
            }
            
            decimal quantidade = ((this.ordem.Type__c == 'Buy') ? this.ordem.Total__c : this.ordem.Quantidade__c);
            decimal saldo = getSaldoMoedaCarteira(((this.ordem.Type__c == 'Buy') ? this.ordem.MoedaSecundaria__c : this.ordem.MoedaPrimaria__c), this.ordem.Carteira__c);
            if (saldo - quantidade < 0) {
                this.ordem.addError('Saldo Insuficiente.');
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

    public Boolean isFieldDifferent(sObjectField field, Ordem__c compareOrder) {
        return ordem.get(field) != compareOrder.get(field);
    }

    public Boolean isFieldNull(sObjectField field) {
        return ordem.get(field) == null;
    }

}
