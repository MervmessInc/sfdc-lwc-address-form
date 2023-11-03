Set<Id> recordIds = new Set<Id>{'0012600002CxQC0AAN'};

AccountsSelector selector = new AccountsSelector();
List<Account> accounts = selector.selectById(recordIds);

System.debug(accounts);
System.debug(selector.selectBillingAddresses(recordIds));