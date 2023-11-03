/**
 * @description       : 
 * @author            : Nigel Hughes
 * @group             : 
 * @last modified on  : 2023-11-03
 * @last modified by  : Nigel Hughes
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   2023-11-03   Nigel Hughes   Initial Version
**/
public inherited sharing class AccountsSelector extends fflib_SObjectSelector {

    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Account.Id,
            Account.Name,
            Account.Description
		};
    }
    
    public List<Account> selectById(Set<ID> idSet) {
        return (List<Account>) selectSObjectsById(idSet);
    }
    

    public List<Account> selectBillingAddresses(Set<ID> idSet) {

        String soqlQuery = newQueryFactory()
            .selectFields(new Set<String>{
                'BillingStreet',
                'BillingCity',
                'BillingState',
                'BillingPostalCode',
                'BillingCountry'
            })
            .setCondition('id in :idSet')
            .toSOQL();

            return (List<Account>) Database.query(soqlQuery);
    }
}