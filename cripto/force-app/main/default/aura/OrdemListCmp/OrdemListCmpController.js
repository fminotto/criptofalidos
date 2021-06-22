({
    handleInit: function(component, event, helper) {
        component.set('v.columns', [
            { label: 'Ordem', fieldName: 'Name', type: 'text' },
            { label: 'Tipo', fieldName: 'Type__c', type: 'text' },
            { label: 'Quantidade', fieldName: 'Quantidade__c', type: 'number', typeAttributes: { maximumSignificantDigits: 6 } },
            { label: 'Preço', fieldName: 'Preco__c', type: 'number', typeAttributes: { maximumSignificantDigits: 6 } },
            { label: 'Total', fieldName: 'Total__c', type: 'number', typeAttributes: { maximumSignificantDigits: 6 } },
            { label: 'À Mercado', fieldName: 'OperacaoMercado__c', type: 'boolean' },
            { label: 'Validade', fieldName: 'ValidadeOrdem__c', type: 'date' },
            { label: 'Status', fieldName: 'Status__c', type: 'text' }
        ]);

        var action = component.get('c.getOrdemList');
        action.setParams({ "mercadoId": component.get('v.recordId') });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var orderList = response.getReturnValue();
                component.set('v.data', orderList);


            } else {
                console.log('Erro: ' + JSON.stringify(response.getError()));
            }
        });

        $A.enqueueAction(action);
    }
})