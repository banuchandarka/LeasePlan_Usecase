@isTest
public class SupplierListController_Test {
    @TestSetup
    static void createTestData(){
        Supplier__c supplier = new Supplier__c(Name = 'Supplier 1', City__c = 'Berlin', Country__c = 'Germany', Time_Zone__c='Europe/Berlin');
        insert supplier;       
    }
    @isTest
    static void getSupplierListByCity_Positive_Test(){
        List<Supplier__c> spList = SupplierListController.getSupplierListByCity('Berlin');
        Assert.areEqual(spList[0].Name,'Supplier 1');
    }
    @isTest
    static void getSupplierListByCity_Negative_Test(){
        List<Supplier__c> spList = SupplierListController.getSupplierListByCity('');
       Assert.areEqual(spList,null);
    }
}