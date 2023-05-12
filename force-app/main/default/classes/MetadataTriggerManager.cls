/**
 * @author: Banuchandar
 * @date: 11/05/2023
 */

public without sharing class MetadataTriggerManager {

    public class ClassNotFoundException extends Exception {}

    @TestVisible
    private static List<Trigger_Handler__mdt> mockMetadata;

    private TriggerEventsToTriggerHandlers theseEventsToTriggerHandlers;
    private static TriggerObjectToEventsToHandlers sObjectNameToEventsToTriggerHandlers =
            new TriggerObjectToEventsToHandlers();

    public MetadataTriggerManager() {
        if(Trigger.new != null) {
            init(Trigger.new.getSObjectType());
        } else {
            init(Trigger.old.getSObjectType());
        }
    }

    public MetadataTriggerManager(sObjectType objectType) {
        init(objectType);
    }

    public void init(sObjectType objectType) {
        String sObjectName = objectType.getDescribe().getName();

        theseEventsToTriggerHandlers = sObjectNameToEventsToTriggerHandlers.get(sObjectName);

        if(theseEventsToTriggerHandlers == null) {
            if(Test.isRunningTest() && mockMetadata != null) {
                sObjectNameToEventsToTriggerHandlers.putAll(mockMetadata);
            } else {
                sObjectNameToEventsToTriggerHandlers.putAll(
                [SELECT DeveloperName, NamespacePrefix, Event__c, sObject__c, Class_Name__c, Order__c
                FROM Trigger_Handler__mdt
                WHERE sObject__c = :sObjectName AND Active__c = true
                ORDER BY Order__c ASC]);
            }
            theseEventsToTriggerHandlers = sObjectNameToEventsToTriggerHandlers.get(objectType.getDescribe().getName());
        }
    }

    public static String triggerFlagsToString(boolean isBefore, boolean isUpdate, boolean isInsert, boolean isDelete, boolean isUndelete) {
        String returnVal = isBefore ? 'Before' : 'After';

        if(isInsert) {
            returnVal += 'Insert';
        } else if(isUpdate) {
            returnVal += 'Update';
        } else if(isDelete) {
            returnVal += 'Delete';
        } else {
            returnVal += 'Undelete';
        }

        return returnVal;
    }

    public void handle() {
        handle(Trigger.isBefore, Trigger.isUpdate, Trigger.isInsert, Trigger.isDelete, Trigger.isUndelete, Trigger.old, Trigger.new);
    }

    public void handle(boolean isBefore, boolean isUpdate, boolean isInsert, boolean isDelete, boolean isUndelete, List<sObject> oldList, List<sObject> newList) {
        if(theseEventsToTriggerHandlers == null) {
            return;
        }
        String eventString = triggerFlagsToString(isBefore, isUpdate, isInsert, isDelete, isUndelete);
        List<Trigger_Handler__mdt> theseTriggerHandlers = theseEventsToTriggerHandlers.getTriggerHandlers(eventString);

        if(theseTriggerHandlers == null) {
            return;
        }

        for(Trigger_Handler__mdt thisTriggerHandler : theseTriggerHandlers) {
            Type handlerType = Type.forName(thisTriggerHandler.NamespacePrefix, thisTriggerHandler.Class_Name__c);
            if(handlerType == null) {
                throw new ClassNotFoundException('MetaDataTriggerManager: handler class not found for ' + thisTriggerHandler);
            } else {
                if(isBefore) {
                    if(isUpdate) {
                        ((BeforeUpdate)handlerType.newInstance()).handleBeforeUpdate(oldList, newList);
                    } else if(isInsert) {
                        ((BeforeInsert)handlerType.newInstance()).handleBeforeInsert(newList);
                    } else if(isDelete) {
                        ((BeforeDelete)handlerType.newInstance()).handleBeforeDelete(oldList);
                    } else if(isUndelete) {
                        ((BeforeUndelete)handlerType.newInstance()).handleBeforeUndelete(newList);
                    }
                } else {
                    if(isUpdate) {
                        ((AfterUpdate)handlerType.newInstance()).handleAfterUpdate(oldList, newList);
                    } else if(isInsert) {
                        ((AfterInsert)handlerType.newInstance()).handleAfterInsert(newList);
                    } else if(isDelete) {
                        ((AfterDelete)handlerType.newInstance()).handleAfterDelete(oldList);
                    } else if(isUndelete) {
                        ((AfterUndelete)handlerType.newInstance()).handleAfterUndelete(newList);
                    }
                }
            }
        }
    }
}