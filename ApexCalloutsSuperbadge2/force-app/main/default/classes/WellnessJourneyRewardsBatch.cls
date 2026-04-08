public with sharing class WellnessJourneyRewardsBatch implements Database.Batchable<AggregateResult>, 
Database.AllowsCallouts{
    //structure for JSON (inner class)
    public class EmployeeReward {
        public Id Id { get; set; }
        public String Name { get; set; }
        public String Username { get; set; }
        public String Email { get; set; }
    }
    
    //liefert Datensätze die später verarbeitet werden in execute 
    public Iterable<AggregateResult> start(Database.BatchableContext bc) {
        //calculate the start month of a quarter 
         Date startDate = getStartDate();
         // calculate the end month of a quarter 
         Date endDate = getEndDate();

        System.debug('Start Date: ' + startDate);
        System.debug('End Date: ' + endDate);

        return [
        SELECT OwnerId, MAX(Owner.Name) Name, MAX(Owner.Username) Username, MAX(Owner.Email) Email, 
        COUNT(Id) ActivityCount
        FROM Wellness_Journey__c
        WHERE Status__c = 'Complete' 
        AND Completion_Date__c >= :startDate
        AND Completion_Date__c <= :endDate
        GROUP BY OwnerId
        HAVING COUNT(Id) >= 12
    ];
}
    public void execute(Database.BatchableContext bc, List<AggregateResult> scope) {
        //Liste wird später zu JSON 
        List<EmployeeReward> rewardsList = new List<EmployeeReward>();
        for (AggregateResult ar: scope){
            // Objekt erstellen 
            EmployeeReward emp = new EmployeeReward();

            emp.Id = (Id) ar.get('OwnerId');
            emp.Name = (String) ar.get('Name');
            emp.Username = (String) ar.get('Username');
            emp.Email = (String) ar.get('Email');

            rewardsList.add(emp); 

        }
        //JSON is generated 
        if (!rewardsList.isEmpty()) {
        String jsonBody = JSON.serialize(rewardsList);
        //makes the http callout 
        HttpResponse statusCode = RewardsCalloutService.submitUsersForRewardCallout(jsonBody);
        System.debug('Status Code: ' + statusCode);
        }

    }
    public void finish (Database.BatchableContext bc) {
    }
    // helper classes to get the start and end day of a quarter 
    private Date getStartDate() {
        Date today = Date.today();
        Integer startMonth = (((today.month() - 1) / 3) * 3) + 1;
        return Date.newInstance(today.year(), startMonth, 1);
    }

    private Date getEndDate() {
        Date startDate = getStartDate();
        return startDate.addMonths(3).addDays(-1);
    }
    
}