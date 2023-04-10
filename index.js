const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const phrase = require('./phrase/phrase-service');
const auth = require('./auth/auth');

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
app.get('/word/:unitId', auth.checkIfAuthenticated, phrase.getUnitContent)
app.get('/word_groups', auth.checkIfAuthenticated, phrase.getUnitTreeGroup)
app.post('/word', auth.checkIfAuthenticated, (req, res, next) => {
    auth.hasRole(req, res, next, 'admin')
}, phrase.insertUnitContent)
app.put('/word/remove', auth.checkIfAuthenticated, (req, res, next) => {
    auth.hasRole(req, res, next, 'admin')
}, phrase.deleteUnitContent)
// get one translation detailed data
app.get('/word', auth.checkIfAuthenticated, (req, res, next) => {
    auth.hasRole(req, res, next, 'admin')
}, phrase.getTranslationDetail)

// answer
app.post('/answer', auth.checkIfAuthenticated, (req, res) => {
    phrase.addAnswer(req, res, auth.getUserId(req))
})

// word types e.g. Irregular verbs
app.post('/word_type', auth.checkIfAuthenticated, phrase.getWordTypeContent)
app.get('/word_type_unit/:wordTypeId/:fromLanguageId', auth.checkIfAuthenticated, phrase.getWordTypeUnitContent)
app.get('/word_type_unit', auth.checkIfAuthenticated, phrase.getWordTypeUnit)
// adding removing phrases
app.put('/word_type_unit_link/add', auth.checkIfAuthenticated, phrase.addWordTypeUnitLink)
app.put('/word_type_unit_link/delete', auth.checkIfAuthenticated, phrase.deleteWordTypeUnitLink)

//app.post('/users', phrase.createUser)
//app.put('/users/:id', phrase.updateUser)
//app.delete('/users/:id', phrase.deleteUser)

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
