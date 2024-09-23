@SuppressWarnings('PMD.ApexCRUDViolation')
public with sharing class Customer_Details {
    @AuraEnabled
    public static string getPrompt(String caseId){

        List<Case> casePrompt = [SELECT Id, AccountId, Account.Vehicle__c FROM Case WHERE Id = :caseId];
        Final String vehicleId = casePrompt[0].Account.Vehicle__c;
        Final String accountId = casePrompt[0].AccountId;
        System.debug(vehicleId);

        //Create Inputs
        Map<String,String> caseData= new Map<String,String>();
        caseData.put('id', caseId);
        ConnectApi.WrappedValue caseValue = new ConnectApi.WrappedValue();
        caseValue.value = caseData;
        System.debug(caseValue);

        Map<String,String> accountData= new Map<String,String>();
        accountData.put('id', accountId);
        ConnectApi.WrappedValue accountValue = new ConnectApi.WrappedValue();
        accountValue.value = accountData;
        System.debug(accountValue);

        Map<String,String> vehicleData= new Map<String,String>();
        vehicleData.put('id', vehicleId);
        ConnectApi.WrappedValue vehicleValue = new ConnectApi.WrappedValue();
        vehicleValue.value = vehicleData;
        System.debug(vehicleValue);

        //Add all inputs into the Map
        Map<String,ConnectApi.WrappedValue> inputParams = new Map<String,ConnectApi.WrappedValue>();
        inputParams.put('Input:CaseId',caseValue);
        inputParams.put('Input:AccountId',accountValue);
        inputParams.put('Input:VehicleId',vehicleValue);
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
                'GM_Customer_Information',
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