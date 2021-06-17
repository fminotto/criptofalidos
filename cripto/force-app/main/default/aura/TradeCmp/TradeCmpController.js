({
    retrivePrice: function(component, event, helper) {
        var action = component.get('c.getPrice');
        action.setParams({ "mercadoId": component.get('v.recordId') });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set('v.price', response.getReturnValue())
            } else {
                alert('Erro: ' + JSON.stringify(response.getError()));
            }
        });

        $A.enqueueAction(action);
    },

    handleChange: function(component, event, helper) {
        console.log(JSON.stringify(event));
        component.set('v.opMercado', !event.getParam('checked'));
    },

    handleOrder: function(component, event, helper) {
        alert('codigo salvar da ordem');
    }
})