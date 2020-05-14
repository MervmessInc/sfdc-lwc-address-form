/**
 * @File Name          : AddressInputFormController.cls
 * @Description        : 
 * @Author             : Nigel Hughes
 * @Group              : 
 * @Last Modified By   : Nigel Hughes
 * @Last Modified On   : 14/05/2020, 14:08:24
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
		public String address2 { get; set; }
		@AuraEnabled
		public String address3 { get; set; }
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

	@AuraEnabled(cacheable=true)
	public static AddressData getAddressData(String objectType, Id objectId) {
		system.debug(objectType);
		system.debug(objectId);

        // In the real world use objectType & objectId to get the address 

		AddressData address = new AddressData();

		address.address1 = 'Street 1';
		address.address2 = 'Street 2';
		address.address3 = 'Street 3';
		address.city = 'City';
        address.country = '';
        address.countryCode = 'US';
		address.postalcode = '456789';
        address.region = '';
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

	public static string codeToCountry(String iso2code) {
		String countryLabel = '';
		try {
			ISO_Country__mdt iSOCountry = [
				SELECT
					DeveloperName,
					MasterLabel,
					Dial__c,
					ISO_Alpha_2__c,
					ISO_Alpha_3__c,
					ISO_Currency_Code__c,
					ISO_Currency_Name__c,
					ISO_Numeric__c,
					Official_Name_en__c
				FROM ISO_Country__mdt
				WHERE ISO_Alpha_2__c = :iso2code
			];
			countryLabel = iSOCountry.MasterLabel;
		} catch (Exception e) {
			//Pass
			System.debug('ISO Country Lookup failed.');
			countryLabel = iso2code;
		}

		return countryLabel;
	}

	public static string countryToCode(String countryLabel) {
		String iso2code = '';
		try {
			ISO_Country__mdt iSOCountry = [
				SELECT
					DeveloperName,
					MasterLabel,
					Dial__c,
					ISO_Alpha_2__c,
					ISO_Alpha_3__c,
					ISO_Currency_Code__c,
				    ISO_Currency_Name__c,
					ISO_Numeric__c,
					Official_Name_en__c
				FROM ISO_Country__mdt
				WHERE MasterLabel = :countryLabel
			];
			iso2code = iSOCountry.ISO_Alpha_2__c;
		} catch (Exception e) {
			//Pass
			System.debug('ISO Code Lookup failed.');
			iso2code = countryLabel;
		}
		return iso2code;
	}
}
