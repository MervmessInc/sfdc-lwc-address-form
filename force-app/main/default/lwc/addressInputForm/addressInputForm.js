import {LightningElement, api, wire, track} from "lwc";
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import getAddressData from "@salesforce/apex/AddressInputFormController.getAddressData";
import getProvinceOptions from "@salesforce/apex/AddressInputFormController.getProvinceOptions";
import getCountryOptions from "@salesforce/apex/AddressInputFormController.getCountryOptions";

export default class AddressInputForm extends LightningElement {
	@api recordId;
	@api objectApiName;
	@track error;

	@track addressData = {
		address1 : '',
		city : '',
		country : '',
		countryCode : '',
		postalcode : '',
		region : '',
		regionCode : ''
	};

	provinceOptions = [];
	countryOptions = [];
	hasData = false;
	hasProvince = false;
	_country;
	readOnly = true;
	
	// initialize component
	connectedCallback() {
		this.getCountryOptions;
	}

	@wire(getAddressData, {objectType: "$objectApiName", objectId: "$recordId"})
	apexAddressData({data, error}) {
		if (data) {
			this.hasData = true;
			this.addressData.address1 = data.address1;
			this.addressData.city = data.city;
			this.addressData.country = data.country;
			this.addressData.countryCode = data.countryCode;
			this.addressData.postalcode = data.postalcode;
			this.addressData.region = data.region;
			this.addressData.regionCode = data.regionCode;
			console.log(JSON.stringify(this.addressData));
			this._country = this.addressData.countryCode;
			this.getProvinceOptions;
		} else if (error) {
			this.error = error;
			this.data = undefined;
			console.log(JSON.stringify(error));
			let message = "Unknown error";
			this.dispatchEvent(
				new ShowToastEvent({
					title: "Error loading Address Data",
					message,
					variant: "error"
				})
			);
		}
	}

	get getProvinceOptions() {
		this.hasProvince = false;
		this.provinceOptions = [];

		getProvinceOptions({iso2code: this._country})
			.then(result => {
				result.forEach(ele => {
					this.provinceOptions.push({value: ele.value, label: ele.label});
					this.hasProvince = true;
				});
			})
			.catch(error => {
				this.error = error;
				this.hasProvince = false;
				console.log(JSON.stringify(error));
				let message = "Unknown error";
				this.dispatchEvent(
					new ShowToastEvent({
						title: "Error loading Province Data",
						message,
						variant: "error"
					})
				);
			});

		return true;
	}

	get getCountryOptions() {
		this.countryOptions = [];

		getCountryOptions()
			.then(result => {
				result.forEach(ele => {
					this.countryOptions.push({value: ele.value, label: ele.label});
				});
			})
			.catch(error => {
				this.error = error;
				this.hasProvince = false;
				console.log(JSON.stringify(error));
				let message = "Unknown error";
				this.dispatchEvent(
					new ShowToastEvent({
						title: "Error loading Country Data",
						message,
						variant: "error"
					})
				);
			});

		return true;
	}

	handleEdit() {
		this.readOnly = this.readOnly === true ? false : true;
	}

	handleSave() {
		console.log(JSON.stringify(this.addressData));
	}

	countryChange(event) {
		this._country = event.detail.value;
		this.addressData.countryCode = this._country;
		let countryData = this.countryOptions.find(o => o.value === this._country);
		this.addressData.country = countryData.label;
		this.getProvinceOptions;
	}

	address1Change(event) {
		this.addressData.address1 = event.detail.value;
	}

	cityChange(event) {
		this.addressData.city = event.detail.value;
	}

	regioncodeChange(event) {
		let rgCode = event.detail.value;
		this.addressData.regionCode = rgCode;
		let regionData = this.provinceOptions.find(o => o.value === rgCode);
		this.addressData.region = regionData.label;
	}

	regionChange(event) {
		this.addressData.region = event.detail.value;
	}

	postalcodeChange(event) {
		this.addressData.region = event.detail.value;
	}

}
