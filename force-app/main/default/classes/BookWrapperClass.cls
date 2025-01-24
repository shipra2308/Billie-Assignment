global class BookWrapperClass{
    public String Publisher { get; set; }
    public List<Books> Books { get; set; }

    public class Books {
        public String Title { get; set; }
        public String Author { get; set; }
        public Integer Edition { get; set; }
    }
    public static List<Books> getAllBooks(List<BookWrapperClass> publishersData) {
        List<Books> allBooks = new List<Books>();
        for (BookWrapperClass publisher : publishersData) {
            allBooks.addAll(publisher.Books);
        }
        return allBooks;
    }
}