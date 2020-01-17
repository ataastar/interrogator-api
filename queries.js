const Pool = require('pg').Pool
const pool = new Pool({
  user: 'attila',
  host: 'localhost',
  database: 'postgres',
  password: 'baracska',
  port: 5432,
})

const getUnitContent = (request, response) => {
  const unitId = parseInt(request.params.unitId)
  pool.query('SELECT content FROM interrogator."UnitContentJson" Where code = $1', [unitId], (error, results) => {
    if (error) {
      console.log(error)
      //throw error
    }
    //console.log(results)
    response.status(200).json(results.rows)
  })
}

const getUnitTreeGroup = (request, response) => {
  pool.query('select * from interrogator."UnitGroupJson"', [], (error, results) => {
    if (error) {
      console.log(error)
      //throw error
    }
    //console.log(results)
    response.status(200).json(results.rows)
  })
}

module.exports = {
  getUnitContent,
  getUnitTreeGroup
}