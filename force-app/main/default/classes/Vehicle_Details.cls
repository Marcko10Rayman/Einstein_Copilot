@SuppressWarnings('PMD.ApexCRUDViolation')
public with sharing class Vehicle_Details {

    @AuraEnabled
    public static string getPrompt(String caseId){

        List<Case> casePrompt = [SELECT Id, Account.Vehicle__c FROM Case WHERE Id = :caseId];
        String vehicleId = casePrompt[0].Account.Vehicle__c;
        System.debug(vehicleId);

        //Create Inputs
        Map<String,String> vehicleData= new Map<String,String>();
        vehicleData.put('id', vehicleId);
        ConnectApi.WrappedValue vehicleValue = new ConnectApi.WrappedValue();
        vehicleValue.value = vehicleData;
        System.debug(vehicleValue);
        Map<String,ConnectApi.WrappedValue> inputParams = new Map<String,ConnectApi.WrappedValue>();
        inputParams.put('Input:Vehicles__c',vehicleValue);
        System.debug(inputParams);

        //Configure invocation params
        ConnectApi.EinsteinPromptTemplateGenerationsInput executeTemplateInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        executeTemplateInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
        executeTemplateInput.additionalConfig.applicationName = 'PromptBuilderPreview';
        executeTemplateInput.isPreview = false;
        executeTemplateInput.inputParams = inputParams;
        System.debug(executeTemplateInput);

        try {
            //Call the service
            ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
                'Vehicle_Details',
                executeTemplateInput
            );
            System.debug(generationsOutput);
            //System.debug(generationsOutput);
            ConnectApi.EinsteinLLMGenerationItemOutput response = generationsOutput.generations[0];
            System.debug(response);
            String resp = response.text; 
            System.debug(resp);
            return resp;

        }catch(Exception e) {
            System.debug(e.getMessage());
            throw e;
        }

    }

}