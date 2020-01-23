const Pool = require('pg').Pool
const Client = require('pg').Client

class EnhancedClient extends Client {
  getStartupConf() {
    if (process.env.PG_OPTIONS) {
      try {
        const options = JSON.parse(process.env.PG_OPTIONS);
        return {
          ...super.getStartupConf(),
          ...options,
        };
      } catch (e) {
        console.error(e);
        // Coalesce to super.getStartupConf() on parse error
      }
    }

    return super.getStartupConf();
  }
}
const pool = new Pool({
  Client: EnhancedClient,
  user: 'attila',
  host: 'localhost',
  database: 'postgres',
  password: 'baracska',
  port: 5432,
})

const getUnitContent = (request, response) => {
  const unitId = parseInt(request.params.unitId)
  pool.query('SELECT content FROM "UnitContentJson" Where code = $1', [unitId], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      response.status(200).json(results.rows)
    }
  })
}

const getUnitTreeGroup = (request, response) => {
  pool.query('select * from "UnitGroupJson"', [], (error, results) => {
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
  pool.query('CALL insertunitcontent($1);', [content], (error) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
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