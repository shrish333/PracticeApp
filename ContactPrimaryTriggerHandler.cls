public class ContactPrimaryTriggerHandler {
    public static void primaryCheck(List<Contact> newConList, List<Contact> oldConList) {
        List<Contact> cnlst = new List<Contact>();
        for(Contact cn1 : newConList) {
            for(Contact cn2 : oldConList) {
                if(cn1.Is_Primary__c == true && cn2.Is_Primary__c == false) {
                    cnlst.add(cn1);
                    if(cnlst.size() > 1) {
                        cn1.addError('Only one record can be marked as primary');
                    }
                }
            }
        }
    } 
}