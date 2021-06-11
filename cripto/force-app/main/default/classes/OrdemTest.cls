@isTest
public class OrdemTest {
    @isTest static void InsereOrdemSemTotal() {
        // Test data setup
        // Create one account with one opportunity by calling a utility method
        Moeda__c moedaPrimaria = new Moeda__c(Name='ADA');
        Moeda__c moedaSecundaria = new Moeda__c(Name='BRL');
        Mercado__c mercado = new Mercado__c(Name='ADA/BRL', MoedaPrimaria__c=moedaPrimaria.Id, MoedaSecundaria__c=moedaSecundaria.Id);
        Ordem__c ordem = new Ordem__c(Status__c='Aguardando', Type__c='Buy', Quantidade__c=1, Preco__c=10, Mercado__c=mercado.Id);
        
        // Perform test
        Test.startTest();
        Database.SaveResult result = Database.insert(ordem, false);
        Test.stopTest();
        // Verify that the deletion should have been stopped by the trigger,
        // so check that we got back an error.
        System.assert(result.isSuccess());
    } 


    @isTest static void IncluiOrdemSemSaldo() {
        // Test data setup
        // Create one account with one opportunity by calling a utility method
        Ordem__c ordem = new Ordem__c(Status__c='Executada', Id='a015e00000BkfkPAAR');
        
        // Perform test
        Test.startTest();
        Database.SaveResult result = Database.update(ordem, false);
        Test.stopTest();
        // Verify that the deletion should have been stopped by the trigger,
        // so check that we got back an error.
        System.assert(!result.isSuccess());
        System.assertEquals('Saldo Insuficiente.', result.getErrors()[0].getMessage());
    }
}