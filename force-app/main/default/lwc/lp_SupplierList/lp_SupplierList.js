import { LightningElement, wire, api, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getSupplierListByCity from '@salesforce/apex/SupplierListController.getSupplierListByCity';

const FIELDS = [
    "Account.Name",
    "Account.BillingCity",
    "Account.BillingLatitude",
    "Account.BillingLongitude",
    "Account.BillingStreet",
    "Account.BillingPostalCode",
    "Account.BillingState",
    "Account.BillingCountry"
  ];

export default class Lp_SupplierList extends LightningElement {

    @api recordId; 
    @track totalSuppliersCount = 0;
    @track errorMessage;
    @track listOfSuppliersItems=[];
    @track listOfSuppliersDisplayed=[];
    @track page = 1; //this will initialize 1st page
    @track startingRecord = 1; //start record position per page
    @track endingRecord = 0; //end record position per page
    @track pageSize = 5; //default items on a page
    @track totalPage = 0; //total number of page is needed to display all records    
    @track searchSuppliersStr;
    @track isDataAvbl=false;
    @track isPageRendered=false;
    accountRecord;
    
    

    //Get all the suppliers record based on Account BillingCity
    @wire(getRecord, { recordId: '$recordId',  fields: FIELDS })
    wiredSuppliers({ error, data }) {
        if(data){
            this.accountRecord = data;
            getSupplierListByCity({city: data.fields.BillingCity.value})
            .then(result =>{
                console.log('Success : '+JSON.stringify(result));
                this.listOfSuppliersItems=result;
                this.totalSuppliersCount=result.length;
                console.log("Total records : "+this.totalSuppliersCount);
                this.isDataAvbl = this.totalSuppliersCount>1?true:false;
                this.listOfSuppliersDisplayed = this.listOfSuppliersItems.slice(0,this.pageSize);
                this.totalPage = Math.ceil(this.totalSuppliersCount / this.pageSize);
                this.endingRecord = this.pageSize;
                this.errorMessage = undefined;
            })
            .catch(error => {
                this.errorMessage = "Error getting supplier details!";
                this.listOfSuppliersItems = undefined;
                console.log('Error getting supplier details '+JSON.stringify(error));
            })
        }
        else if(error){
            this.errorMessage = "Error getting account details!";
            this.listOfSuppliersItems = undefined;
            console.log('Error getting account details');
        }
        this.isPageRendered=true;
    }
    
    //clicking on previous button this method will be called
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.showSuppliersPerPage(this.page);            
        }
    }

    //clicking on next button this method will be called
    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.showSuppliersPerPage(this.page);            
        }             
    }
    //To get the records count to be displayed in the page
    showSuppliersPerPage(page){
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalSuppliersCount) 
                            ? this.totalSuppliersCount : this.endingRecord; 

        this.listOfSuppliersDisplayed = this.listOfSuppliersItems.slice(this.startingRecord, this.endingRecord);
        //increment by 1 to display the startingRecord count,        
        this.startingRecord = this.startingRecord + 1;
        
    }
    //Handles the Keyup event of the search box.
    searchSupplierByName(event) {
        window.clearTimeout(this.delayTimeout);
        this.searchSuppliersStr = event.target.value.toLowerCase();
        //const searchKey = event.target.value;
        var searchList=[];
        if (this.searchSuppliersStr) {
            this.delayTimeout = setTimeout(() => {
                searchList = this.listOfSuppliersItems.filter(element => element.Name.toLowerCase().includes(this.searchSuppliersStr));
                this.listOfSuppliersDisplayed = searchList.slice(0, this.pageSize);

            }, 300);
            
        }
        else {
            this.showSuppliersPerPage(1);
        }
    }
    //Clears the seach text and returns to page 1
    clearSupplierSearch()
    {
        this.searchSuppliersStr ='';
        this.page=1;
        this.showSuppliersPerPage(1);
    }
    //event fired when an supplier tile is clicked and sends the supplier record to map child component
    sendSupplierRecordToMapMarker(event)
    {
        this.template.querySelector('c-map-marker-route').setSupplierMarker(event.detail);
    }
    
}