import { LightningElement, api, track } from "lwc";
import { CurrentPageReference, NavigationMixin } from "lightning/navigation";

export default class SupplierData extends NavigationMixin(LightningElement) {
  @api supplierItem;
  @track recordPageUrl;
  //rendered Callback  - to generate the record url for supplier record and add it to the tile
  renderedCallback() { 
    this[NavigationMixin.GenerateUrl]({
      type: "standard__navItemPage",
      attributes: {
        recordId: this.supplierItem.Id,
        actionName: "view"
      }
    }).then((url) => {
      this.recordPageUrl = url;
    });
  }
  
  //event triggered when the user clicks on the supplier tile to display the supplier location in map
  showSupplierInMap(event) {
    
    const sendEvent = new CustomEvent("supplierselected", {
      detail : this.supplierItem
    });
    // Dispatches the event.
    this.dispatchEvent(sendEvent);
  }
}