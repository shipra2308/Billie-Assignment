import { LightningElement,track,wire } from 'lwc';
import { subscribe, onError,unsubscribe } from 'lightning/empApi';
import getMostPublishedData from '@salesforce/apex/MostRecentPublishedBookData.getMostPublishedData';
export default class ListOfBooks extends LightningElement {
    @track books = [];
    @track showSpinner = false;
    channelName = '/event/MostPublishedBooks__e';
    
    connectedCallback() {
        this.subscribeToEvent();
    }
    handleClick(){
         this.books = [];
         console.log('this.books++++ ', this.books);
          this.showSpinner = true
          getMostPublishedData()
            .then(() => {
                console.log(' records')  
            })
            .catch(error => {
                console.log('error records')
            });
    }
    
    subscribeToEvent() {
        const callback = (response) => {
            this.showSpinner = false;
            this.payload = JSON.stringify(response);
            const eventData = response.data.payload;
            const book = {
                title: eventData.Title__c,
                author: eventData.Author__c,
                edition: eventData.Edition__c
            };
            this.books.push(book);
            console.log('this.books++++ ', this.books);
        };
        console.log('this.books ', this.books);
       
        subscribe(this.channelName,-1, callback)
            .then(response => {
                console.log('Subscribed to platform event:', response.channel);
            })
            .catch(error => {
                console.error('Error subscribing to event:', error);
            });
          
    }
    registerErrorListener() {
        // Invoke onError empApi method
        onError((error) => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }

}