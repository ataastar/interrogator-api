const db = require('../db-util')

async function getUnitContent(unitId) {
    return (await db.pool.query('SELECT content FROM unit_content_json WHERE code = $1', [unitId])).rows[0].content;
}

async function getUnitTranslation(unitId) {
    return (await db.pool.query('SELECT content FROM unit_translation_json WHERE unit_tree_id = $1', [unitId])).rows[0].content;
}

async function getUnitTreeGroup() {
    return (await db.pool.query('SELECT groups FROM unit_group_json', [])).rows[0].groups;
}

async function insertUnitContent(content) {
    return (await db.pool.query('SELECT insert_unit_content($1) AS unit_content_id', [content])).rows[0].unit_content_id;
}

async function deleteUnitContent(unitContentId) {
    return (await db.pool.query('SELECT delete_unit_content($1) AS delete_result', [unitContentId])).rows[0].delete_result
}

async function getWordTypeContent(fromLanguageId, toLanguageId, wordTypeId) {
    return (await db.pool.query('SELECT content FROM word_type_content_json WHERE from_language_id = $1 AND to_language_id = $2 AND word_type_id = $3', [fromLanguageId, toLanguageId, wordTypeId])).rows[0].content;
}

async function getTranslationDetail(translationLinkId) {
    return null; // (await db.pool.query('SELECT content FROM translation_detail_json WHERE translation_link_id = $1', [translationLinkId])).rows;
}

async function getWordTypeUnitContent(fromLanguageId, wordTypeUnitId) {
    return (await db.pool.query('SELECT content FROM word_type_unit_content_json WHERE from_language_id = $1 AND word_type_unit_id = $2', [fromLanguageId, wordTypeUnitId])).rows[0].content
}

async function getWordTypeUnit() {
    return (await db.pool.query('SELECT groups FROM word_type_unit_json', [])).rows[0].groups
}

async function deleteWordTypeUnitLink(wordTypeUnitId, wordTypeLinkId) {
    return (await db.pool.query('SELECT remove_word_type_unit_link($1, $2) AS delete_result', [wordTypeLinkId, wordTypeUnitId])).rows[0].delete_result;
}

async function addWordTypeUnitLink(wordTypeUnitId, wordTypeLinkId) {
    return (await db.pool.query('SELECT add_word_type_unit_link($1, $2) AS res', [wordTypeLinkId, wordTypeUnitId])).rows[0].res;
}

async function addAnswer(userId, unitContentId, right, interrogationType) {
    //console.log('addAnswer: ' + userId + ', ' + unitContentId + ', ' + right + ', ' + interrogationType)
    return (await db.pool.query('SELECT add_answer($1, $2, $3, $4) AS res', [unitContentId, userId, right, interrogationType])).rows[0].res
}

module.exports = {
    getUnitContent,
    getUnitTranslation,
    getUnitTreeGroup,
    insertUnitContent,
    deleteUnitContent,
    getWordTypeContent,
    getWordTypeUnitContent,
    getTranslationDetail,
    getWordTypeUnit,
    addWordTypeUnitLink,
    deleteWordTypeUnitLink,
    addAnswer
}
