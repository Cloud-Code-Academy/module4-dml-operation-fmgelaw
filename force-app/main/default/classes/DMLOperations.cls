/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Fikirte Gelaw
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account acc = new Account();
        ID insertedAccId;
        // Set some fields on the Account
        acc.Name = 'DmlInsertTest-' + String.valueOf(Datetime.now().getTime());
        // Insert the Account into the database
        //insert acc;
         // Insert the Account using Database.insert with AccessLevel
        Database.SaveResult result = Database.insert(acc, false, AccessLevel.USER_MODE);
        //AccessLevel.USER_MODE ensures the operation respects field-level security (FLS) and object-level permissions.
        //he second parameter false means partial success is allowed
        // Return the Id of the newly created Account
        // Check if the insert was successful
        if (result.isSuccess()) {
            insertedAccId = result.getId();
        } else {
        // Optionally handle errors here
        //even for single recored insert error could be multiple
            for (Database.Error err : result.getErrors()) {
                System.debug('Insert failed: ' + err.getMessage());
            }
        }
        return insertedAccId;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account acc = new Account(Name = name, Industry = industry);
        // Insert the Account
        insert acc;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact con = new Contact();
        // Set some fields on the Contact
        con.LastName = 'Test';
        // Set the AccountId field to the given accountId
        con.AccountId = accountId;
        // Insert the Contact into the database
        insert con;
        // Return the Id of the newly created Contact
        return con.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        ////you need to inclued the field you will be modifing a field in list of fields you are retriving
        Contact con = [SELECT Id, LastName FROM Contact WHERE Id = :contactId];
        // Update the Contact's last name
        con.LastName = newLastName;
        // Update the Contact in the database
        Update con;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppId];
        // Update the Opportunity's stage
        opp.StageName = newStage;
        // Update the Opportunity in the database
        update opp;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        Account acc = [SELECT Id, Name, Industry FROM Account WHERE Id = :accountId];
        // Update the Account with the given Id with the new name and industry
        acc.Name = newName;
        acc.Industry = newIndustry;
        // Update the Account in the database
        update acc;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
            // Set the Opportunity's Stage to Qualification
            // Set the Opportunity's Close Date to 3 months from today
            // Set the Opportunity's Amount to 50000
        // Upsert the opportunities List so that records are either updated or created
        for(Opportunity opp : opportunities) {
            opp.StageName = 'Qualification';
            opp.CloseDate = Date.today().addMonths(3);
            opp.Amount = 50000;
        }
        upsert opportunities;
    }

    /**
     * Question 8
     * Insert or update opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * HINT: There should not be duplicate opportunites based on the name
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // Loop through each Opportunity name
            // Create an Opportunity with the given name
            // Add the Opportunity to the list
        // Upsert the list of Opportunities
        Account acc = new Account(Name = accountName);
        Upsert acc;

        List<Opportunity> oppList = new List<Opportunity>();
        List<String> existingOppNames = new List<String>();
        
        //Look for Opportunities whose name is in the list of names and are also associated with the give account.
        for (Opportunity opp : [SELECT Name FROM Opportunity WHERE Name NOT IN :oppNames AND AccountId = :acc.Id]) {
            existingOppNames.add(opp.Name);
        }
        
        for(String oppName : oppNames){   
            if(!existingOppNames.contains(oppName)){
                Opportunity opp = new Opportunity(Name = oppName, AccountId = acc.id, StageName = 'Prospecting', CloseDate = Date.today().addMonths(1));
                oppList.add(opp);
            }
        }
        Upsert oppList;
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
    public static Account upsertAccount(String accountName) {
		// Query for the Account
	List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];
        Account acc = new Account();
	// if the Account exists, update the description
        // otherwise, create a new Account and set the description
        if(!accounts.isEmpty()){
            acc.Id = accounts[0].Id;
            acc.Description = 'Updated Account';
        } else {
            acc.Name = accountName;
            acc.Description = 'New Account';
        }
	// Upsert the Account
        Upsert acc;
     	return acc;
     }

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
     public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
	// Loop through each Contact
        //List<Contact> updatedContactList = new List<Contact>(); //You don't actually need this extra List, 
        //just update the records in the List provided as an argument and then upsert that List.
        List<String> conLastNames = new List<String>();
        for (Contact con: contactsToUpsert) {
            conLastNames.add(con.LastName);
        }
        // Extract the Account Name from Contact's LastName
        List<Account> accList = [SELECT Id, Name FROM Account WHERE Name IN :conLastNames];
		Map<String,Account> conLastNameToaccMap = new Map<String,Account>();
		// Get the account based on the name or create one if it doesn't exist
        for (Account acc : accList) {
            conLastNameToaccMap.put(acc.Name, acc);
        }
		// Link the Contact to its Account using the Account Id
        for(Contact con : contactsToUpsert) {
            if(!conLastNameToaccMap.containsKey(con.LastName)) {
                Account acc = upsertAccount(con.LastName);
                con.AccountId = acc.Id;
            } else {
                con.AccountId = conLastNameToaccMap.get(con.LastName).Id;
            }
           // updatedContactList.add(con);
        }
		// Upsert the Contacts
        //upsert updatedContactList;
        upsert contactsToUpsert;
     }

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        List<Lead> leadToInsert = new List<Lead>();
        // Loop through each Lead name
        for(String leadName: leadNames){
            Lead lead = new Lead(LastName = leadName, Company = 'Test Company', Status = 'Open - Not Contacted');
            leadToInsert.add(lead);
        }
        // Insert the Leads
        insert leadToInsert;
        // Delete the Leads
        delete leadToInsert;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // Insert the cases
        List<Case> caseToInsert = new List<Case>();
        for(Integer i = 0; i < numOfCases; i++) {
            Case newCase = new Case(AccountId = accountId, Status = 'New', Origin = 'Web');
            caseToInsert.add(newCase);
            }
        insert caseToInsert;
        // Delete the cases
        delete caseToInsert;
    }
}
