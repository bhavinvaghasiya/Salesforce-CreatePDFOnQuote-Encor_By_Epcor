/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-25-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ElectricityPdfController {
    public Quote quote { get; private set; }
    
    public String accountName { get; set; }
    public String CreatedByName { get; set; }
    public String CreatedByTitle { get; set; }
    public String CreatedByCompanyName { get; set; }
    public String ExpirationDate { get; private set; }
    public String todayDate { get; private set; }
    
    public List<Site_ID__c> siteIdDetailsElectricity { get; set; }
    
    public List<QuoteLineItem> quoteLintItemDetailselectricity2Year { get; set; }
    public List<QuoteLineItem> quoteLintItemDetailselectricity3Year { get; set; }
    public List<QuoteLineItem> quoteLintItemDetailselectricity5Year { get; set; }

    public Decimal ElectricSubTotal2Year {get; set;}
    public Decimal ElectricSubTotal3Year {get; set;}
    public Decimal ElectricSubTotal5Year {get; set;}
    public Id quoteId { get; set; }


    public ElectricityPdfController(ApexPages.StandardController stdController) {
        this.quote = (Quote)stdController.getRecord();
        quoteId = ApexPages.currentPage().getParameters().get('id');
        
        if (quote.Id != null) {
            //for electricity data
            quote = [SELECT Id,Name, Opportunity.Account.Name , CreatedBy.Name ,Today_Date__c,ExpirationDate,QuoteNumber,
                                        CreatedBy.Title, CreatedBy.CompanyName,
                                        (SELECT Id, Name, Service_Address__c,Site_ID_Type__c
                                        FROM Site_IDs__r
                                        WHERE Site_ID_Type__c = 'Electricity')
                                 FROM Quote 
                                 WHERE Id = :quote.Id 
                                 LIMIT 1];

            ExpirationDate = formatDate(quote.ExpirationDate);
            todayDate = formatDate(quote.Today_Date__c);
            accountName = quote?.Opportunity?.Account?.Name;
            CreatedByName = quote?.CreatedBy?.Name;
            CreatedByTitle = (quote.CreatedBy.Title != null ? quote.CreatedBy.Title : '');
            CreatedByCompanyName = (quote.CreatedBy.CompanyName != null ? quote.CreatedBy.CompanyName : '');

            List<Site_ID__c> siteIdsElectricity = quote?.Site_IDs__r;
            siteIdDetailsElectricity = new List<Site_ID__c>();

            if (siteIdsElectricity != null && siteIdsElectricity.size() > 0) {
                for (Site_ID__c se : siteIdsElectricity) {
                    if (se != null) {
                        siteIdDetailsElectricity.add(se);
                    }
                }
            }

            //for Electriccity Quote line item 2 year
            Quote electricityQuoteLineItem2year = [SELECT Id, (SELECT Id, Product2.Name,Subtotal
                                                    FROM QuoteLineItems
                                                    Where Product2.Name LIKE '%Electricity%' AND
                                                    Product2.Name LIKE '%2 year%')
                                                    FROM Quote WHERE Id = :quote.Id];

            List<QuoteLineItem> electricityLineItem2year = electricityQuoteLineItem2year?.QuoteLineItems;
            quoteLintItemDetailselectricity2Year = new List<QuoteLineItem>();
            Decimal eTotal2year = 0;
            if (electricityLineItem2year != null && electricityLineItem2year.size() > 0) {
                for (QuoteLineItem qlI : electricityLineItem2year) {
                    if (qlI != null) {
                        quoteLintItemDetailselectricity2Year.add(qlI);
                        eTotal2year += qlI.Subtotal;
                    }
                    //else {
                      //  eTotal2year = 0;
                    //}
                }
                System.debug('quoteLintItemDetailselectricity2Year ---->'+quoteLintItemDetailselectricity2Year);
                System.debug('eTotal2year ---->'+eTotal2year);
                ElectricSubTotal2Year = eTotal2year;
                System.debug('ElectricSubTotal2Year ---->'+ElectricSubTotal2Year);
            }else {
                ElectricSubTotal2Year = 0;
            }

            //for Electriccity Quote line item 3 year
            Quote electricityQuoteLineItem3year = [SELECT Id, (SELECT Id, Product2.Name,Subtotal
                                                    FROM QuoteLineItems
                                                    Where Product2.Name LIKE '%Electricity%' AND
                                                    Product2.Name LIKE '%3 year%')
                                                    FROM Quote WHERE Id = :quote.Id];

            List<QuoteLineItem> electricityLineItem3year = electricityQuoteLineItem3year?.QuoteLineItems;
            quoteLintItemDetailselectricity3Year = new List<QuoteLineItem>();
            Decimal eTotal3year = 0;
            if (electricityLineItem3year != null && electricityLineItem3year.size() > 0) {
                for (QuoteLineItem qlI : electricityLineItem3year) {
                    if (qlI != null) {
                        quoteLintItemDetailselectricity3Year.add(qlI);
                        eTotal3year += qlI.Subtotal;
                    }
                    //else {
                       // eTotal3year = 0;
                    //}
                }
                System.debug('quoteLintItemDetailselectricity3Year ---->'+quoteLintItemDetailselectricity3Year);
                System.debug('eTotal3year ---->'+eTotal3year);
                ElectricSubTotal3Year = eTotal3year;
                System.debug('ElectricSubTotal3Year ---->'+ElectricSubTotal3Year);
            }else {
                ElectricSubTotal3Year = 0;
            }

            //for Electriccity Quote line item 5 year
            Quote electricityQuoteLineItem5year = [SELECT Id, (SELECT Id, Product2.Name,Subtotal
                                                    FROM QuoteLineItems
                                                    Where Product2.Name LIKE '%Electricity%' AND
                                                    Product2.Name LIKE '%5 year%')
                                                    FROM Quote WHERE Id = :quote.Id];

            List<QuoteLineItem> electricityLineItem5year = electricityQuoteLineItem5year?.QuoteLineItems;
            quoteLintItemDetailselectricity5Year = new List<QuoteLineItem>();
            Decimal eTotal5year = 0;
            if (electricityLineItem5year != null && electricityLineItem5year.size() > 0) {
                for (QuoteLineItem qlI : electricityLineItem5year) {
                    if (qlI != null) {
                        quoteLintItemDetailselectricity5Year.add(qlI);
                        eTotal5year += qlI.Subtotal;
                    }
                    //else {
                    //    eTotal5year = 0;
                   // }
                }
                System.debug('quoteLintItemDetailselectricity5Year ---->'+quoteLintItemDetailselectricity5Year);
                System.debug('eTotal5year ---->'+eTotal5year);
                ElectricSubTotal5Year = eTotal5year;
                System.debug('ElectricSubTotal5Year ---->'+ElectricSubTotal5Year);
            }else {
                ElectricSubTotal5Year = 0;
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
        PageReference pdfPage = Page.ElectricityPdfPage; // Ensure this matches your VF page name
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
        conVer.Title = quote.Name+'-Electricity'+'.pdf'; 
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