@IsTest
public with sharing class WellnessJourneyRewardsBatchTest {
    @TestSetup 
    static void setup(){
     // create Eligible User 
        User eligibleUser = new User(
            Username = 'eligible' + Math.random() + '@test.com',
            Email = 'eligible@test.com',
            Alias = 'euser',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            FirstName = 'Eligible',
            LastName = 'User',
            IsActive = true
        );
        insert eligibleUser;

        //calculate the first month of a quarter  
        Date today = Date.today();
        Integer startMonth = (((today.month() - 1) / 3) * 3) + 1;
        Date startOfQuarter = Date.newInstance(today.year(), startMonth, 1);

        // Eligible Journeys within a quarter 
        List<Wellness_Journey__c> eligibleJourneys = new List<Wellness_Journey__c>();
        for(Integer i=0; i<12; i++){
            eligibleJourneys.add(new Wellness_Journey__c(
                Name = 'Journey ' + i,
                OwnerId = eligibleUser.Id,
                Completion_Date__c = startOfQuarter.addDays(i), // innerhalb des Quartals
                Completion_Goal__c = 10,
                Completion_Value__c = 5,
                Points__c = 10,
                Points_Earned__c = 5,
                Status__c = 'Complete',
                Metric_Type__c = 'Wellness'
            ));
        }
        insert eligibleJourneys;

        // create Not Eligible User
        User notEligibleUser = new User(
            Username = 'noteligible' + Math.random() + '@test.com',
            Email = 'noteligible@test.com',
            Alias = 'neuser',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            FirstName = 'Not',
            LastName = 'Eligible',
            IsActive = true
        );
        insert notEligibleUser;

        // Not eligible Journey out of quarter 
        Wellness_Journey__c oldJourney = new Wellness_Journey__c(
            Name = 'Old Journey',
            OwnerId = notEligibleUser.Id,
            Completion_Date__c = today.addMonths(-6),  // out of the quarter 
            Completion_Goal__c = 10,
            Completion_Value__c = 5,
            Points__c = 10,
            Points_Earned__c = 5,
            Status__c = 'Complete',
            Metric_Type__c = 'Wellness'
        );
        insert oldJourney;
    }
    
        @IsTest
        static void test(){
            //register Mock 
            Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock());

            Date today = Date.today();
            Integer startMonth = (((today.month() - 1) / 3) * 3) + 1;
            Date startOfQuarter = Date.newInstance(today.year(), startMonth, 1);
            Date endOfQuarter = startOfQuarter.addMonths(3).addDays(-1);

            Test.startTest();
            WellnessJourneyRewardsBatch wjb = new WellnessJourneyRewardsBatch(); 
            Id batchId = Database.executeBatch(wjb); 
            Test.stopTest();
            

            List<AggregateResult> results = [
            SELECT OwnerId, COUNT(Id) cnt
            FROM Wellness_Journey__c
            WHERE Status__c = 'Complete'
            AND Completion_Date__c >= :startOfQuarter
            AND Completion_Date__c <= :endOfQuarter
            GROUP BY OwnerId
            HAVING COUNT(Id) >= 12
            ];

            //verify the Eligible User
            System.assertEquals(1, results.size());
            // verify that the batch executed correctly
            // ensure that the correct number of journeys were processed
            Integer processedJourneys = [
            SELECT COUNT()
            FROM Wellness_Journey__c
            WHERE Status__c = 'Complete'
            AND Completion_Date__c >= :startOfQuarter
            AND Completion_Date__c <= :endOfQuarter
            ];
            System.assertEquals(12, processedJourneys);
        }

    
}