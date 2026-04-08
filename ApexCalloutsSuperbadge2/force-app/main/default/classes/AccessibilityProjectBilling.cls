public class AccessibilityProjectBilling {
    @future(callout=true)
    public static void callBillingService (Id projectId , Decimal amount) {
        //p is a SOAP request object, needed in service method
        BillingServiceProxy.project p = new BillingServiceProxy.project();
        p.username = '{!$Credential.BillingServiceCredential.username}';
        p.password = '{!$Credential.BillingServiceCredential.password}';
        p.projectid = projectId; 
        //conversion decimal to double Amount__c Decimal, in WSDL Double 
        p.billAmount = Double.valueOf(amount); 
        //SOAP client und service Methode aufrufen
        BillingServiceProxy.InvoicesPortSoap11 client = new BillingServiceProxy.InvoicesPortSoap11(); 
        // use Named Credential, same as in WSDL 
        client.endpoint_x = 'callout:IntegrationSB__BillingInvoiceService';
        try {
        //billProject expects a project, makes the callout 
        String result= client.billProject(p);
        System.debug('Billing Service Response: ' + result);
        //process the response 
        if(result == 'okay') {
        Accessibility_Project__c proj = new Accessibility_Project__c(
            Id = projectId,
            Status__c = 'Complete'
        );
        update proj;
        }} catch(Exception e) {
        System.debug('Billing Callout failed: ' + e.getMessage());}
        
    
    }
}