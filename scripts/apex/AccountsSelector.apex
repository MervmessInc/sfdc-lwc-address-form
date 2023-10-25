AccountsSelector selector = AccountsSelector.newInstance();
List<Account> accounts = selector.selectById(new Set<Id>{'0012600002CxQC0AAN'});

System.debug(accounts);