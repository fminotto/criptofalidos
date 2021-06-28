({
    retrivePrice: function(component, event, helper) {
        var action = component.get('c.getPricePair');
        action.setParams({ "mercadoId": component.get('v.recordId') });

        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state == "SUCCESS") {
                console.log(response.getReturnValue());
                component.set('v.price', response.getReturnValue());
                component.set('v.priceOrder', response.getReturnValue());
            } else {
                alert('Erro: ' + JSON.stringify(response.getError()));
            }
        });

        $A.enqueueAction(action);
    }
})