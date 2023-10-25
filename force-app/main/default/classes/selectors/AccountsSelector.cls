/**
 * @description       : 
 * @author            : Nigel Hughes
 * @group             : 
 * @last modified on  : 2023-10-25
 * @last modified by  : Nigel Hughes
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   2023-10-25   Nigel Hughes   Initial Version
**/
public inherited sharing class AccountsSelector extends ApplicationSObjectSelector implements IAccountsSelector {
    
    // sObjectField list
    private List<String> additionalSObjectFieldList = new List<String>{
        'Id',
        'Name',
        'BillingCity',
        'BillingCountry',
        'BillingPostalCode',
        'BillingState',
        'BillingStreet'
    };

    // Boilerplate code
    public static AccountsSelector newInstance() {
        return (AccountsSelector) Application.Selector.newInstance(Account.SObjectType);
    }

    public Schema.SObjectType getSObjectType() {
		return Account.SObjectType;
	}

    public fflib_QueryFactory getQueryFactory() {
        return new fflib_QueryFactory(getSObjectType());
    }

    public override List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>();
    }

    public List<String> getSObjectFieldListWithRelatedFields() {
        return this.additionalSObjectFieldList;
    }
    
    public void setSObjectFieldListWithRelatedFields(String[] values) {
        this.additionalSObjectFieldList = values;
    }

    @TestVisible
    private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
        return new List<Schema.SObjectField>{};
    }

    // Selector Methods
	public List<Account> selectById(Set<Id> idSet) {
        
        if (idSet.isEmpty()) {
            return new List<Account>();
        }
		
        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        qf.setCondition('Id IN :idSet');
        
        return Database.query(qf.toSOQL());
	}

    public Account selectById(Id id) {
        List<Account> recordList = selectById(new Set<Id>{ id });
        return recordList.isEmpty() ? null : recordList[0];
    }
}