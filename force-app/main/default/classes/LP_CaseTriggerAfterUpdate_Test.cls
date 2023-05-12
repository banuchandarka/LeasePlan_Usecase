@isTest
public with sharing class LP_CaseTriggerAfterUpdate_Test {
    @TestSetup
    static void createTestData(){
        Account acc = new Account(Name = 'Account1');
        insert acc;
        list<case> casesTobeInserted=returnNewCases(4,acc.Id);
        insert casesTobeInserted;        
    }
    @isTest
    static void runAfterUpdate(){
        Account acc = [SELECT Id FROM Account Limit 1];
        Case csRecord=[select id,Satisfaction_Rating__c from case where AccountId=:acc.Id limit 1];
        csRecord.Satisfaction_Rating__c=4;
        update csRecord;
    }
    static list<case> returnNewCases(integer caseCount,Id accId){
        list<case> caseRecords=new list<case>();
        for(integer i=0;i<=caseCount;i++){
            case csObj=new case();
            csObj.Status='New';
            csObj.Origin='Phone';
            csObj.AccountId=accId;
            csObj.Satisfaction_Rating__c=i+1;
            caseRecords.add(csObj);
        }
        return caseRecords;
    }
}