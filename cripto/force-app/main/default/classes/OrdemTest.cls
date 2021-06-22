@isTest
public class OrdemTest {
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
    
    @isTest static void insereOrdemSemTotal() {
        Mercado__c mercado = [SELECT Id FROM Mercado__c WHERE Name='TADA/TBRL' LIMIT 1];
        Carteira__c carteira = [SELECT Id FROM Carteira__c Order By Name desc LIMIT 1];
        Ordem__c ordem = new Ordem__c(Status__c='Aguardando', Type__c='Buy', Quantidade__c=1, Preco__c=10, Mercado__c=mercado.Id, Carteira__c=carteira.Id);
        // Perform test
        Test.startTest();
        Database.SaveResult result = Database.insert(ordem, false);
        Test.stopTest();

        System.assert(result.isSuccess());
    } 
    
    @isTest static void insereOrdemSemQuantidade() {
        Mercado__c mercado = [SELECT Id FROM Mercado__c WHERE Name='TADA/TBRL' LIMIT 1];
        Carteira__c carteira = [SELECT Id FROM Carteira__c Order By Name desc LIMIT 1];
        Ordem__c ordem = new Ordem__c(Status__c='Aguardando', Type__c='Buy', Total__c=100, Preco__c=10, Mercado__c=mercado.Id, Carteira__c=carteira.Id);
        // Perform test
        Test.startTest();
        Database.SaveResult result = Database.insert(ordem, false);
        Test.stopTest();

        System.assert(result.isSuccess());
    }
    
    @isTest static void insereOrdemSemQuantidadeeTotal() {
        Mercado__c mercado = [SELECT Id FROM Mercado__c WHERE Name='TADA/TBRL' LIMIT 1];
        Carteira__c carteira = [SELECT Id FROM Carteira__c Order By Name desc LIMIT 1];
        Ordem__c ordem = new Ordem__c(Status__c='Aguardando', Type__c='Buy', Preco__c=10, Mercado__c=mercado.Id, Carteira__c=carteira.Id);
        // Perform test
        Test.startTest();
        Database.SaveResult result = Database.insert(ordem, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
    }

    
    @isTest static void insereOrdemSemQuantidadeePreco() {
        Mercado__c mercado = [SELECT Id FROM Mercado__c WHERE Name='TADA/TBRL' LIMIT 1];
        Carteira__c carteira = [SELECT Id FROM Carteira__c Order By Name desc LIMIT 1];
        Ordem__c ordem = new Ordem__c(Status__c='Aguardando', Type__c='Buy', Total__c = 10, Preco__c=0, Quantidade__c=0, Mercado__c=mercado.Id, Carteira__c=carteira.Id);
        // Perform test
        Test.startTest();
        Database.SaveResult result = Database.insert(ordem, false);
        Test.stopTest();

        system.debug(result);
        System.assert(result.isSuccess());
        System.assertEquals('Quantidade deve ser informado', result.getErrors()[0].getMessage());
    }

    @isTest static void insereOrdemSemPreco() {
        Mercado__c mercado = [SELECT Id FROM Mercado__c WHERE Name='TADA/TBRL' LIMIT 1];
        Carteira__c carteira = [SELECT Id FROM Carteira__c Order By Name desc LIMIT 1];
        Ordem__c ordem = new Ordem__c(Status__c='Aguardando', Type__c='Buy', Total__c=100, Quantidade__c=10, Mercado__c=mercado.Id, Carteira__c=carteira.Id);
        // Perform test
        Test.startTest();
        Database.SaveResult result = Database.insert(ordem, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
    }
    
    @isTest static void alterarTotal() {
        Mercado__c mercado = [SELECT Id FROM Mercado__c WHERE Name='TADA/TBRL' LIMIT 1];
        Carteira__c carteira = [SELECT Id FROM Carteira__c Order By Name desc LIMIT 1];
        Ordem__c ordem = new Ordem__c(Status__c='Aguardando', Type__c='Buy', Total__c=100, Quantidade__c=10, Preco__c=1, Mercado__c=mercado.Id, Carteira__c=carteira.Id);
        insert ordem;
        //Altera o total da ordem
        ordem.Total__c = 1000;
        // Perform test
        Test.startTest();
        Database.SaveResult result = Database.update(ordem, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
    }
    
    @isTest static void incluiOrdemExecutadaSemSaldo() {
        Mercado__c mercado = [SELECT Id FROM Mercado__c WHERE Name='TADA/TBRL' LIMIT 1];
        Carteira__c carteira = [SELECT Id FROM Carteira__c Order By Name desc LIMIT 1];
        Ordem__c ordemCompra = new Ordem__c(Status__c='Executada', Type__c='Buy', Total__c = 10, Quantidade__c=1, Preco__c=10, Mercado__c=mercado.Id, Carteira__c=carteira.Id);
        Test.startTest();
        Database.SaveResult result = Database.insert(ordemCompra, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assertEquals('Saldo Insuficiente.', result.getErrors()[0].getMessage());
    }
}