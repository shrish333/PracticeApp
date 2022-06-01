public class PrimaryContact_EmailAlert implements Database.Batchable<sObject> {
    public String query;
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        query = 'SELECT Name, Owner.Email, (SELECT Name FROM Contacts WHERE Is_Primary__c = true) FROM ACCOUNT WHERE Id IN (Select AccountId FROM Contact WHERE Is_Primary__c = true)';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Account> scope){
        
        for(account acc : scope) {
            String header = 'Account Name, Contact Name, Is_Primary \n';
            string combinedStr = header;
            for(contact con : acc.contacts) {
                System.debug('===Account Name is===' +acc.Name);
                System.debug('===Account Owner Email===' +acc.Owner.Email);
                System.debug('===Contact Name is===' +con.Name);    
                String recordStr = acc.Name+','+con.Name+','+'True'+'\n';
                combinedStr = combinedStr + recordStr;
                
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                blob csvBlob = Blob.valueOf(combinedStr);
                string csvname= 'Account.csv';
                csvAttc.setFileName(csvname);
                csvAttc.setBody(csvBlob);
                Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                String[] toAddresses = new list<string> {acc.Owner.Email};
                    String subject ='Account CSV';
                email.setSubject(subject);
                email.setToAddresses( toAddresses );
                email.setPlainTextBody('Account CSV ');
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                combinedStr = '';            
            }
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
}