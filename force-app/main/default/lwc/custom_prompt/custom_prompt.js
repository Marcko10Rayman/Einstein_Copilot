import { LightningElement, wire, track, api} from 'lwc';
import getVehicleDetails from '@salesforce/apex/Vehicle_Details.getPrompt'

export default class Custom_prompt extends LightningElement {

    @api recordId;
    @track responsePrompt;
    @track onSpinner = false;

    handleButton() {
        this.onSpinner = true;
        let recordId = this.recordId;
        console.log('RecordId: '+ recordId);
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


}