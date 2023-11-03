/**
 * @File Name          : AddressInputFormController.cls
 * @Description        : 
 * @Author             : Nigel Hughes
 * @Group              : 
 * @Last Modified By   : Nigel Hughes
 * @Last Modified On   : 2023-11-01
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/05/2020   Nigel Hughes     Initial Version
**/
public with sharing class AddressInputFormController {
	@testVisible
	private class AddressData {
		@AuraEnabled
		public String address1 { get; set; }
		@AuraEnabled
		public String city { get; set; }
		@AuraEnabled
        public String country { get; set; }
        @AuraEnabled
		public String countryCode { get; set; }
		@AuraEnabled
		public String postalcode { get; set; }
		@AuraEnabled
        public String region { get; set; }
        @AuraEnabled
		public String regionCode { get; set; }
	}

	@testVisible
	private class OptionsData {
		@AuraEnabled
		public String label { get; set; }
		@AuraEnabled
		public String value { get; set; }
	}

	private static AddressData getAcntAddress(Id objectId) {
		AddressData address = new AddressData();

		List<Account> accounts = AccountsService.getBillingAddresses(new Set<Id>{objectId});
		Account acnt = accounts[0];

		String countryCode = '';
		String regionCode = '';

		try {
			countryCode = AddressRegionService.countryToCode(acnt.BillingCountry);
		} catch (Exception e) {
			System.debug('ISO Code Lookup failed.');
			countryCode = acnt.BillingCountry;
		}

		try {
			regionCode = AddressRegionService.regionToCode(countryCode, acnt.BillingState);
		} catch (Exception e) {
			System.debug('Region Code Lookup failed.');
			regionCode = acnt.BillingState;
		}	
		
		address.address1 = acnt.BillingStreet;
		address.city = acnt.BillingCity;
		address.country = acnt.BillingCountry;
		address.countryCode = countryCode;
		address.postalcode = acnt.BillingPostalCode;
		address.region = acnt.BillingState;
		address.regionCode = regionCode;

		return address;
	}

	@AuraEnabled(cacheable=true)
	public static AddressData getAddressData(String objectType, Id objectId) {
		system.debug(objectType);
		system.debug(objectId);

		// In the real world use objectType & objectId to get the address 
		
		if(objectType == 'Account') {
			return getAcntAddress(objectId);
		}

		AddressData address = new AddressData();

		address.address1 = 'Street 1';
		address.city = 'City';
        address.country = 'United States';
        address.countryCode = 'US';
		address.postalcode = '456789';
        address.region = 'New York';
        address.regionCode = 'NY';

		return address;
	}

	@AuraEnabled(cacheable=true)
	public static List<OptionsData> getProvinceOptions(String iso2code) {
		List<OptionsData> retVal = new List<OptionsData>();

		List<ISO_Province__mdt> isoProvinces = [
			SELECT MasterLabel, Subdivision_Code__c
			FROM ISO_Province__mdt
			WHERE ISO_Alpha_2__c = :iso2code
			WITH SECURITY_ENFORCED
			ORDER BY MasterLabel
		];

		for (ISO_Province__mdt isoProvince : isoProvinces) {
			OptionsData state = new OptionsData();
			state.label = isoProvince.MasterLabel;
			state.value = isoProvince.Subdivision_Code__c;
			retVal.add(state);
		}

		return retVal;
	}

	@AuraEnabled(cacheable=true)
	public static List<OptionsData> getCountryOptions() {
		List<OptionsData> retVal = new List<OptionsData>();

		List<ISO_Country__mdt> iSOCountries = [
			SELECT MasterLabel, ISO_Alpha_2__c
			FROM ISO_Country__mdt
			WITH SECURITY_ENFORCED
			ORDER BY MasterLabel
		];

		for (ISO_Country__mdt isoCountry : iSOCountries) {
			OptionsData country = new OptionsData();
			country.label = isoCountry.MasterLabel;
			country.value = isoCountry.ISO_Alpha_2__c;
			retVal.add(country);
		}

		return retVal;
	}

	private static string saveAcntAddress(Id objectId, AddressData address) {

		AccountsService.BillingAddress billingAddress = new AccountsService.BillingAddress();
		billingAddress.address1 = address.address1;
		billingAddress.city = address.city;
		billingAddress.country = address.country;
		billingAddress.countryCode = address.countryCode;
		billingAddress.postalCode = address.postalcode;
		billingAddress.region = address.region;	
		billingAddress.regionCode = address.regionCode;	

		Map<Id, AccountsService.BillingAddress> accountBillingAddresses = new Map<Id, AccountsService.BillingAddress>();
		accountBillingAddresses.put(objectId, billingAddress);
		AccountsService.updateBillingAddresses(accountBillingAddresses);

		return 'Account Address Saved';
	}

	@AuraEnabled
	public static string saveAddressData(String objectType, Id objectId, AddressData address){
		system.debug(objectType);
		system.debug(objectId);
		system.debug(address);
		
		// In the real world use objectType & objectId to get the address 
		
		if(objectType == 'Account') {
			return saveAcntAddress(objectId, address);
		}

		return 'It worked';
	}
}
