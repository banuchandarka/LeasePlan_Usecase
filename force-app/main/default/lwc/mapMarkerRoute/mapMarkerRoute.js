import { LightningElement, track, api } from "lwc";

export default class MapMarkerRoute extends LightningElement {
  
  @api accountRecord;
  @track locationOfAccount;
  @track locationOfSuppplier;
  @track selectedMarkerValue = ""; //To display the selected location from list
  @track mapMarkers = []; // The list holding the map markers
  @track supplierItem;
  @track errorMessage;
  
  connectedCallback(){
    console.log('Inside Map markers');
    console.log('accountRecord : ');
    this.errorMessage = undefined;
    this.setAccountMarker();
  }
  
  //generates the location marker in map for account
  setAccountMarker() {
    if (this.accountRecord) {      
      this.locationOfAccount = {
        value: this.accountRecord.fields.Name.value,
        location: {},
        icon: "standard:avatar",
        title: this.accountRecord.fields.Name.value
      };
      this.selectedMarkerValue = this.accountRecord.fields.Name.value;
      this.locationOfAccount.location = {
        City: this.accountRecord.fields.BillingCity.value,
        Country: this.accountRecord.fields.BillingCountry.value,
        PostalCode: this.accountRecord.fields.BillingPostalCode.value,
        State: this.accountRecord.fields.BillingState.value,
        Street: this.accountRecord.fields.BillingStreet.value
      };
      this.mapMarkers = [];
     // console.log("location" + JSON.stringify(this.locationOfAccount));
      this.mapMarkers.push(this.locationOfAccount);
    }
  }
  //generates the location marker in map for supplier selected by the user.
  @api
  setSupplierMarker(supplierRecord)
  {
    this.supplierItem=supplierRecord;    
    if (this.supplierItem) {      
      this.locationOfSuppplier = {
        value: this.supplierItem.Name,
        location: {},
        icon: "custom:custom31",
        title: this.supplierItem.Name,
        description:
                'Opening Time :  08:00 - 18:00 .'
      };
      this.selectedMarkerValue = this.supplierItem.Name;
      this.locationOfSuppplier.location = {
        Latitude: this.supplierItem.Location__Latitude__s,
        Longitude: this.supplierItem.Location__Longitude__s
      };
      // console.log("location" + JSON.stringify(this.locationOfAccount));
      this.mapMarkers = [];
      this.mapMarkers.push(this.locationOfSuppplier);
      this.mapMarkers.push(this.locationOfAccount);
  }
}
// show detail of the selected marker
  handleMarkerSelect(event) {
    this.selectedMarkerValue = event.detail.selectedMarkerValue;
  }
}