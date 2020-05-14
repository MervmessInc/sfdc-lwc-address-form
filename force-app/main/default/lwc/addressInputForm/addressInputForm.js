import {LightningElement, api, wire, track} from "lwc";
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import getAddressData from "@salesforce/apex/AddressInputFormController.getAddressData";
import getProvinceOptions from "@salesforce/apex/AddressInputFormController.getProvinceOptions";
import getCountryOptions from "@salesforce/apex/AddressInputFormController.getCountryOptions";

export default class AddressInputForm extends LightningElement {
	@api recordId;
	@api objectApiName;
	@track addressData;
	@track error;

	provinceOptions = [];
	countryOptions = [];
	hasData = false;
	hasProvince = false;
	street;
	_country;
	readOnly = true;

	@wire(getAddressData, {objectType: "$objectApiName", objectId: "$recordId"})
	apexAddressData({data, error}) {
		if (data) {
			this.hasData = true;
			this.addressData = data;
			console.log(JSON.stringify(this.addressData));
			this.street = this.addressData.address1;
			if (this.addressData.address2) {
				street = street + "\n" + this.addressData.address2;
			}
			if (this.addressData.address3) {
				street = street + "\n" + this.addressData.address3;
			}
			this._country = this.addressData.country;
			this.getProvinceOptions;
			this.getCountryOptions;
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
				//console.log(JSON.stringify(this.provinceOptions));
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
				//console.log(JSON.stringify(this.countryOptions));
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

	handleChange(event) {
		//console.log("Select Event");
		//console.log(JSON.stringify(event.detail));
		this._country = event.detail.value;
		this.getProvinceOptions;
	}

	handleEdit() {
		this.readOnly = this.readOnly === true ? false : true;
	}
}
