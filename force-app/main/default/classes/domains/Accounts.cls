/**
 * @description       : 
 * @author            : Nigel Hughes
 * @group             : 
 * @last modified on  : 2023-12-05
 * @last modified by  : Nigel Hughes
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   2023-11-03   Nigel Hughes   Initial Version
**/
public inherited sharing class Accounts extends fflib_SObjectDomain {
    
	public Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }

    public List<Account> getAccounts() {
		return (List<Account>) getRecords();
	}

    public override void onBeforeInsert() {
        
        // Validate Accounts
        for(Account acnt : (List<Account>) this.records) {

            if(acnt.BillingStreet == null || acnt.BillingStreet == '') {
                acnt.BillingStreet.addError('Street is required');
            }
            if(acnt.BillingCity == null || acnt.BillingCity == '') {
                acnt.BillingCity.addError('City is required');
            }
            if(acnt.BillingCountry == null || acnt.BillingCountry == '') {
                acnt.BillingCountry.addError('Country is required');
            }
        }

    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        // Validate Accounts
        for(Account acnt : (List<Account>) this.records) {

            if(acnt.BillingStreet == null || acnt.BillingStreet == '') {
                acnt.BillingStreet.addError('Street is required');
            }
            if(acnt.BillingCity == null || acnt.BillingCity == '') {
                acnt.BillingCity.addError('City is required');
            }
            if(acnt.BillingCountry == null || acnt.BillingCountry == '') {
                acnt.BillingCountry.addError('Country is required');
            }
        }
    }

}