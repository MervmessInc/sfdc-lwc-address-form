/**
 * @description       : 
 * @author            : Nigel Hughes
 * @group             : 
 * @last modified on  : 2023-11-01
 * @last modified by  : Nigel Hughes
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   2023-11-01   Nigel Hughes   Initial Version
**/
public with sharing class AddressRegionService {
    
    public static string codeToCountry(String iso2code) {

        // Validate parameters
        if (!String.isNotBlank(iso2code)) {
            throw new AddressRegionServiceException('ISO2 Code is required.');
        }

		String countryLabel = '';

        // Get the country label
		ISO_Country__mdt iSOCountry = [
			SELECT MasterLabel
			FROM ISO_Country__mdt
            WHERE ISO_Alpha_2__c = :iso2code
            WITH SECURITY_ENFORCED
		];
		countryLabel = iSOCountry.MasterLabel;

        return countryLabel;
    }

	public static string countryToCode(String countryLabel) {

        // Validate parameters
        if (!String.isNotBlank(countryLabel)) {
            throw new AddressRegionServiceException('Country Label is required.');
        }

		String iso2code = '';

		// Get the ISO 2 Code
        ISO_Country__mdt iSOCountry = [
            SELECT ISO_Alpha_2__c
			FROM ISO_Country__mdt
            WHERE MasterLabel = :countryLabel
            WITH SECURITY_ENFORCED
		];
		iso2code = iSOCountry.ISO_Alpha_2__c;

        return iso2code;
	}

	public static string regionToCode(String iso2code, String regionLabel) {

        // Validate parameters
        if (!String.isNotBlank(iso2code)) {
            throw new AddressRegionServiceException('ISO2 Code is required.');
        }

        if (!String.isNotBlank(regionLabel)) {
            throw new AddressRegionServiceException('Region Label is required.');
        }

		String regionCode = '';

        // Get the region code
		ISO_Province__mdt iSOProvince = [
    		SELECT Subdivision_Code__c
		    FROM ISO_Province__mdt
		    WHERE ISO_Alpha_2__c = : iso2code
		    AND MasterLabel = :regionLabel
		    WITH SECURITY_ENFORCED
		];
		regionCode = iSOProvince.Subdivision_Code__c;

		return regionCode;
	}

	public static string codeToRegion(String iso2code, String regionCode) {

        // Validate parameters
        if (!String.isNotBlank(iso2code)) {
            throw new AddressRegionServiceException('ISO2 Code is required.');
        }

        if (!String.isNotBlank(regionCode)) {
            throw new AddressRegionServiceException('Region Code is required.');
        }

		String regionLabel = '';

        // Get the region label
		ISO_Province__mdt iSOProvince = [
			SELECT MasterLabel
			FROM ISO_Province__mdt
			WHERE ISO_Alpha_2__c = : iso2code
			AND Subdivision_Code__c = : regionCode
			WITH SECURITY_ENFORCED
		];
		regionLabel = iSOProvince.MasterLabel;

        return regionLabel;
	}

    public class AddressRegionServiceException extends Exception {}
}