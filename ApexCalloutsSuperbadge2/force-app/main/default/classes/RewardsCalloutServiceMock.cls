@IsTest
global class RewardsCalloutServiceMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request) {
        //leere response erzeugen 
        HttpResponse response = new HttpResponse(); 
        //body setzen, simuliert die Antwort des Webservices 
        response.setBody('{"id": 1 , "name": "Test User" , "username": "testuser", "email": "testuser@gmail.com"}');

        //Status setzen 
        response.setStatusCode(200);
        //response zurückgeben 
        return response; 

    }
}