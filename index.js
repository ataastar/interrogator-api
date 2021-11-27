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
async function loginRoute(req, res) {
  const email = req.body.email;
  const password = req.body.password;

  // TODO user dto
  let user = null;
  try {
    user = await db.validateEmailAndPassword(email, password);
  } catch (err) {
    console.log(err);
    res.sendStatus(401);
  }
  if (user) {
    const jwtBearerToken = jwt.sign({}, RSA_PRIVATE_KEY, {
      algorithm: 'RS256',
      expiresIn: 72000, // 60 * 60 * 20
      subject: user.user_id
    });
    // send the JWT back to the user
    res.status(200).json({
      idToken: jwtBearerToken,
      nickname: user.nickname
    });
  } else {
    res.sendStatus(401);
  }
}
// **** LOGIN END ****

// check JWT
const expressJwt = require('express-jwt');
const RSA_PUBLIC_KEY = fs.readFileSync('./public.key');
/**
 * Function to check that the token is right
 * @type {(function(*=, *=, *): (*|undefined))|*}
 */
const checkIfAuthenticated = expressJwt({
  secret: RSA_PUBLIC_KEY, algorithms: ['RS256']
});
// check JWT

/**
 * Gets the user id from the jwt token
 * @param req the request
 * @returns {null|*} the user id if the token is exists, otherwise null
 */
const getUserId = (req) => {
  const token = req.header('authorization');
  if(token !== null){
    const base64String = token.split('.')[1];
    const decodedValue = JSON.parse(Buffer.from(base64String, 'base64').toString('ascii'));
    return decodedValue['sub'];
  }
  return null;
}

//app.get('/users', db.getUsers)
app.get('/words/:unitId', checkIfAuthenticated, (req, res) =>{ db.getUnitContent(req, res, getUserId(req))})
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
