global with sharing class SchedulerGetPreco implements Schedulable {
    global SchedulerGetPreco() {}


    global void execute(SchedulableContext context){
        BinanceApi.getPrice();
        reagendaMinuto();
    }

    private void reagendaMinuto() {
        DateTime nextRunTime = DateTime.now().addMinutes(1);
        
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
            nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
            nextRunTime.month() + ' ? ' + nextRunTime.year();
        System.schedule(SchedulerGetPreco.class.getName() + '-' + nextRunTime.format(), cronString, new SchedulerGetPreco());
    }
}
