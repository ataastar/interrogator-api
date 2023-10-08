const repo = require('./phrase-repository.js')

async function getUnitTranslation(request, response, userId) {
    //console.log('getUnitTranslation' + request.params.unitId);
    const unitId = parseInt(request.params.unitId)
    if (unitId == null) {
        simpleResult('{}', response);
        return
    }
    handleSimpleResult(repo.getUnitTranslation(unitId, userId), response)
}

async function getUnitTreeGroup(request, response) {
    handleSimpleResult(repo.getUnitTreeGroup(), response);
}

async function insertUnitContent(request, response) {
    const content = request.body;
    handleSimpleResult(repo.insertUnitContent(content), response);
}

async function updateTranslation(request, response) {
    const content = request.body;
    handleSimpleResult(repo.updateTranslation(content), response);
}

async function deleteUnitContent(request, response) {
    const unitContentId = parseInt(request.params.unitContentId)
    handleNoResult(repo.deleteUnitContent(unitContentId), response);
}

async function getWordTypeContent(request, response) {
    const fromLanguageId = request.params.fromLanguageId;
    const toLanguageId = request.params.toLanguageId;
    const wordTypeId = request.params.wordTypeId;
    handleSimpleResult(repo.getWordTypeContent(fromLanguageId, toLanguageId, wordTypeId), response);
}

async function getWordTypeUnitContent(request, response) {
    const fromLanguageId = parseInt(request.params.fromLanguageId)
    const wordTypeUnitId = parseInt(request.params.wordTypeUnitId)
    if (wordTypeUnitId == null || fromLanguageId == null) {
        simpleResult('{}', response);
        return
    }
    handleSimpleResult(repo.getWordTypeUnitContent(fromLanguageId, wordTypeUnitId), response);
}

async function getWordTypeUnit(request, response) {
    handleSimpleResult(repo.getWordTypeUnit(), response);
}

async function deleteWordTypeUnitLink(request, response) {
    const wordTypeUnitId = request.params.wordTypeUnitId;
    const wordTypeLinkId = request.params.wordTypeLinkId;
    handleNoResult(repo.deleteWordTypeUnitLink(wordTypeUnitId, wordTypeLinkId), response);
}

async function addWordTypeUnitLink(request, response) {
    const wordTypeUnitId = request.body.wordTypeUnitId;
    const wordTypeLinkId = request.body.wordTypeLinkId;
    handleNoResult(repo.addWordTypeUnitLink(wordTypeUnitId, wordTypeLinkId), response);
}

async function addAnswer(request, response, userId) {
    const unitContentId = request.body.unitContentId;
    const right = request.body.right;
    const interrogationType = request.body.interrogationType;
    const fromLanguageId = request.body.fromLanguageId;
    handleSimpleResult(repo.addAnswer(userId, unitContentId, right, interrogationType, fromLanguageId), response, 'nextInterrogationTime');
}

async function cancelLastAnswer(request, response, userId) {
    const unitContentId = request.body.unitContentId;
    const right = request.body.right;
    const interrogationType = request.body.interrogationType;
    const fromLanguageId = request.body.fromLanguageId;
    handleSimpleResult(repo.cancelLastAnswer(userId, unitContentId, right, interrogationType, fromLanguageId), response, 'nextInterrogationTime');
}


function handleNoResult(promise, response, status = 204, ignoreEmptyResult = false) {
    promise.then(
        result => {
            if (result || ignoreEmptyResult) {
                response.status(status).json();
            } else {
                response.status(404).json();
            }
        },
        error => simpleError(error, response));
}

function handleSimpleResult(promise, response, singleAttributeName) {
    promise.then(
        result => {
            if (singleAttributeName) {
                const obj = {};
                obj[singleAttributeName] = result;
                simpleResult(obj, response);
            } else {
                simpleResult(result, response)
            }
        },
        error => simpleError(error, response));
}

function simpleResult(result, response) {
    //console.log(result);
    response.status(200).json(result);
}

function simpleError(error, response) {
    console.log(error);
    response.status(500).json(error)
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
