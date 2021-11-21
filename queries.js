const Pool = require('pg').Pool

let connectionString = process.env.QOVERY_DATABASE_INTERROGATOR_CONNECTION_URI ? process.env.QOVERY_DATABASE_INTERROGATOR_CONNECTION_URI : process.env.INTERROGATOR_DATABASE_URL
console.log("connectionString:")
console.log(connectionString)

const pool = new Pool({
  connectionString: connectionString
});
  
const getUnitContent = (request, response, user) => {
  console.log(user)
  const unitId = parseInt(request.params.unitId)
  if (unitId == null) {
    response.status(200).json('{}');
  }
  return pool.query('SELECT content FROM unit_content_json WHERE code = $1', [unitId], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      response.status(200).json(results.rows)
    }
  })
}

const getUnitTreeGroup = (request, response) => {
  return pool.query('SELECT * FROM unit_group_json', [], (error, results) => {
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
  return pool.query('SELECT insert_unit_content($1) AS unit_content_id', [content], (error, results) => {
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
  return pool.query('SELECT delete_unit_content($1) AS delete_result', [unitContentId], (error, results) => {
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
  return pool.query('SELECT content FROM word_type_content_json WHERE from_language_id = $1 AND to_language_id = $2 AND word_type_id = $3', [fromLanguageId, toLanguageId, wordTypeId], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      response.status(200).json(results.rows)
    }
  })
}

const getWordTypeUnitContent = (request, response) => {
  const fromLanguageId = parseInt(request.params.fromLanguageId)
  const wordTypeId = parseInt(request.params.wordTypeId)
  if (wordTypeId == null || fromLanguageId == null) {
    response.status(200).json('{}');
  }
  return pool.query('SELECT content FROM word_type_unit_content_json WHERE from_language_id = $1 AND word_type_unit_id = $2', [fromLanguageId, wordTypeId], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error)
    } else {
      response.status(200).json(results.rows)
    }
  })
}

const getWordTypeUnit = (request, response) => {
  return pool.query('SELECT * FROM word_type_unit_json', [], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      response.status(200).json(results.rows)
    }
  })
}

const deleteWordTypeUnitLink = (request, response) => {
  const wordTypeUnitLinkId = request.body.wordTypeUnitLinkId;
  const wordTypeLinkId = request.body.wordTypeLinkId;
  return pool.query('SELECT remove_word_type_unit_link($1, $2) AS delete_result', [wordTypeLinkId, wordTypeUnitLinkId], (error, results) => {
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

const addWordTypeUnitLink = (request, response) => {
  const wordTypeUnitLinkId = request.body.wordTypeUnitLinkId;
  const wordTypeLinkId = request.body.wordTypeLinkId;
  return pool.query('SELECT add_word_type_unit_link($1, $2) AS delete_result', [wordTypeLinkId, wordTypeUnitLinkId], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      let addResult = results.rows[0].delete_result;
      if (addResult) {
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
  deleteUnitContent,
  getWordTypeContent,
  getWordTypeUnitContent,
  getWordTypeUnit,
  addWordTypeUnitLink,
  deleteWordTypeUnitLink
}
