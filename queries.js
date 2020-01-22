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
      response.status(500).json(error);
    } else {
      response.status(200).json(results.rows)
    }
  })
}

const getUnitTreeGroup = (request, response) => {
  pool.query('select * from interrogator."UnitGroupJson"', [], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      response.status(200).json(results.rows)
    }
  })
}


const insertUnitContent = (request, response) => {
  const content = request.body;
  pool.query('SET search_path = interrogator;', [], (error) => {
    if (error) {
      console.log(error)
      response.status(500).json();
    }
  })

  pool.query('CALL interrogator.insertunitcontent($1);', [content], (error) => {
    if (error) {
      console.log(error)
      response.status(500).json();
    } else {
      response.status(201).json();
    }
  })
}

module.exports = {
  getUnitContent,
  getUnitTreeGroup,
  insertUnitContent
}