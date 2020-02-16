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
  if (unitId == null) {
    response.status(200).json('{}');
  }
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


const deleteUnitContent = (request, response) => {
  const unitContentId = request.body.unitContentId;
  pool.query('select interrogator."deleteUnitContent"($1) AS deleteresult', [unitContentId], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      let deleteResult = results.rows[0].deleteresult;
      if (deleteResult) {
        response.status(204).json();
      } else {
        response.status(404).json();
      }
    }
  })
}

module.exports = {
  getUnitContent,
  getUnitTreeGroup,
  insertUnitContent,
  deleteUnitContent
}