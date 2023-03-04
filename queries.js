const Pool = require('pg').Pool

const connectionString = process.env.INTERROGATOR_DATABASE_URL ? process.env.INTERROGATOR_DATABASE_URL : process.env.DATABASE_URL

const pool = new Pool({
  connectionString: connectionString,
  ssl: !process.env.INTERROGATOR_DATABASE_CONN_UNSECURE
});

async function validateEmailAndPassword(email, password) {
  try {
    const result = await pool.query('SELECT user_id, nickname, (SELECT string_agg(role, \',\') as roles FROM user_role r WHERE r.user_id = u.user_id) FROM users u WHERE email = $1 AND password=CRYPT($2, password)', [email, password]);
    return result && result.rows.length > 0 ? result.rows[0] : null;
  } catch (err) {
    console.log(err);
    return null;
  }
}

async function getUser(userId) {
  try {
    const result = await pool.query('SELECT user_id, nickname, (SELECT string_agg(role, \',\') as roles FROM user_role r WHERE r.user_id = u.user_id) FROM users u WHERE user_id = $1',
        [userId]);
    return result && result.rows.length > 0 ? result.rows[0] : null;
  } catch (err) {
    console.log(err);
    return null;
  }
}

function getUnitContent(request, response) {
  const unitId = parseInt(request.params.unitId)
  if (unitId == null) {
    response.status(200).json('{}');
  }
  return pool.query('SELECT content FROM unit_content_json WHERE code = $1', [unitId], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      response.status(200).json(results.rows);
    }
  })
}

async function getUnitTreeGroup(request, response) {
  return pool.query('SELECT * FROM unit_group_json', [], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      response.status(200).json(results.rows)
    }
  })
}


async function insertUnitContent(request, response) {
  const content = request.body;
  return pool.query('SELECT insert_unit_content($1) AS unit_content_id', [content], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      let unitContentId = results.rows[0].unit_content_id;
      response.status(201).json({unitContentId: unitContentId});
    }
  })
}


async function deleteUnitContent(request, response) {
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

async function getWordTypeContent(request, response) {
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

async function getWordTypeUnitContent(request, response) {
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

async function getWordTypeUnit(request, response) {
  return pool.query('SELECT * FROM word_type_unit_json', [], (error, results) => {
    if (error) {
      console.log(error)
      response.status(500).json(error);
    } else {
      response.status(200).json(results.rows)
    }
  })
}

async function deleteWordTypeUnitLink(request, response) {
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

async function addWordTypeUnitLink(request, response) {
  const wordTypeUnitLinkId = request.body.wordTypeUnitLinkId;
  const wordTypeLinkId = request.body.wordTypeLinkId;
  return pool.query('SELECT add_word_type_unit_link($1, $2) AS res', [wordTypeLinkId, wordTypeUnitLinkId], (error, results) => {
    handleSimpleResult(response, error, results)
  })
}

function addAnswer(request, response, userId) {
  const unitContentId = request.body.id;
  const right = request.body.right;
  const interrogationType = request.body.interrogation_type;
  return pool.query('SELECT add_answer($1, $2, $3, $4) AS res', [unitContentId, userId, right, interrogationType], (error, result) => {
    handleSimplePostResult(response, error, result)
  })
}

function handleSimplePostResult(response, error, result) {
  if (error) {
    console.log(error)
    response.status(500).json(error);
  } else {
    let addResult = result.rows[0].res;
    if (addResult) {
      //console.log('result: ' + addResult);
      response.status(200).json({result: addResult});
    } else {
      response.status(404).json();
    }
  }
}


function handleSimpleResult(response, error, result) {
  if (error) {
    console.log(error)
    response.status(500).json(error);
  } else {
    let addResult = result.rows[0].res;
    if (addResult) {
      response.status(204).json();
    } else {
      response.status(404).json();
    }
  }
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
  deleteWordTypeUnitLink,
  validateEmailAndPassword,
  addAnswer,
  getUser
}
