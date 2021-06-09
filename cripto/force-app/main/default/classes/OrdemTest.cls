@isTest
public class OrdemTest {
    @isTest static void IncluiOrdemSemSaldo() {
        // Test data setup
        // Create one account with one opportunity by calling a utility method
        Ordem__c ordem = new Ordem__c(Status__c='Executada', Id='a015e00000BkfkPAAR');
        
        // Perform test
        Test.startTest();
        Database.SaveResult result = Database.update(ordem, false);
        system.debug(result);
        Test.stopTest();
        // Verify that the deletion should have been stopped by the trigger,
        // so check that we got back an error.
        System.assert(!result.isSuccess());
        System.assertEquals('Saldo Insuficiente.', result.getErrors()[0].getMessage());
    }
}