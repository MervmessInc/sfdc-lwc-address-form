/**
 * @description       : 
 * @author            : Nigel Hughes
 * @group             : 
 * @last modified on  : 2023-11-01
 * @last modified by  : Nigel Hughes
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   2023-11-01   Nigel Hughes   Initial Version
**/
public with sharing class AccountsService {

    public class BillingAddress {
        public String address1;
        public String city;
        public String country;
        public String countryCode;
        public String postalcode;
        public String region;
        public String regionCode;
    }
    
    public static List<Account> getBillingAddresses(Set<Id> accountIds) {

        // Validate parameters
        if(accountIds==null || accountIds.size()==0) {
            throw new AccountsServiceException('Accounts not specified.');
        }
        
        // Query accounts to get billing addresses
        List<Account> accounts = [
            SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry 
            FROM Account 
            WHERE Id IN :accountIds
            WITH SECURITY_ENFORCED
        ];        

        return accounts;
    }

    public static void updateBillingAddresses(Map<Id, BillingAddress> accountBillingAddresses) {
        
        // Validate parameters
        if(accountBillingAddresses==null || accountBillingAddresses.size()==0) {
            throw new AccountsServiceException('Accounts not specified.');
        }

        // Unit of Work
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<SObjectType> { Account.SObjectType }
        );
        
        // Update accounts with billing addresses
        List<Account> accounts = new List<Account>();
        List<Account> existingAccounts = getBillingAddresses(accountBillingAddresses.keySet());

        for(Account acnt: existingAccounts) {
            BillingAddress billingAddress = accountBillingAddresses.get(acnt.Id);
            acnt.BillingStreet = billingAddress.address1;
            acnt.BillingCity = billingAddress.city;
            acnt.BillingState = billingAddress.region;
            acnt.BillingPostalCode = billingAddress.postalcode;
            acnt.BillingCountry = billingAddress.country;
            uow.registerDirty(acnt);
        }

        // Commit Unit of Work
        uow.commitWork();
    }

    public class AccountsServiceException extends Exception {}
}