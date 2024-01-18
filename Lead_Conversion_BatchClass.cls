public class Lead_Conversion_BatchClass implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC){
   
        string query ='SELECT id,Name,IsConverted FROM Lead WHERE Name like \'%#%\' AND IsConverted=false limit 50000';
       return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<lead> leadList){
        if(leadList.size()>0)
        {
            List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            for (lead obj:leadList) {
                system.debug(obj.Name);
                Database.LeadConvert leadConvert = new Database.LeadConvert();
                leadConvert.setLeadId(obj.Id);
                
                // Specify additional conversion details if needed
                // leadConvert.setAccountId(accountId);
                // leadConvert.setContactId(contactId);
                // leadConvert.setOpportunityId(opportunityId);
                
                leadConvert.setConvertedStatus(convertStatus.MasterLabel);
                leadConverts.add(leadConvert);
            }
            if (leadConverts.size()>0) {
                system.debug('greater >0');
                List<Database.LeadConvertResult> convertResults = Database.convertLead(leadConverts);
            }  
        }
        else
        {
            
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
}