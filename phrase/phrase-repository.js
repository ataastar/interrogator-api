const db = require('../db-util')
const fs = require('fs');
const path = require('path');

const unit_translation_json = fs.readFileSync(path.join(__dirname, 'db') + '/unit_translation_json.sql').toString();
const unit_content_translation_json = fs.readFileSync(path.join(__dirname, 'db') + '/unit_content_translation_json.sql').toString();
const user_translation_json = fs.readFileSync(path.join(__dirname, 'db') + '/user_translation_json.sql').toString();

async function getUnitTranslation(unitId, userId) {
    return (await db.pool.query(unit_translation_json, [userId, unitId])).rows[0].content;
}

async function getUnitTreeGroup() {
    return (await db.pool.query('SELECT groups FROM unit_group_json', [])).rows[0].groups;
}

async function insertUnitContent(content, userId) {
    const unitContentId = (await db.pool.query('SELECT insert_unit_content($1) AS unit_content_id', [content])).rows[0].unit_content_id;
    return await getTranslation(unitContentId, userId);
}

async function updateTranslation(content, userId) {
    await db.pool.query('SELECT update_translation($1)', [content]);
    return await getTranslation(content.unitContentId, userId);
}

async function getTranslation(unitContentId, userId) {
    return (await db.pool.query(unit_content_translation_json, [unitContentId, userId])).rows[0].content;
}

async function getUserTranslation(unitContentId, userId) {
    return (await db.pool.query(user_translation_json, [unitContentId, userId])).rows[0].content;
}

async function deleteUnitContent(unitContentId) {
    return (await db.pool.query('SELECT delete_unit_content($1) AS delete_result', [unitContentId])).rows[0].delete_result
}

async function getWordTypeContent(fromLanguageId, toLanguageId, wordTypeId) {
    return (await db.pool.query('SELECT content FROM word_type_content_json WHERE from_language_id = $1 AND to_language_id = $2 AND word_type_id = $3', [fromLanguageId, toLanguageId, wordTypeId])).rows[0].content;
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

async function addAnswer(userId, unitContentId, right, interrogationType, fromLanguageId) {
    //console.log('addAnswer: ' + userId + ', ' + unitContentId + ', ' + right + ', ' + interrogationType)
    db.pool.query('SELECT add_answer($1, $2, $3, $4, $5) AS res', [unitContentId, userId, right, interrogationType, fromLanguageId]);
    return await getUserTranslation(unitContentId, userId);
}

async function cancelLastAnswer(userId, unitContentId, right, interrogationType, fromLanguageId) {
    //console.log('addAnswer: ' + userId + ', ' + unitContentId + ', ' + right + ', ' + interrogationType)
    db.pool.query('SELECT cancel_last_answer ($1, $2, $3, $4, $5) AS res', [unitContentId, userId, right, interrogationType, fromLanguageId]);
    return await getUserTranslation(unitContentId, userId);
}

module.exports = {
    getUnitTranslation,
    getUnitTreeGroup,
    insertUnitContent,
    deleteUnitContent,
    getWordTypeContent,
    getWordTypeUnitContent,
    getWordTypeUnit,
    addWordTypeUnitLink,
    deleteWordTypeUnitLink,
    addAnswer,
    cancelLastAnswer,
    updateTranslation
}
