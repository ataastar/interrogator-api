const Pool = require('pg').Pool

let connectionString = process.env.QOVERY_DATABASE_INTERROGATOR_CONNECTION_URI ? process.env.QOVERY_DATABASE_INTERROGATOR_CONNECTION_URI : process.env.INTERROGATOR_DATABASE_URL

const pool = new Pool({
  connectionString: connectionString
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
