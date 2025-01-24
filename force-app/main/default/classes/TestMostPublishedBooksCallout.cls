@isTest
private class TestMostPublishedBooksCallout{
		@TestSetup
		static void setupTestData() {	
		}
	
		@IsTest
		static void testSuccessfulCalloutWithBooks() {
			// Mock HTTP Response
			String jsonResponse = '[{"Publisher":"Reilly Media","Books":[{"Author":"Eric1","Title":"First Design Patterns","Edition":1000000},{"Author":"David Flanagan","Title":"JavaScript: The Definitive Guide","Edition":500000},{"Author":"Mark Lutz","Title":"Learning Python","Edition":700000}]}]';
	
			// Create mock response
			HttpResponse mockResponse = new HttpResponse();
			mockResponse.setHeader('Content-Type', 'application/json');
			mockResponse.setBody(jsonResponse);
			mockResponse.setStatusCode(200);
	
			// Set the mock to respond with the above response
			HttpCalloutMock mock = new MockHttpResponseGenerator(mockResponse);
			Test.setMock(HttpCalloutMock.class, mock);
	
			// Test execution
			Test.startTest();
			MostPublishedBooksCallout callout = new MostPublishedBooksCallout();
			System.enqueueJob(callout);
            Test.getEventBus().deliver();
			Test.stopTest();
		}
	
		@IsTest
		static void testSuccessfulCalloutWithNoBooks() {
			// Mock HTTP Response with an empty list
			String jsonResponse = '[]';
			// Create mock response
			HttpResponse mockResponse = new HttpResponse();
			mockResponse.setHeader('Content-Type', 'application/json');
			mockResponse.setBody(jsonResponse);
			mockResponse.setStatusCode(200);
	
			// Set the mock to respond with the above response
			HttpCalloutMock mock = new MockHttpResponseGenerator(mockResponse);
			Test.setMock(HttpCalloutMock.class, mock);
	
			// Test execution
			Test.startTest();
			MostPublishedBooksCallout callout = new MostPublishedBooksCallout();
			System.enqueueJob(callout);
			Test.stopTest();
		}
	
		@IsTest
		static void testNon200Response() {
			// Mock HTTP Response with a status other than 200
			HttpResponse mockResponse = new HttpResponse();
			mockResponse.setHeader('Content-Type', 'application/json');
			mockResponse.setBody('{"error":"Invalid request"}');
			mockResponse.setStatusCode(400);
	
			// Set the mock to respond with the above response
			HttpCalloutMock mock = new MockHttpResponseGenerator(mockResponse);
			Test.setMock(HttpCalloutMock.class, mock);
	
			// Test execution
			Test.startTest();
			MostPublishedBooksCallout callout = new MostPublishedBooksCallout();
			System.enqueueJob(callout);
			Test.stopTest();
		}
	
		@IsTest
		static void testExceptionHandling() {
			// Mock HTTP Response to throw an exception
			HttpCalloutMock mock = new MockHttpExceptionGenerator();
			Test.setMock(HttpCalloutMock.class, mock);
	
			// Test execution
			Test.startTest();
			MostPublishedBooksCallout callout = new MostPublishedBooksCallout();
			System.enqueueJob(callout);
			Test.stopTest();
		}
	
		@IsTest
		static void testComparatorSorting() {
			// Create some sample books
			BookWrapperClass.Books book1 = new BookWrapperClass.Books();
			book1.Title = 'Book1';
			book1.Author = 'Author1';
			book1.Edition = 500000;
	
			BookWrapperClass.Books book2 = new BookWrapperClass.Books();
			book2.Title = 'Book2';
			book2.Author = 'Author2';
			book2.Edition = 800000;
	
			BookWrapperClass.Books book3 = new BookWrapperClass.Books();
			book3.Title = 'Book3';
			book3.Author = 'Author3';
			book3.Edition = 700000;
	
			List<BookWrapperClass.Books> books = new List<BookWrapperClass.Books>{book1, book2, book3};
	
			// Apply sorting
			books.sort(new MostPublishedBooksCallout.BookComparator());
	
			// Validation
			System.assertEquals(800000, books[0].Edition); // Highest Edition
			System.assertEquals(700000, books[1].Edition); // Second highest Edition
		}
	
		// Mock class for successful HTTP response
		private class MockHttpResponseGenerator implements HttpCalloutMock {
			private HttpResponse mockResponse;
	
			public MockHttpResponseGenerator(HttpResponse response) {
				this.mockResponse = response;
			}
	
			public HttpResponse respond(HttpRequest req) {
				return mockResponse;
			}
		}
	
		// Mock class for throwing exceptions in HTTP callout
		private class MockHttpExceptionGenerator implements HttpCalloutMock {
			public HttpResponse respond(HttpRequest req) {
				throw new CalloutException('Mock exception occurred');
			}
		}
	
}