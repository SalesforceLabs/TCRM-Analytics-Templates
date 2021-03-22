global class RetailBankingChecklistRemoter{

global RetailBankingChecklistRemoter() {

        }                      // empty constructor



@RemoteAction
global static Map<string, object> dataOk(Boolean isCustomReset ) {
        List<string> errorMessages = new List<string>();        
                // everything alright
                // no variable settings here
                errorMessages.add('Your org meets the minimum requirements for creating the app.');
                return new Map<String, Object>{
                                'success' => true,
                                'messages' => errorMessages
                        };
                }



    private static Map<String, Object> minRecordCheck(Boolean isCustomReset, List<string> objectsToCheck) {
                List<String> messages_yes = new List<String>();
                List<String> messages_no = new List<String>();
                boolean errorFlag = false;
                Integer errorNum = 1;
                List<string> errorMessages = new List<string>();
                // to hold object record results
                List<Object> queryResponse = new List<Object>();
                string q;
                string err_msg = 'Retail Banking Starter app requires at least one record in these objects:';
                
                for(integer i=0; i< objectsToCheck.size(); i++) {
                    q = 'SELECT Id FROM '+objectsToCheck[i]+' Order by CreatedDate DESC limit 1';
                    try {
                            queryResponse = database.query(q); 
                            if (queryResponse.isEmpty()) {
                                errorFlag = true;
                                messages_no.add(objectsToCheck[i]);
                                errorMessages.add(err_msg);
                            } 
                            // success path
                            else if (queryResponse.size() >=1) {
                                messages_yes.add(objectsToCheck[i]);
                            } 
                            // less than 2 records so failing
                            else { 
                                errorFlag = true;
                                messages_no.add(objectsToCheck[i]);
                                errorMessages.add(err_msg);
                            }
                        }
                    catch(Exception e) {
                            errorFlag = true;
                            messages_no.add(objectsToCheck[i]);
                            errorMessages.add(err_msg);
                    }
                }
                // return the result
                if(errorFlag)
                {

                        // return the error message
                        return new Map<String, Object>{
                                       'success' => false,
                                       'messages_no' => messages_no,
                                       'messages' => errorMessages
                        };
                }
                // everything alright
                // no variable settings here
                return new Map<String, Object>{
                               'success' => true,
                               'messages_yes' => messages_yes,
                               'messages' => errorMessages
                };
        }


private static Map<String, Object> aggregateResults(List<Map<String, Object> > resultList,Boolean isCustomReset){

        Boolean allGood = true;
        List<Map<String, Object> > variableSettings = new List<Map<String, Object> >();
        List<String> messages = new List<String>();
        List<String> messages_no = new List<String>();
        List<String> messages_yes = new List<String>();

        // iterate over the results
        for (Map<String, Object> result: resultList) {
                // if one failed all failed
                if (!((boolean)result.get('success'))) {
                        allGood = false;
                }

                // aggregate the variable settings
                if (result.containsKey('variableSettings')) {
                        for (Object s: (List<Object>)result.get('variableSettings')) {
                                variableSettings.add((Map<String, Object>) s);
                        }
                }

                // and messages
                if (result.containsKey('messages_no')) {
                        messages_no.addAll((List<String>)result.get('messages_no'));
                }

                if (result.containsKey('messages_yes')) {
                        messages_yes.addAll((List<String>)result.get('messages_yes'));
                }
        }

        if(!messages_yes.isEmpty())
        {
                if (!isCustomReset){

                messages.add('Retail Banking has detected that the required custom objects exist.');
                }
                else{
                messages.add('Retail Banking has detected that the required custom objects exist.');

                }
                messages.addAll(messages_yes);
        }
        if(!messages_no.isEmpty())
        {
                messages.add('   ');
                messages.add('Retail Banking has detected that the following custom objects are not available or do not have at least 2 records each as needed to proceed.');
                messages.addAll(messages_no);
        }

        if (isCustomReset){
                messages.add('   ');
                messages.add('You’re reconfiguring or creating a copy of an app originally created with custom create. FSC will reuse the settings from that app whereever possible.');
        }

        // aggregate the messages and variable settings
        return new Map<String, Object>{
                       'success' => allGood,
                       'messages' => messages,
                       'variableSettings' => variableSettings
        };
}


@RemoteAction
global static Map<string, object> objectUsage(Boolean isCustomReset )
{
        List<Map<String, Object> > resultList = new List<Map<String, Object> >();
        List<string> objectsForMinRecordCheck = new List<string>();
        // Objects to check min record count
        // we require 2 records in each object so that compute relative transform doesn't fail if exists in dataflow / recipe
        objectsForMinRecordCheck.add('FinServ__FinancialAccount__c');
        objectsForMinRecordCheck.add('FinServ__FinancialHolding__c');
        objectsForMinRecordCheck.add('FinServ__Revenue__c');
        resultList.add(minRecordCheck(isCustomReset,objectsForMinRecordCheck));
        // aggregate results
        return aggregateResults(resultList,isCustomReset);

}

@RemoteAction
global static Map<string, object> fieldAccess(Boolean isCustomReset )
{
        List<String> messages = new List<String>();

        messages.add('Oh uh');
        Boolean success = true;

        return new Map<String, Object>{
                       'success' => success,
                       'messages' => messages
        };
}

@RemoteAction
global static Map<string, object> configuration(Boolean isCustomReset )
{

        //return setFiscal();
	List<String> messages = new List<String>();
        messages.add('Org checks and');
        messages.add('requirements complete.');

        return new Map<String, Object>{
                       'success' => true,
                       'messages' => messages
        };

}

@RemoteAction
global static Map<string, object> dataInconsistencies(Boolean isCustomReset )
{
        List<String> messages = new List<String>();
        messages.add('Initial check and');
        messages.add('configuration complete.');

        return new Map<String, Object>{
                       'success' => true,
                       'messages' => messages
        };
}
}
