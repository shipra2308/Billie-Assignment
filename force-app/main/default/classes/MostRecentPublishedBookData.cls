public class MostRecentPublishedBookData {
    @AuraEnabled 
    public static void getMostPublishedData(){
        System.enqueuejob(new  MostPublishedBooksCallout());
    }
}