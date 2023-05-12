/**
 * @author: Banuchandar
 * @date: 11/05/2023
 */

public without sharing class TriggerEventsToTriggerHandlers {
    private Map<String, List<Trigger_Handler__mdt>> triggerEventsToTriggerHandlers;

    public TriggerEventsToTriggerHandlers() {
        triggerEventsToTriggerHandlers = new Map<String, List<Trigger_Handler__mdt>>();
    }

    public void put(Trigger_Handler__mdt thisTriggerHandler) {
        List<Trigger_Handler__mdt> theseTriggerHandlers = triggerEventsToTriggerHandlers.get(thisTriggerHandler.Event__c);

        if(theseTriggerHandlers == null) {
            theseTriggerHandlers = new List<Trigger_Handler__mdt>();

            triggerEventsToTriggerHandlers.put(thisTriggerHandler.Event__c, theseTriggerHandlers);
        }

        theseTriggerHandlers.add(thisTriggerHandler);
    }

    public List<Trigger_Handler__mdt> getTriggerHandlers(String event) {
        return triggerEventsToTriggerHandlers.get(event);
    }
}