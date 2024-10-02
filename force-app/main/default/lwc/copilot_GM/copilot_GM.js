import { LightningElement, wire, track, api} from 'lwc';
import getVehicleDetails from '@salesforce/apex/Vehicle_Details.getPrompt'
import getCustomerDetails from '@salesforce/apex/Customer_Details.getPrompt'

export default class Copilot_GM extends LightningElement {

    flowName = 'Prompt_Questions';
    @api recordId;
    @track onSpinner = false;
    @track responsePrompt;
    @track inputVariables = [];
    

    async connectedCallback() {
        this.onSpinner = true;
        try{
            let resp = await getVehicleDetails({caseId: this.recordId});
            console.log(resp);
            let respJSON = JSON.parse(resp);
            let responseApex = respJSON.summary;
            let flowVariable = this.createVarable('answerOne',responseApex);
            this.inputVariables.push(flowVariable);
            console.log('Termina el primer await');
            console.log('Comienza el siguiente await');
            let answer2 = await getCustomerDetails({caseId: this.recordId});
            console.log(answer2);
            flowVariable = this.createVarable('answerTwo', answer2);
            console.log(flowVariable);
            this.inputVariables.push(flowVariable);
        }catch(error) {
            console.log(error);
        }
        this.onSpinner = false;
    }

    createVarable(name, response) {
        return {
            name: name,
            type: 'String',
            value: response
        }
    }
    
    handleStatusChange(event) {
    if (event.detail.status === "FINISHED") {
        // set behavior after a finished flow interview.
    }
    }
}