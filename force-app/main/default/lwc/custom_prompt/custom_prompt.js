import { LightningElement, wire, track, api} from 'lwc';
import getVehicleDetails from '@salesforce/apex/Vehicle_Details.getPrompt'
import getCustomerDetails from '@salesforce/apex/Customer_Details.getPrompt'

export default class Custom_prompt extends LightningElement {

    @api recordId;
    @track responsePrompt;
    @track onSpinner = false;
    @track question 

    carDetailsMehtod(recordId) {
        console.log('Entra al metodo de details');
        getVehicleDetails({caseId: recordId})
        .then(result => {
            let res = result;
            console.log(res);
            let resp = JSON.parse(result);
            this.responsePrompt = resp.summary;
        })
        .catch(error => {
            console.log(error);
        })
        .finally(() => {
            this.onSpinner = false;
        })
    }

    customerDetailsMehtod(recordId) {
        getCustomerDetails({caseId: recordId})
        .then(result => {
            let res = result;
            console.log(res);
            this.responsePrompt = res;
        })
        .catch(error => {
            console.log(error);
        })
        .finally(() => {
            this.onSpinner = false;
        })
    }

    get options() {
        return [
            { label: 'What are the client’s car details?', value: 'carDetails' },
            { label: 'Was the client a GM customer?', value: 'customerDetails' },
        ];
    }

    handleChange(event) {
        this.question = event.detail.value;
        console.log('Value of Question ===> ' + this.question);
    }

    handleButton() {
        this.onSpinner = true;
        let ques = this.question;
        console.log('Question: '+ ques);
        let recordId = this.recordId;
        console.log('RecordId: '+ recordId);

        if(ques == 'carDetails') {
            this.carDetailsMehtod(recordId);
        } else {
            this.customerDetailsMehtod(recordId);
        }
        
    }


}