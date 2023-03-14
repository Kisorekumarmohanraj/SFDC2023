public with sharing class ContactController { 

    @AuraEnabled
    public static List<Account> saveAccounts(List<Account> lstAccs) {
        try {
            insert lstAccs;
            return lstAccs;
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ContactWrapper> getContacts() {
        List<ContactWrapper> contacts = new List<ContactWrapper>();
        List<Contact> contactList = [SELECT Name, Email, Phone FROM Contact];
        for (Contact c : contactList) {
            contacts.add(new ContactWrapper(c.Name, c.Email, c.Phone));
        }
        return contacts;
    }
    
     @AuraEnabled(cacheable=true)
    public static List<String> getRelatedNames(String strContactName) {
        List<String> relatedNames=new List<String>();
        for(contact c: [select id,name,phone from contact where phone =: strContactName]){
                relatedNames.add(c.name);
        }
        system.debug('relatedNames->'+relatedNames);
        return relatedNames;
    }

     @AuraEnabled(cacheable=true)
    public static List<AccountWrapper> getAccounts() {
        List<AccountWrapper> accounts = new List<AccountWrapper>();
        List<Account> accountList = [SELECT Name,  Phone FROM Account];
        for (Account c : accountList) {
            accounts.add(new AccountWrapper(c.Name,c.Phone));
        }
        return accounts;
    }
    public class ContactWrapper {
        @AuraEnabled public String name;
        @AuraEnabled public String email;
        @AuraEnabled public String phone;
        
        public ContactWrapper(String name, String email, String phone) {
            this.name = name;
            this.email = email;
            this.phone = phone;
        }
    }

    public class AccountWrapper {
        @AuraEnabled public String name; 
        @AuraEnabled public String phone;
        
        public AccountWrapper(String name, String phone) {
            this.name = name;
            this.phone = phone;
        }
    }
}