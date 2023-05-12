/**
 * @author: Banuchandar
 * @date: 11/05/2023
 */

public without sharing class TriggerObjectToEventsToHandlers {
    private Map<String, TriggerEventsToTriggerHandlers> typeToEventHandlers;

    public TriggerObjectToEventsToHandlers() {
        typeToEventHandlers = new Map<String, TriggerEventsToTriggerHandlers>();
    }

    public void putAll(List<Trigger_Handler__mdt> triggerHandlers) {
        for(Trigger_Handler__mdt thisTriggerHandler : triggerHandlers) {
            TriggerEventsToTriggerHandlers theseTriggerHandlers = typeToEventHandlers.get(thisTriggerHandler.sObject__c);

            if(theseTriggerHandlers == null) {
                theseTriggerHandlers = new TriggerEventsToTriggerHandlers();

                typeToEventHandlers.put(thisTriggerHandler.sObject__c, theseTriggerHandlers);
            }

            theseTriggerHandlers.put(thisTriggerHandler);
        }
    }

    public TriggerEventsToTriggerHandlers get(String sObjectName) {
        return typeToEventHandlers.get(sObjectName);
    }
}