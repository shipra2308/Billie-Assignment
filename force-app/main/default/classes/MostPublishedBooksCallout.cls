public class MostPublishedBooksCallout implements Queueable, Database.AllowsCallouts {

    public void execute(QueueableContext context) {
         Http http = new Http();
         HttpRequest request = new HttpRequest();
         request.setEndpoint(System.Label.BookSiteEndPointUrl);
         request.setMethod('GET');
        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                List<BookWrapperClass> bookDetailList   = (List<BookWrapperClass>) JSON.deserialize(response.getBody(), List<BookWrapperClass>.class);
                 List<BookWrapperClass.Books> allBooks   = BookWrapperClass.getAllBooks(bookDetailList);
                    List<BookWrapperClass.Books> filterList = new  List<BookWrapperClass.Books>();
                    for(BookWrapperClass.Books bookObj :allBooks){
                        if(bookObj.Edition >600000){
                            filterList.add(bookObj);
                        }
                    }
                  filterList.sort(new BookComparator());
                  List<MostPublishedBooks__e> eventList = new List<MostPublishedBooks__e>();
                  if(!filterList.isEmpty()){
                        for(BookWrapperClass.Books bookObj :filterList){
                          MostPublishedBooks__e books = new MostPublishedBooks__e(Title__c = bookObj.Title,Author__c = bookObj.Author,Edition__c = bookObj.Edition);
                          eventList.add(books);
                      }
                  }
                  if(!eventList.isEmpty()){
                        System.debug('eventList: ' + eventList);
                       EventBus.publish(eventList);  
                  }
              }
            else {
                System.debug('Error: ' + response.getStatus());
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }
    public class BookComparator implements Comparator<BookWrapperClass.Books> {
        public Integer compare(BookWrapperClass.Books bookA, BookWrapperClass.Books bookB) {
            return bookB.Edition - bookA.Edition; // Descending order
        }
    }
}