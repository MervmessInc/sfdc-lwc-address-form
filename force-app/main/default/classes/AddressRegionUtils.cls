/**
 * @File Name          : AddressRegionUtils.cls
 * @Description        : 
 * @Author             : Nigel Hughes
 * @Group              : 
 * @Last Modified By   : Nigel Hughes
 * @Last Modified On   : 20/05/2020, 15:02:56
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/05/2020   Nigel Hughes     Initial Version
**/
public with sharing class AddressRegionUtils {
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
                WITH SECURITY_ENFORCED
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
                WITH SECURITY_ENFORCED
			];
			iso2code = iSOCountry.ISO_Alpha_2__c;
		} catch (Exception e) {
			//Pass
			System.debug('ISO Code Lookup failed.');
			iso2code = countryLabel;
		}
		return iso2code;
	}

	public static string regionToCode(String iso2code, String regionLabel) {
		String regionCode = '';
		try {
			ISO_Province__mdt iSOProvince = [
				SELECT
					DeveloperName,
					MasterLabel,
					ISO_Alpha_2__c,
					Subdivision_Code__c,
					Subdivision_Type__c
				FROM ISO_Province__mdt
				WHERE ISO_Alpha_2__c = : iso2code
				AND MasterLabel = :regionLabel
				WITH SECURITY_ENFORCED
			];
			regionCode = iSOProvince.Subdivision_Code__c;
		} catch (Exception e) {
			//Pass
			System.debug('Region Code Lookup failed.');
			regionCode = regionLabel;
		}	

		return regionCode;
	}

	public static string codeToRegion(String iso2code, String regionCode) {
		String regionLabel = '';
		try {
			ISO_Province__mdt iSOProvince = [
				SELECT
					DeveloperName,
					MasterLabel,
					ISO_Alpha_2__c,
					Subdivision_Code__c,
					Subdivision_Type__c
				FROM ISO_Province__mdt
				WHERE  ISO_Alpha_2__c = : iso2code
				AND Subdivision_Code__c = : regionCode
				WITH SECURITY_ENFORCED
			];
			regionLabel = iSOProvince.MasterLabel;
		} catch (Exception e) {
			//Pass
			System.debug('Region Label Lookup failed.');
			regionLabel = regionCode;
		}	
		return regionLabel;
	}
}
