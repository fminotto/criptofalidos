@isTest
public class HistoricoPrecosTest {
    @TestSetup
    static void makeData(){
        Account account = new Account(Name='Teste');
        insert account;
        Carteira__c carteira = new Carteira__c(Conta__c = account.id);
        insert carteira;
        Ativo_da_Carteira__c ativoCarteira1 = new Ativo_da_Carteira__c(Name='TADA', Carteira__c = carteira.Id);
        insert ativoCarteira1;
        Ativo_da_Carteira__c ativoCarteira2 = new Ativo_da_Carteira__c(Name='TBRL', Carteira__c = carteira.Id);
        insert ativoCarteira2;
        Moeda__c moedaPrimaria = new Moeda__c(Name='TADA');
        Moeda__c moedaSecundaria = new Moeda__c(Name='TBRL');
        insert moedaPrimaria;
        insert moedaSecundaria;
        Mercado__c mercado = new Mercado__c(Name='TADA/TBRL', MoedaPrimaria__c=moedaPrimaria.Id, MoedaSecundaria__c=moedaSecundaria.Id);
        insert mercado;      
    }

    @isTest 
    static void inserePrecosEmMassa() {
        List<Historico_de_Precos__c> listHistorico = new List<Historico_de_Precos__c>();
        Mercado__c mercado = [SELECT Id FROM Mercado__c WHERE Name='TADA/TBRL' LIMIT 1];
        for(integer i = 0; i <= 300; i++) {
            listHistorico.add(new Historico_de_Precos__c(Mercado__c=mercado.id, Preco__c=i*10));
        }

        Test.startTest();
        Database.SaveResult[] results = Database.insert(listHistorico, false);
        Test.stopTest();        

        for (Database.SaveResult result : results){
            System.assert(result.isSuccess());
        }
    }
}
