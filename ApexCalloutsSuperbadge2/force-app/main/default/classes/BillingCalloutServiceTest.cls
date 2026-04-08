@IsTest 
public class BillingCalloutServiceTest {
   @IsTest
   static void test(){
        //make up Test data   
        //project record 
        Accessibility_Project__c project = new Accessibility_Project__c(); 
        project.Amount__c = 100.00; 
        insert project; 
        //register mock 
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        
        //make the callout using the callBillingService-method 
        Test.startTest();
        AccessibilityProjectBilling.callBillingService(project.Id, project.Amount__c); 
        Test.stopTest();


        project = [SELECT Status__c FROM Accessibility_Project__c WHERE Id = :project.Id];
        //verify results
        System.assertEquals('Complete', project.Status__c); 


    }
}