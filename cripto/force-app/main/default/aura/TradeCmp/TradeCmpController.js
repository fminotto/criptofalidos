({
    retrivePrice: function(component, event, helper) {
        helper.retrivePrice(component, event, helper);
    },

    handleChange: function(component, event, helper) {
        component.set('v.opMercado', !event.getParam('checked'));
        helper.retrivePrice(component, event, helper);
    },

    handleSuccess: function(component, event, helper) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": 'Sucesso',
            "message": 'Registro inserido!',
            "type": 'success',
            "duration": 3000
        });
        toastEvent.fire();

        component.find("ordField").forEach(function(f) {
            f.reset();
        });

        /*var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            //"recordId": component.get('v.recordId'), //este atualiza a página toda
            "recordId": event.getParams().response.id, //este navega para o registro criado
            "slideDevName": "detail"
        });
        navEvt.fire();*/

        let ordemEvt = $A.get("e.c:OrdemEvent");
        ordemEvt.setParams({
            "Context": "TradeCmp"
        });
        ordemEvt.fire();
    },

    handleOrder: function(component, event, helper) {

        event.preventDefault();
        var fields = event.getParam('fields');

        var action = component.get('c.getRecordTypeId');
        action.setParams({ "orderType": fields["Type__c"] });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var rtId = response.getReturnValue();
                fields["RecordTypeId"] = rtId;
                if (fields["OperacaoMercado__c"] == true) {
                    fields["Status__c"] = 'Executada';
                } else {
                    fields["Status__c"] = 'Aguardando';
                }
                component.find(fields["Type__c"] + 'Form').submit(fields);
            } else {
                alert('Erro: ' + JSON.stringify(response.getError()));
            }
        });

        $A.enqueueAction(action);
    },

    handleQuantidadePrecoChange: function(component, event, helper) {
        let price = component.get('v.price');
        let quantidade = component.get('v.quantidade');
        component.set('v.total', price * quantidade);
    },

    handleTotalChange: function(component, event, helper) {
        let price = component.get('v.price');
        let total = component.get('v.total');
        component.set('v.quanriade', total / quantidade);
    }

})