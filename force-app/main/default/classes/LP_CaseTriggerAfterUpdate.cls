/**
* @author       Banuchandar
* @description  To perform the operation after update on case object
* @TestClass    LP_CaseTriggerAfterUpdate_Test.cls
**/
public with sharing class LP_CaseTriggerAfterUpdate implements AfterUpdate {

    //Method to handle after update event for case object
    public void handleAfterUpdate(List<Case> newList, list<Case> oldList) {
        getRecordsTobeProcessed(newList, oldList);
    }
    
    //Method to get the new and old records from the trigger handler and get the account id which need to be processed
    public static void getRecordsTobeProcessed(List<Case> newList, list<Case> oldList){
        set<Id> accountIdsToUpdate=new set<Id>();
        try{
            Map<Id,Case> oldCaseRecords = new Map<Id,Case>(oldList);       
            Map<Id,Case> newCaseRecords = new Map<Id,Case>(newList);
            for (Case csOldRec :oldCaseRecords.values()){
                if (newCaseRecords!=null && newCaseRecords.get(csOldRec.Id).AccountId!=null && csOldRec.Satisfaction_Rating__c != newCaseRecords.get(csOldRec.Id).Satisfaction_Rating__c){
                    accountIdsToUpdate.add(csOldRec.AccountId);
                }
                else if(csOldRec.AccountId != null && csOldRec.Satisfaction_Rating__c!=null){
                    accountIdsToUpdate.add(csOldRec.AccountId);
                }                    
            }
        }
        catch(Exception e){
            system.debug('log exception '+e.getLineNumber()+'--'+e.getMessage()); 
        }
        if(!accountIdsToUpdate.isEmpty()){
            updateAvgRatinginAccount(accountIdsToUpdate);
        }
    }
    //Method to update the account records with the average rating
    public static void updateAvgRatinginAccount(set<id> accountIds){
        try{
            List<Account> recordsTobeUpdated = new List<Account>();
            List<AggregateResult> aggregateResultList = [SELECT AVG(Satisfaction_Rating__c)avgRat, AccountId
                                                         FROM  Case
                                                         WHERE AccountId IN :accountIds and Satisfaction_Rating__c!=null
                                                         GROUP BY AccountId];
            for (AggregateResult arObj : aggregateResultList){
                Account accObj = new Account();
                accObj.Id = String.valueOf(arObj.get('AccountId'));
                accObj.Average_Satisfaction_Rating__c = ((Decimal)arObj.get('avgRat')).setScale(2);
                recordsTobeUpdated.add(accObj);
            }
            //Updating the average rating on the account object
            if (!recordsTobeUpdated.isEmpty()){
                database.update(recordsTobeUpdated, false);
            }
        }catch (Exception e){
            system.debug('log exception '+e.getLineNumber()+'--'+e.getMessage()); 
        }
    }
}