/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-25-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class ElectricityPdfControllerTest {

    @testSetup
    static void setupTestData() {
        // Create test Account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create test Opportunity
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity', 
            StageName = 'Prospecting', 
            CloseDate = Date.today().addDays(30), 
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        // Create test Quote
        Quote testQuote = new Quote(
            Name = 'Test Quote',
            OpportunityId = testOpportunity.Id,
            ExpirationDate = Date.today().addDays(10),
            Pricebook2Id = Test.getStandardPricebookId()
        );
        insert testQuote;

        // Create test Site_ID__c records
        Site_ID__c siteId1 = new Site_ID__c(
            Name = '0030111149086',
            Service_Address__c = '123 Test Street',
            Site_ID_Type__c = 'Electricity',
            Quote__c = testQuote.Id,
            Account_Name__c = testAccount.Id
        );
        insert siteId1;

		Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            Name = 'Standard Price Book',
            IsActive = true
        );
        update standardPricebook;
        
        Product2 prod2Year = new Product2(Name = 'Electricity 2 year', IsActive = true);
        insert prod2Year;
        PricebookEntry pbe2Year = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = prod2Year.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe2year;
        Product2 prod3Year = new Product2(Name = 'Electricity 3 year', IsActive = true);
        insert prod3Year;
        PricebookEntry pbe3Year = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = prod3Year.Id,
            UnitPrice = 200,
            IsActive = true
        );
        
        insert pbe3year;
        Product2 prod5Year = new Product2(Name = 'Electricity 5 year', IsActive = true);
        insert prod5Year;
        PricebookEntry pbe5Year = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = prod5Year.Id,
            UnitPrice = 300,
            IsActive = true
        );
        insert pbe5year;

        // Create test QuoteLineItems
        QuoteLineItem qli2Year = new QuoteLineItem(
            QuoteId = testQuote.Id,
            PricebookEntryId = pbe2Year.Id,
            Quantity = 1,
            UnitPrice = 100
        );
        QuoteLineItem qli3Year = new QuoteLineItem(
            QuoteId = testQuote.Id,
            PricebookEntryId = pbe3Year.Id,
            Quantity = 1,
            UnitPrice = 200
        );
        QuoteLineItem qli5Year = new QuoteLineItem(
            QuoteId = testQuote.Id,
            PricebookEntryId = pbe5Year.Id,
            Quantity = 1,
            UnitPrice = 300
        );
        insert new List<QuoteLineItem> { qli2Year, qli3Year, qli5Year };
    }
    
    @isTest
    static void testElectricityPdfController() {
        // Retrieve test data
        Quote testQuote = [SELECT Id,Name FROM Quote LIMIT 1];

        // Set current page parameters
        ApexPages.currentPage().getParameters().put('id', testQuote.Id);

        // Initialize the controller
        ApexPages.StandardController sc = new ApexPages.StandardController(testQuote);
        ElectricityPdfController controller = new ElectricityPdfController(sc);

        // Assert initializations
        System.assertNotEquals(null, controller.quote);
        System.assertEquals(testQuote.Id, controller.quote.Id);
        System.assertNotEquals(null, controller.siteIdDetailsElectricity);
        System.assertNotEquals(null, controller.quoteLintItemDetailselectricity2Year);
        System.assertNotEquals(null, controller.quoteLintItemDetailselectricity3Year);
        System.assertNotEquals(null, controller.quoteLintItemDetailselectricity5Year);
        
        // Test GasSubTotal values
        System.assertEquals(100, controller.ElectricSubTotal2Year);
        System.assertEquals(200, controller.ElectricSubTotal3Year);
        System.assertEquals(300, controller.ElectricSubTotal5Year);

        PageReference pdfPage = Page.ElectricityPdfPage;
        Test.setCurrentPage(pdfPage);
        pdfPage.getParameters().put('id', testQuote.Id);
        
        Test.startTest();
        // Create an instance of the controller
        // Test PDF generation method
        PageReference pageRef = Page.ElectricityPdfPage;
        pageRef.getParameters().put('id', testQuote.Id);
        Test.setCurrentPage(pageRef);
        PageReference result = controller.generatePdfAndAttach();
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Resulting PageReference should not be null');
        System.assertEquals('/' + testQuote.Id, result.getUrl(), 'The resulting URL should be the Quote Id');
        
        // Verify that the ContentVersion and ContentDocumentLink were created
        List<ContentVersion> cvList = [SELECT Id, Title FROM ContentVersion WHERE Title = :testQuote.Name + '.pdf'];
        System.assertNotEquals(0, cvList.size(), 'There should be at least one ContentVersion record');
        System.assertEquals(testQuote.Name + '.pdf', cvList[0].Title, 'ContentVersion Title should match');

        List<ContentDocumentLink> cdlList = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :testQuote.Id];
        System.assertNotEquals(0, cdlList.size(), 'There should be at least one ContentDocumentLink record');
        System.assertEquals(testQuote.Id, cdlList[0].LinkedEntityId, 'ContentDocumentLink LinkedEntityId should match');
        
        PageReference cancelPage = controller.cancel();
        System.assertEquals('/' + testQuote.Id, cancelPage.getUrl());
    }
    
    @isTest
    static void testSubTotalIsZero() {
        List<QuoteLineItem> quoteLines = [SELECT Id FROM QuoteLineItem];
        delete quoteLines;
        
        Quote testQuote = [SELECT Id FROM Quote LIMIT 1];

        // Set current page parameters
        ApexPages.currentPage().getParameters().put('id', testQuote.Id);

        // Initialize the controller
        ApexPages.StandardController sc = new ApexPages.StandardController(testQuote);
        ElectricityPdfController controller = new ElectricityPdfController(sc);
    }
}