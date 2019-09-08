import { App } from "./app";

import process = require('process');



process.on('uncaughtException', (err: any) => { 
    console.error(err);    
});
process.on("unhandledRejection", (reason: any, promise: any) => { 
    console.error(reason); 
});


(async ()=>
{
    const app = new App();
    await app.init();

    setInterval(async ()=>{        
        await app.save();
    }, 5000)
    
})();




