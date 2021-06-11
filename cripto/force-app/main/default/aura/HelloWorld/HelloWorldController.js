({
    handleClick: function(cmp, event, helper) {
        var uName = cmp.get('v.nome');
        alert('Bem vindo ' + uName);
        cmp.set('v.nome', 'World');
    }
})