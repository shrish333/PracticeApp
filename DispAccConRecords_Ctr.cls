public with sharing class DispAccConRecords_Ctr {
    public List<Contact> ConList {get; set;}
    public Boolean isChecked {get; set;}
    public Id fetchedId {get; set;}
    public List<Id> con_list = new List<Id>();
    public DispAccConRecords_Ctr(ApexPages.StandardController controller) {
        isChecked = false;
        conList = new List<Contact>();
        conList = [SELECT Id, Name, Account.Id, Account.Name FROM Contact ORDER BY Name];
    }
    
    public void chkbx_click() {
        con_list.add(fetchedId);
        system.debug('===List of Ids in ckbxClick===' +con_list);
    }
    
    public void save_click() {
        Set<Id> con_set = new Set<Id>();
        List<Contact> con_updt = new List<Contact>();
        system.debug('===List of Ids in saveClick===' +con_list);
        if(con_list.size() > 0) {
            con_set.addAll(con_list);
            for (Id con_id : con_set) {
                contact con_record = new contact();
                con_record.id = con_id;
                con_record.Is_Primary__c = true;
                con_updt.add(con_record);
            }
        }
        if(con_updt.size() > 0) {
            UPDATE con_updt;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Record Updated'));
        }
    }
}