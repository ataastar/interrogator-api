const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const db = require('./queries')
const port = process.env.INTERROGATOR_API_PORT
const history = require('connect-history-api-fallback')

// TODO just on development
app.all('/*', function (req, res, next) {
  res.header('Access-Control-Allow-Origin', process.env.INTERROGATOR_WEB);
  res.header('Access-Control-Allow-Credentials', true);
  res.header('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next() // pass control to the next handler
});

app.use(bodyParser.json())
app.use(
  bodyParser.urlencoded({
    extended: true,
  })
)

// host static files
app.use(history({
  verbose: true
}))
app.use(express.static('public'))
app.use(express.static('fe'))

app.get('/', (request, response) => {
  response.json({ info: 'Node.js, Express, and Postgres API' })
})

//app.get('/users', db.getUsers)
app.get('/words/:unitId', db.getUnitContent)
app.get('/word_groups', db.getUnitTreeGroup)
app.put('/word', db.insertUnitContent)
app.put('/word/remove', db.deleteUnitContent)
//app.post('/users', db.createUser)
//app.put('/users/:id', db.updateUser)
//app.delete('/users/:id', db.deleteUser)

if (port) {
  app.listen(port, () => {
    console.log('App running on port ${PORT}.')
  })
} else {
  app.listen(() => {
    console.log('App running on port ${PORT}.')
  })
}
