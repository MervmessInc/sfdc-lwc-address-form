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
trigger AccountsTrigger on Account (after delete, after insert, after update, before delete, before insert, before update) {
    // Creates Domain class instance and calls apprpoprite overideable methods according to Trigger state
	fflib_SObjectDomain.triggerHandler(Accounts.class);
}