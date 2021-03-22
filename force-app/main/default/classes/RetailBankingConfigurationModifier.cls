/** FSCWaveConfig
* Smart Wizard - Apex class to auto scan FSC ORG and pre-poulate wizard Questions
* Developer: Srinivasa Peddireddy,Salil Deshmukh,George Marathakis
* Date: Oct, 2016 , Jul 2017, April 2018
* */

public with sharing class RetailBankingConfigurationModifier extends wavetemplate.WaveTemplateConfigurationModifier{

    //*********************Validation Before APP Creation**************************************************
    // Executes when we click on Create-APP button
    public override void beforeAppCreate(wavetemplate.WaveTemplateInfo template, wavetemplate.Answers answers)
    {
        // Get the user preference on org scanning
        String ScanOrg_ans = (String) answers.get('ScanOrg');
        setCustom(template, answers);
    }

    //*********************Validation Before APP Update**************************************************
    // Executes when we click on Reset or Update button
     public override void beforeAppUpdate(wavetemplate.WaveTemplateInfo template, String previousAppVersion, wavetemplate.Answers answers)
     {
         // Get the user preference on org scanning
         String ScanOrg_ans = (String) answers.get('ScanOrg');
         setCustom(template, answers);
     }

    

    private void setCustom(wavetemplate.WaveTemplateInfo template, wavetemplate.Answers answers)
    {

            String autoconfig_ans = (String) answers.get('autoconfig');
            if (autoconfig_ans == 'true'){

            System.debug('Setting Custom app to false');
            //answers.put('isCustomApp', 'false');
            answers.put('isCustomApp', false);
            }
            else{

            System.debug('Setting Custom app to true');
            //answers.put('isCustomApp', 'true');
            answers.put('isCustomApp', true);
            }

    }
}
