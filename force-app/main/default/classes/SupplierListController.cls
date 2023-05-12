/**
* @author       Banuchandar
* @description  To get the list of suppliers
* @TestClass    SupplierListController_Test.cls
**/

public with sharing class SupplierListController {
   
    //Method to get the list of suppliers using city
    @AuraEnabled(cacheable = true)
    public static List<Supplier__c> getSupplierListByCity(String city){ 
        try{
            if(String.isNotBlank(city)){
                return [select id, Name, City__c, Location__Longitude__s, Location__Latitude__s, Country__c, 
                                    Time_Zone__c,Waiting_Period__c FROM Supplier__c WHERE City__c =: city
                                    ORDER BY Name ASC];
            }
            else{
                throw new AuraHandledException('City not found');
            }
        }catch(Exception e){
            System.debug('Error fetching supplier list : '+e.getMessage());
            return null;
        }
    }
}