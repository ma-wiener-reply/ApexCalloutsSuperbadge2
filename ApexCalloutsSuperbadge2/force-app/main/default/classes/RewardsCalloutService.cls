public with sharing class RewardsCalloutService {
    //jsonBody contains the data that is sent to external service 
    public static HttpResponse submitUsersForRewardCallout(String jsonBody) {
        HttpRequest request = new HttpRequest(); 
        //using named credetials 
        request.setEndpoint('callout:IntegrationSB__BalancedLiving/rewards'); 
        request.setMethod('POST'); 
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonBody);

         //sending the request 
        Http http = new Http();
        HttpResponse res = http.send(request);

        //response will be stored in res 
        return res;
    }
}