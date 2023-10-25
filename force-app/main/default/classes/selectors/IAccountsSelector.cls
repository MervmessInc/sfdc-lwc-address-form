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
public interface IAccountsSelector extends IApplicationSObjectSelector {
    List<Account> selectById(Set<Id> idSet);
    Account selectById(Id id);
}