const fs = require('fs');
import { DocumentStore, IAuthOptions, GetStatisticsOperation, CreateDatabaseOperation,  DatabaseRecord } from 'ravendb';
import { Message } from './message';


export class App {

    store: DocumentStore;
    async init() {
        const certificate = '../install_files/client.pfx';

        let authOptions: IAuthOptions = {
            certificate: fs.readFileSync(certificate),
            type: "pfx",
        };
        let database = 'TestDb';
        const store = new DocumentStore('https://raven1.mooo.com:8080/', database, authOptions);
        store.initialize();

        await store.maintenance.forDatabase(database).send(new GetStatisticsOperation());
        

        this.store = store;
        
    }

    async save() {

        const session = this.store.openSession();
        let message: Message = new Message();
        message.id = '';
        message.date = new Date();
        await session.store<Message>(message);
        await session.saveChanges();
        console.log(`saved new message with id ${message.id}`)
    }

    query() {
        const session = this.store.openSession();
        let query = session.query({
            collection: 'Messages',
            documentType: Message
        });
        query
            .waitForNonStaleResults();

        query.all()
            .then((docs: any) => console.log('messages', docs));
    }

    


}