@IsTest 
public class AccessibilityProjectBillingTest {

   @IsTest
   static void test(){
        //make up Test data 
        //workshop record, not required because we're not testing the Trigger 
        //Workshop__c TestWorkshop1 = new Workshop__c (Name = 'Test1', DHH_Accessible__c = true); 
        //insert TestWorkshop1; 

        //Workshop__c TestWorkshop2 = new Workshop__c (Name = 'Test2', DHH_Accessible__c = false); 
        //insert TestWorkshop2; 
        
        //project record 
        Accessibility_Project__c project = new Accessibility_Project__c(); 
        project.Amount__c = 100.0; 
        insert project; 
        //register mock 
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        
        //make the callout using the callBillingService-method 
        Test.startTest();
        AccessibilityProjectBilling.callBillingService(project.Id, project.Amount__c); 
        Test.stopTest();

        //updated records 
        project = [SELECT Status__c FROM Accessibility_Project__c WHERE Id = :project.Id];
        //verify results
        System.assertEquals('Complete', project.Status__c); 


    }
}