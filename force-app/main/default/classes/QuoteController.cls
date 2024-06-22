/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-22-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class QuoteController {
    public Quote quote { get; private set; }    
    public String accountName { get; set; }
    public String CreatedByName { get; set; }
    public String CreatedByTitle { get; set; }
    public String CreatedByCompanyName { get; set; }
    public String ExpirationDate { get; private set; }
    public String todayDate { get; private set; }

    public List<Site_ID__c> siteIdDetails { get; set; }
    public List<QuoteLineItem> quoteLintItemDetailsNatural2Year { get; set; }
    public List<QuoteLineItem> quoteLintItemDetailsNatural3Year { get; set; }
    public List<QuoteLineItem> quoteLintItemDetailsNatural5Year { get; set; }

    public Decimal GasSubTotal2Year {get; set;}
    public Decimal GasSubTotal3Year {get; set;}
    public Decimal GasSubTotal5Year {get; set;}

    public String quoteId { get; set; }


    public QuoteController(ApexPages.StandardController stdController) {
        this.quote = (Quote)stdController.getRecord();
        quoteId = ApexPages.currentPage().getParameters().get('id');
        
          system.debug('quoteId up@@ ' + quoteId);
        
        if (quote.Id != null) {
            quote = [SELECT Id,Name, Opportunity.Account.Name ,Today_Date__c,ExpirationDate,QuoteNumber, CreatedBy.Name ,
                                        CreatedBy.Title, CreatedBy.CompanyName,
                                        (SELECT Id, Name, Service_Address__c,Site_ID_Type__c
                                        FROM Site_IDs__r
                                        WHERE Site_ID_Type__c = 'Natural Gas')
                                 FROM Quote 
                                 WHERE Id = :quote.Id 
                                 LIMIT 1];
            ExpirationDate = formatDate(quote.ExpirationDate);
             todayDate = formatDate(quote.Today_Date__c);
            // system.debug('ExpirationDate@@ ' + ExpirationDate);
            accountName = quote?.Opportunity?.Account?.Name;
            CreatedByName = (quote.CreatedBy.Name != null ? quote.CreatedBy.Name : '');
            CreatedByTitle = (quote.CreatedBy.Title != null ? quote.CreatedBy.Title : '');
            CreatedByCompanyName = (quote.CreatedBy.CompanyName != null ? quote.CreatedBy.CompanyName : '');

            List<Site_ID__c> siteIds = quote?.Site_IDs__r;
            siteIdDetails = new List<Site_ID__c>();

            if (siteIds != null && siteIds.size() > 0) {
                for (Site_ID__c s : siteIds) {
                    if (s != null) {
                        siteIdDetails.add(s);
                    }
                }
            }

            //for Natural gas Quote line item 2 year
            Quote naturalGasquoteLineItem2year = [SELECT Id, (SELECT Id, Product2.Name,Subtotal
                                                    FROM QuoteLineItems
                                                    Where Product2.Name LIKE '%Natural Gas%' AND
                                                    Product2.Name LIKE '%2 year%')
                                                    FROM Quote WHERE Id = :quote.Id];

            List<QuoteLineItem> naturalGasLineItem2year = naturalGasquoteLineItem2year?.QuoteLineItems;
            quoteLintItemDetailsNatural2Year = new List<QuoteLineItem>();

            Decimal Total2year = 0;
            if (naturalGasLineItem2year != null && naturalGasLineItem2year.size() > 0) {
                for (QuoteLineItem qlI : naturalGasLineItem2year) {
                    if (qlI.Subtotal != null) {
                        quoteLintItemDetailsNatural2Year.add(qlI);
                        Total2year += qlI.Subtotal;
                    }
                    //else {
                        //Total2year = 0;
                    //}
                }
                // System.debug('quoteLintItemDetailsNatural2Year ---->'+quoteLintItemDetailsNatural2Year);
                // System.debug('Total2year ---->'+Total2year);
                GasSubTotal2Year = Total2year;
                // System.debug('GasSubTotal2Year ---->'+GasSubTotal2Year);
            }else {
                GasSubTotal2Year = 0;
            }

            //for Natural gas Quote line item 3 year
            Quote naturalGasquoteLineItem3year = [SELECT Id, (SELECT Id, Product2.Name,Subtotal
                                                    FROM QuoteLineItems
                                                    Where Product2.Name LIKE '%Natural Gas%' AND
                                                    Product2.Name LIKE '%3 year%')
                                                    FROM Quote WHERE Id = :quote.Id];

            List<QuoteLineItem> naturalGasLineItem3year = naturalGasquoteLineItem3year?.QuoteLineItems;
            quoteLintItemDetailsNatural3Year = new List<QuoteLineItem>();
            Decimal Total3year = 0;
            if (naturalGasLineItem3year != null && naturalGasLineItem3year.size() > 0) {
                for (QuoteLineItem qlI : naturalGasLineItem3year) {
                    if (qlI != null) {
                        quoteLintItemDetailsNatural3Year.add(qlI);
                        Total3year += qlI.Subtotal;
                    }
                    //else {
                        //Total3year = 0;
                    //}
                }
                // System.debug('quoteLintItemDetailsNatural3Year ---->'+quoteLintItemDetailsNatural3Year);
                // System.debug('Total3year ---->'+Total3year);
                GasSubTotal3Year = Total3year;
                // System.debug('GasSubTotal3Year ---->'+GasSubTotal3Year);
            }else {
                GasSubTotal3Year = 0;
            }

            //for Natural gas Quote line item 5 year
            Quote naturalGasquoteLineItem5year = [SELECT Id, (SELECT Id, Product2.Name,Subtotal
                                                    FROM QuoteLineItems
                                                    Where Product2.Name LIKE '%Natural Gas%' AND
                                                    Product2.Name LIKE '%5 year%')
                                                    FROM Quote WHERE Id = :quote.Id];

            List<QuoteLineItem> naturalGasLineItem5year = naturalGasquoteLineItem5year?.QuoteLineItems;
            quoteLintItemDetailsNatural5Year = new List<QuoteLineItem>();
            Decimal Total5year = 0;
            if (naturalGasLineItem5year != null && naturalGasLineItem5year.size() > 0) {
                for (QuoteLineItem qlI : naturalGasLineItem5year) {
                    if (qlI != null) {
                        quoteLintItemDetailsNatural5Year.add(qlI);
                        Total5year += qlI.Subtotal;
                    }
                    //else {
                        //Total5year = 0;
                    //}
                }
                //System.debug('quoteLintItemDetailsNatural5Year ---->'+quoteLintItemDetailsNatural5Year);
                //System.debug('Total5year ---->'+Total5year);
                GasSubTotal5Year = Total5year;
                // System.debug('GasSubTotal5Year ---->'+GasSubTotal5Year);
            }else {
                GasSubTotal5Year = 0;
            }
            
        }
    }
    
     private String formatDate(Date formatdate) {
        if (formatdate == null) return '';
        DateTime dt = DateTime.newInstance(formatdate.year(), formatdate.month(), formatdate.day());
         system.debug('dt@@ ' + dt);
        return dt.format('dd-MM-yyyy');
    }
    

    public PageReference generatePdfAndAttach() {
        // Generate the PDF content
          system.debug('quoteId@@ ' + quoteId);
        PageReference pdfPage = Page.CreateNaturalGasPage; // Ensure this matches your VF page name
        pdfPage.getParameters().put('id', quoteId);
        Blob pdfBlob;
        try {
            if (!Test.isRunningTest()) {
                pdfBlob = pdfPage.getContentAsPDF();
            } else {
                pdfBlob = Blob.valueOf('Mock PDF Content');
            }
        } catch (VisualforceException e) {
            System.debug('Error on PDF generation => '+e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error generating PDF: ' + e.getMessage()));
            return null;
        }
        
        
        ContentVersion conVer = NEW ContentVersion();
        conVer.ContentLocation = 'S'; // TO USE S specify this document IS IN Salesforce, TO USE E FOR external files
        conVer.PathOnClient = quote.Name+'.pdf'; 
        conVer.Title = quote.Name+'.pdf'; 
        conVer.VersionData = pdfBlob;
        system.debug('conVer@@ ' + conVer);
        INSERT conVer;  

        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;

        ContentDocumentLink conDocLink = NEW ContentDocumentLink();
        conDocLink.LinkedEntityId = quoteId;
        conDocLink.ContentDocumentId = conDoc; 
        conDocLink.shareType = 'V';
        INSERT conDocLink;
        
    
        PageReference redirect = new PageReference('/' + quoteId);
        redirect.setRedirect(true);
        return redirect;
    }
    
    public PageReference cancel() {
        // Redirect to the detail page of the current Quote record
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
    }
}