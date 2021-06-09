trigger ValidaSaldo on Ordem__c (before update) {
  for (Ordem__c o : Trigger.New) {
      if ((o.Status__c=='Executada')) {
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