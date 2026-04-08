@IsTest
global class BillingCalloutServiceMock implements WebServiceMock {
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseName,
        String responseNS,
        String responseType
    ) {
        //simulates a response
        BillingServiceProxy.billProjectResponse_element resp = new BillingServiceProxy.billProjectResponse_element();
        //status must be completed 
        resp.status = 'Complete';
        response.put('response_x', resp);
    }
}