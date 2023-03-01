const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const db = require('./queries');
const auth = require('./auth');
const {checkIfAuthenticated} = require("./auth");

const port = process.env.INTERROGATOR_API_PORT ? process.env.INTERROGATOR_API_PORT : process.env.PORT
const host = process.env.INTERROGATOR_API_HOST

console.log("PORT:")
console.log(port)
console.log("HOST:")
console.log(host)
console.log("process.env.INTERROGATOR_WEB_URL:")
console.log(process.env.INTERROGATOR_WEB_URL)

// TODO just on development
app.all('/*', function (req, res, next) {
    res.header('Access-Control-Allow-Origin', process.env.INTERROGATOR_WEB_URL);
    res.header('Access-Control-Allow-Credentials', true);
    res.header('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, OPTIONS');
    res.header('Access-Control-Allow-Headers', ['Content-Type', 'authorization']);
    next() // pass control to the next handler
});

app.use(bodyParser.json())
app.use(
    bodyParser.urlencoded({
        extended: true,
    })
)

app.get('/', (request, response) => {
    response.json({info: 'Node.js, Express, and Postgres API'})
})

// auth
app.route('/api/login').post(auth.login);
app.route('/api/refreshToken').post(auth.refreshTokenResponse, auth.checkIfRefreshAuthenticated);

// common phrases
app.get('/words/:unitId', checkIfAuthenticated, auth.checkIfRefreshAuthenticated, (req, res) => {
    db.getUnitContent(req, res)
})
app.get('/word_groups', checkIfAuthenticated, db.getUnitTreeGroup)
app.put('/word', checkIfAuthenticated,
    (req, res, next) => {
        auth.hasRole(req, res, next, 'admin')
    }, db.insertUnitContent)
app.put('/word/remove', checkIfAuthenticated,
    (req, res, next) => {
        auth.hasRole(req, res, next, 'admin')
    }, db.deleteUnitContent)

// answer
app.post('/answer', checkIfAuthenticated, (req, res) => {
    db.addAnswer(req, res, auth.getUserId(req))
})

// word types e.g. Irregular verbs
app.post('/word_type', checkIfAuthenticated, db.getWordTypeContent)
app.get('/word_type_unit/:wordTypeId/:fromLanguageId', checkIfAuthenticated, db.getWordTypeUnitContent)
app.get('/word_type_unit', checkIfAuthenticated, db.getWordTypeUnit)
// adding removing phrases
app.put('/word_type_unit_link/add', checkIfAuthenticated, db.addWordTypeUnitLink)
app.put('/word_type_unit_link/delete', checkIfAuthenticated, db.deleteWordTypeUnitLink)

//app.post('/users', db.createUser)
//app.put('/users/:id', db.updateUser)
//app.delete('/users/:id', db.deleteUser)

if (port) {
    if (!host) {
        app.listen(port, () => {
            console.log('App running on ' + port)
        })
    } else {
        app.listen(port, host, () => {
            console.log('App running on port ' + host + ':' + port)
        })
    }
} else {
    app.listen(() => {
        console.log('App running on port ${PORT}.')
    })
}
