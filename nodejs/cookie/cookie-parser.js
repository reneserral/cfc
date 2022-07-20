let Express = require("express");
/** 
 * cookie-parser used to parse cookie in reqeust header(setCookie) and convert as JSON object
 * and attatched into reqeust.cookies property
*/
let cookieParser  = require('cookie-parser');

let app  = Express();

/**
 * 'cat  in the wall' just a rondom string for HMC encription
 */
app.use(cookieParser('cat in the wall'))


app.get('/', (rq,rs)=>{
    
    rs.send(`
    normal cookie : ${JSON.stringify(rq.cookies)}  
    signed cookie :${JSON.stringify(rq.signedCookies)}
    `);
    
    rs.end();
})
app.get('/setCookie',(rq,rs)=>{
    
    for(i in rq.query){
        rs.cookie(i,rq.query[i]);
    }
    rs.end('value added');
})
app.get('/setSignedCookie', (rq,rs)=>{
    
    for(i in rq.query){
        rs.cookie(i,rq.query[i], {signed:true});
    }
    rs.end('value added');
});


app.listen(4200,()=>{
    console.log('started.....');
})

//App Test:
/**
 * http://localhost:4200/
 * --> normal cookie : {} signed cookie :{}
 * 
 * http://localhost:4200/setCookie?empid=420
 * http://localhost:4200/
 * --> normal cookie : {"empid":"420"} signed cookie :{}
 * 
 * http://localhost:4200/setSignedCookie?empName=dinesh
 * http://localhost:4200/
 * --> normal cookie : {"empid":"420"} signed cookie :{"empName":"dinesh"}
 * 
 * When you check cookie value for empName in browser then you will get encrpted value 
 * 
 * Using EditThisCookie - chrome plugin, you could able to edit both "empid" and "empName"
 * If you edit empName then cookie-parser detect external change and add false as value
 */
