
Set<Id> recordIds = new Set<Id>{'0012600002CxQC0AAN'};
List<Account> accountRecords = [
            SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry 
            FROM Account 
            WHERE Id IN :recordIds
            WITH SECURITY_ENFORCED
        ];

Accounts domain = new Accounts(accountRecords);
system.debug(domain.getAccounts());


