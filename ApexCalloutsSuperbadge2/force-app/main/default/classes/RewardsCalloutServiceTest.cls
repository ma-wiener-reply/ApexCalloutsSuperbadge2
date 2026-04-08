@IsTest
public with sharing class RewardsCalloutServiceTest {
    @IsTest
    static void testRewardsCalloutService() {
        //register mock class 
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock());
        //fake response is sent 
        HttpResponse response = RewardsCalloutService.submitUsersForRewardCallout('{"id":"1","name":"Test User"}');
        
        String actualValue = response.getBody();
        String expectedValue = '{"id": 1 , "name": "Test User" , "username": "testuser", "email": "testuser@gmail.com"}';
        //check the result 
        Assert.areEqual(expectedValue, actualValue);
        Assert.areEqual(200, response.getStatusCode());

    }
}