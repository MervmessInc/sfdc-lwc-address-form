//AccountsSelector selector = AccountsSelector.newInstance();
//List<Account> accounts = selector.selectById(new Set<Id>{'0012600002CxQC0AAN'});
//System.debug(accounts);

Set<Id> recordIds = new Set<Id>{'0012600002CxQC0AAN'};

List<Account> accountRecords = new List<Account>{
   new Account(Name = 'Hello world!')
};

IAccounts domain = Accounts.newInstance(accountRecords);
//System.debug(iaccounts.getAccounts());

