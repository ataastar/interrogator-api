const repo = require('./phrase-repository.js')

async function getUnitContent(request, response) {
    const unitId = parseInt(request.params.unitId)
    if (unitId == null) {
        simpleResult('{}', response);
        return
    }
    handleSimpleResult(repo.getUnitContent(unitId), response)
}

async function getUnitTreeGroup(request, response) {
    handleSimpleResult(repo.getUnitTreeGroup(), response);
}

async function insertUnitContent(request, response) {
    const content = request.body;
    handleSimpleResult(repo.insertUnitContent(content), response, 'unitContentId');
}

async function deleteUnitContent(request, response) {
    const unitContentId = request.body.unitContentId;
    handleNoResult(repo.deleteUnitContent(unitContentId), response);
}

async function getWordTypeContent(request, response) {
    const fromLanguageId = request.body.fromLanguageId;
    const toLanguageId = request.body.toLanguageId;
    const wordTypeId = request.body.wordTypeId;
    handleSimpleResult(repo.getWordTypeContent(fromLanguageId, toLanguageId, wordTypeId), response);
}

async function getWordTypeUnitContent(request, response) {
    const fromLanguageId = parseInt(request.params.fromLanguageId)
    const wordTypeId = parseInt(request.params.wordTypeId)
    if (wordTypeId == null || fromLanguageId == null) {
        simpleResult('{}', response);
        return
    }
    handleSimpleResult(repo.getWordTypeUnitContent(fromLanguageId, wordTypeId), response);
}

async function getWordTypeUnit(request, response) {
    handleSimpleResult(repo.getWordTypeUnit(), response);
}

async function deleteWordTypeUnitLink(request, response) {
    const wordTypeUnitLinkId = request.body.wordTypeUnitLinkId;
    const wordTypeLinkId = request.body.wordTypeLinkId;
    handleNoResult(repo.deleteWordTypeUnitLink(wordTypeUnitLinkId, wordTypeLinkId), response);
}

async function addWordTypeUnitLink(request, response) {
    const wordTypeUnitLinkId = request.body.wordTypeUnitLinkId;
    const wordTypeLinkId = request.body.wordTypeLinkId;
    handleNoResult(repo.addWordTypeUnitLink(wordTypeUnitLinkId, wordTypeLinkId), response);
}

async function addAnswer(request, response, userId) {
    const unitContentId = request.body.id;
    const right = request.body.right;
    const interrogationType = request.body.interrogation_type;
    handleNoResult(repo.addAnswer(userId, unitContentId, right, interrogationType), response, 200);
}


function handleNoResult(promise, response, status = 204) {
    promise.then(
        result => {
            if (result) {
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
    response.status(200).json(result);
}

function simpleError(error, response) {
    response.status(500).json(error)
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
    addAnswer
}
