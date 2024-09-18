@SuppressWarnings('PMD.ClassNamingConventions')
public with sharing class generatePrompt {

    @AuraEnabled
    public static string getPrompt(String name){

        //Create Inputs
        Map<String,String> nameCustomer = new Map<String,String>();
        nameCustomer.put('id', name);
        ConnectApi.WrappedValue nameValue = new ConnectApi.WrappedValue();
        nameValue.value = nameCustomer;
        System.debug(nameValue);
        Map<String,ConnectApi.WrappedValue> inputParams = new Map<String,ConnectApi.WrappedValue>();
        inputParams.put('Input:Name',nameValue);
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
                'Hello_World',
                executeTemplateInput
            );
            System.debug(generationsOutput);
            //System.debug(generationsOutput);
            ConnectApi.EinsteinLLMGenerationItemOutput response = generationsOutput.generations[0];
            System.debug(response);
            String resp = response.text; 
            return resp;

        }catch(Exception e) {
            System.debug(e.getMessage());
            throw e;
        }

    }

}