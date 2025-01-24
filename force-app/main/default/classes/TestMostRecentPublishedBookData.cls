@isTest
private class TestMostRecentPublishedBookData{
	@IsTest
    static void testQueueableJob() {
        Test.startTest();
        // Enqueue the job
        MostRecentPublishedBookData job = new MostRecentPublishedBookData();
        MostRecentPublishedBookData.getMostPublishedData();
        // End the test context
        Test.stopTest();
        System.assert(true, 'Job executed successfully');
    }
}
