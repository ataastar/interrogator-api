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

let conn_secure = true
if (process.env.DATABASE_CONN_UNSECURE) {
  conn_secure = false;
}

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: conn_secure,
  Client: EnhancedClient,
});
  
const getUnitContent = (request, response) => {
  const unitId = parseInt(request.params.unitId)
  if (unitId == null) {
    response.status(200).json('{}');
  }
  pool.query('SELECT content FROM unit_content_json Where code = $1', [unitId], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      response.status(200).json(results.rows)
    }
  })
}

const getUnitTreeGroup = (request, response) => {
  pool.query('select * from unit_group_json', [], (error, results) => {
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
  pool.query('select insert_unit_content($1) AS unit_content_id', [content], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      let unitContentId = results.rows[0].unit_content_id;
      console.log(results.rows)
      response.status(201).json({ unitContentId: unitContentId });
    }
  })
}


const deleteUnitContent = (request, response) => {
  const unitContentId = request.body.unitContentId;
  pool.query('select delete_unit_content($1) AS delete_result', [unitContentId], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      let deleteResult = results.rows[0].delete_result;
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