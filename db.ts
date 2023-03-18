import { Client } from "https://deno.land/x/postgres@v0.17.0/mod.ts";

const connectionString = Deno.env.get('INTERROGATOR_DATABASE_URL') ? Deno.env.get('INTERROGATOR_DATABASE_URL') : Deno.env.get('DATABASE_URL');
console.log(connectionString)

const client = new Client(connectionString);
await client.connect();

export function validateEmailAndPassword(email, password) {
    try {
        const result = client.queryArray('SELECT user_id, nickname, (SELECT string_agg(role, \',\') as roles FROM user_role r WHERE r.user_id = u.user_id) FROM users u WHERE email = $1 AND password=CRYPT($2, password)', [email, password]);
        return result && result.rows.length > 0 ? result.rows[0] : null;
    } catch (err) {
        console.log(err);
        return null;
    }
}

export function getUser(userId) {
    try {
        const result = client.queryArray('SELECT user_id, nickname, (SELECT string_agg(role, \',\') as roles FROM user_role r WHERE r.user_id = u.user_id) FROM users u WHERE user_id = $1',
            [userId]);
        return result && result.rows.length > 0 ? result.rows[0] : null;
    } catch (err) {
        console.log(err);
        return null;
    }
}

export function getUnitContent(request, response) {
    const unitId = parseInt(request.params.unitId)
    if (unitId == null) {
        response.status(200).json('{}');
    }
    return client.queryArray('SELECT content FROM unit_content_json WHERE code = $1', [unitId], (error, results) => {
        if (error) {
            console.log(error)
            response.status(500).json(error);
        } else {
            response.status(200).json(results.rows);
        }
    })
}

class Repo {

    async getUnitTreeGroup() {
        const results = await client.queryObject('SELECT * FROM unit_group_json');
        console.log(results.rows);
        return results.rows;
    }
}


export function insertUnitContent(request, response) {
    const content = request.body;
    return client.queryArray('SELECT insert_unit_content($1) AS unit_content_id', [content], (error, results) => {
        if (error) {
            console.log(error)
            response.status(500).json(error);
        } else {
            let unitContentId = results.rows[0].unit_content_id;
            response.status(201).json({ unitContentId: unitContentId });
        }
    })
}


export function deleteUnitContent(request, response) {
    const unitContentId = request.body.unitContentId;
    return client.queryArray('SELECT delete_unit_content($1) AS delete_result', [unitContentId], (error, results) => {
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

export function getWordTypeContent(request, response) {
    const fromLanguageId = request.body.fromLanguageId;
    const toLanguageId = request.body.toLanguageId;
    const wordTypeId = request.body.wordTypeId;
    return client.queryArray('SELECT content FROM word_type_content_json WHERE from_language_id = $1 AND to_language_id = $2 AND word_type_id = $3', [fromLanguageId, toLanguageId, wordTypeId], (error, results) => {
        if (error) {
            console.log(error)
            response.status(500).json(error);
        } else {
            response.status(200).json(results.rows)
        }
    })
}

export function getWordTypeUnitContent(request, response) {
    const fromLanguageId = parseInt(request.params.fromLanguageId)
    const wordTypeId = parseInt(request.params.wordTypeId)
    if (wordTypeId == null || fromLanguageId == null) {
        response.status(200).json('{}');
    }
    return client.queryArray('SELECT content FROM word_type_unit_content_json WHERE from_language_id = $1 AND word_type_unit_id = $2', [fromLanguageId, wordTypeId], (error, results) => {
        if (error) {
            console.log(error)
            response.status(500).json(error)
        } else {
            response.status(200).json(results.rows)
        }
    })
}

export function getWordTypeUnit(request, response) {
    return client.queryArray('SELECT * FROM word_type_unit_json', [], (error, results) => {
        if (error) {
            console.log(error)
            response.status(500).json(error);
        } else {
            response.status(200).json(results.rows)
        }
    })
}

export function deleteWordTypeUnitLink(request, response) {
    const wordTypeUnitLinkId = request.body.wordTypeUnitLinkId;
    const wordTypeLinkId = request.body.wordTypeLinkId;
    return client.queryArray('SELECT remove_word_type_unit_link($1, $2) AS delete_result', [wordTypeLinkId, wordTypeUnitLinkId], (error, results) => {
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

export function addWordTypeUnitLink(request, response) {
    const wordTypeUnitLinkId = request.body.wordTypeUnitLinkId;
    const wordTypeLinkId = request.body.wordTypeLinkId;
    return client.queryArray('SELECT add_word_type_unit_link($1, $2) AS res', [wordTypeLinkId, wordTypeUnitLinkId], (error, results) => {
        handleSimpleResult(response, error, results)
    })
}

export function addAnswer(request, response, userId) {
    const unitContentId = request.body.id;
    const right = request.body.right;
    const interrogationType = request.body.interrogation_type;
    return client.queryArray('SELECT add_answer($1, $2, $3, $4) AS res', [unitContentId, userId, right, interrogationType], (error, result) => {
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
            response.status(200).json({ result: addResult });
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

export default new Repo();
