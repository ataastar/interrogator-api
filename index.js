const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const db = require('./queries')

// **** LOGIN START ****
const jwt = require('jsonwebtoken');
const fs = require('fs');
// **** LOGIN END ****

const port = process.env.INTERROGATOR_API_PORT
const host = process.env.INTERROGATOR_API_HOST

console.log("process.env.INTERROGATOR_API_PORT:")
console.log(process.env.INTERROGATOR_API_PORT)

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
  response.json({ info: 'Node.js, Express, and Postgres API' })
})

// **** LOGIN START ****
app.route('/api/login').post(loginRoute);
const RSA_PRIVATE_KEY = fs.readFileSync('./private.key');
function loginRoute(req, res) {
  const email = req.body.email, password = req.body.password;

  function findUserIdForEmail(email) { // TODO find user
    return '1';
  }

  function validateEmailAndPassword() {  // TODO check email
    return true;
  }

  if (validateEmailAndPassword()) {
    const userId = findUserIdForEmail(email);
    const jwtBearerToken = jwt.sign({}, RSA_PRIVATE_KEY, {
      algorithm: 'RS256',
      expiresIn: 72000, // 60 * 60 * 20
      subject: userId
    });
    // send the JWT back to the user
    res.status(200).json({
      idToken: jwtBearerToken
    });
  } else {
    // send status 401 Unauthorized
    res.sendStatus(401);
  }
}
// **** LOGIN END ****

// check JWT
const expressJwt = require('express-jwt');
const RSA_PUBLIC_KEY = fs.readFileSync('./public.key');

const checkIfAuthenticated = expressJwt({
  secret: RSA_PUBLIC_KEY, algorithms: ['RS256']
}); // check JWT


//app.get('/users', db.getUsers)
app.get('/words/:unitId', checkIfAuthenticated, db.getUnitContent)
app.get('/word_groups', checkIfAuthenticated, db.getUnitTreeGroup)
app.put('/word', checkIfAuthenticated, db.insertUnitContent)
app.put( '/word/remove', checkIfAuthenticated, db.deleteUnitContent)
app.post('/word_type', checkIfAuthenticated, db.getWordTypeContent)
app.get('/word_type_unit/:wordTypeId/:fromLanguageId', checkIfAuthenticated, db.getWordTypeUnitContent)
app.get('/word_type_unit', checkIfAuthenticated, db.getWordTypeUnit)
app.put('/word_type_unit_link/add', checkIfAuthenticated, db.addWordTypeUnitLink)
app.put('/word_type_unit_link/delete', checkIfAuthenticated, db.deleteWordTypeUnitLink)
//app.post('/users', db.createUser)
//app.put('/users/:id', db.updateUser)
//app.delete('/users/:id', db.deleteUser)

if (port) {
  if (host) {
    app.listen(port, () => {
      console.log('App running on port ${PORT}.')
    })
  } else {
    app.listen(port, host, () => {
      console.log('App running on port ${PORT}.')
    })
  }
} else {
  app.listen(() => {
    console.log('App running on port ${PORT}.')
  })
}
