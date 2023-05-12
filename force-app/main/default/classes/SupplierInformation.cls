public with sharing class SupplierInformation {
    @AuraEnabled(cacheable=true)
    public static List<Supplier__c> getSupplierListByCity(String city) {
        return [Select Name,Location__c from Supplier__c where City__c =: city];
    }
}