import { serve } from 'https://deno.land/std@0.180.0/http/server.ts';
import repo from './db.ts';

//const BOOK_ROUTE = new URLPattern({ pathname: "/books/:id" });

async function handler(req: Request): Response {
    // const match = BOOK_ROUTE.exec(req.url);
    // if (match) {
    //     const id = match.pathname.groups.id;

    const unitTreeGroup = await repo.getUnitTreeGroup();
    console.log('db result');
    console.log(JSON.stringify(unitTreeGroup));
    return new Response(JSON.stringify(unitTreeGroup));
    //return new Response(`Book`);
    // }
    // db.getUnitTreeGroup
    /* return new Response("Not found (try /books/1)", {
         status: 404,
     });*/
}

serve(handler);
