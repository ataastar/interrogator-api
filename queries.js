const Pool = require('pg').Pool

let connectionString = process.env.QOVERY_DATABASE_INTERROGATOR_CONNECTION_URI ? process.env.QOVERY_DATABASE_INTERROGATOR_CONNECTION_URI : process.env.INTERROGATOR_DATABASE_URL
console.log("connectionString:")
console.log(connectionString)

const pool = new Pool({
  connectionString: connectionString
});
  
const getUnitContent = (request, response) => {
  const unitId = parseInt(request.params.unitId)
  if (unitId == null) {
    response.status(200).json('{}');
  }
  pool.query('SELECT content FROM unit_content_json WHERE code = $1', [unitId], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      response.status(200).json(results.rows)
    }
  })
}

const getUnitTreeGroup = (request, response) => {
  pool.query('SELECT * FROM unit_group_json', [], (error, results) => {
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
  pool.query('SELECT insert_unit_content($1) AS unit_content_id', [content], (error, results) => {
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
  pool.query('SELECT delete_unit_content($1) AS delete_result', [unitContentId], (error, results) => {
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

const getWordTypeContent = (request, response) => {
  const fromLanguageId = request.body.fromLanguageId;
  const toLanguageId = request.body.toLanguageId;
  const wordTypeId = request.body.wordTypeId;
  pool.query('SELECT content FROM word_type_content WHERE from_language_id = $1 AND to_language_id = $2 AND word_type_id = $3', [fromLanguageId, toLanguageId, wordTypeId], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      response.status(200).json(results.rows)
    }
  })
}

module.exports = {
  getUnitContent,
  getUnitTreeGroup,
  insertUnitContent,
  deleteUnitContent,
  getWordTypeContent
}
