const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const phrase = require('./phrase/phrase-service');
const auth = require('./auth/auth');

const RateLimit = require('express-rate-limit');
const limiter = RateLimit({
    windowMs: 1000, // 1 second
    max: 10, // max 1 requests per windowMs
});


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

// apply rate limiter to all requests
app.use(limiter);

// auth
app.route('/api/login').post(auth.login);
app.route('/api/refreshToken').post(auth.refreshTokenResponse, auth.checkIfRefreshAuthenticated);

// unit
app.get('/units', auth.checkIfAuthenticated, phrase.getUnitTreeGroup)

// translation
app.get('/translation/:unitId', auth.checkIfAuthenticated, (req, res) => {
    phrase.getUnitTranslation(req, res, auth.getUserId(req))
})
app.post('/translation/update', (req, res, next) => {
    auth.hasRole(req, res, next, 'admin')
}, (req, res) => {
    phrase.updateTranslation(req, res, auth.getUserId(req))
})
app.post('/word', (req, res, next) => {
    auth.hasRole(req, res, next, 'admin')
}, (req, res) => {
    phrase.insertUnitContent(req, res, auth.getUserId(req))
})
app.delete('/word/:unitContentId', (req, res, next) => {
    auth.hasRole(req, res, next, 'admin')
}, phrase.deleteUnitContent)

// answer
app.post('/answer', auth.checkIfAuthenticated, (req, res) => {
    phrase.addAnswer(req, res, auth.getUserId(req))
})
// cancel last answer
app.post('/answer/cancel', auth.checkIfAuthenticated, (req, res) => {
    phrase.cancelLastAnswer(req, res, auth.getUserId(req))
})

// word types e.g. Irregular verbs
app.get('/word_types/words/:wordTypeId/:fromLanguageId/:toLanguageId', auth.checkIfAuthenticated, phrase.getWordTypeContent)
app.get('/word_types/units/words/:wordTypeUnitId/:fromLanguageId', auth.checkIfAuthenticated, phrase.getWordTypeUnitContent)
app.get('/word_types/units', auth.checkIfAuthenticated, phrase.getWordTypeUnit)
// adding removing phrases
app.put('/word_types/units/link', auth.checkIfAuthenticated, phrase.addWordTypeUnitLink)
app.delete('/word_types/units/link/:wordTypeUnitId/:wordTypeLinkId', auth.checkIfAuthenticated, phrase.deleteWordTypeUnitLink)

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
