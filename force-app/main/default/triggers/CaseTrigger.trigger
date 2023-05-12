/*
@Author : Banuchandar
@CreatedDate : 11/05/2023
@Description : Case Object Trigger.
*/
trigger CaseTrigger on Case(before insert, after insert, before update, after update, before delete, after delete, after unDelete) {
    (new MetaDataTriggerManager()).handle();
}