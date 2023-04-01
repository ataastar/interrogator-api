const repo = require('./auth-repository')

async function validateEmailAndPassword(email, password) {
    return await repo.validateEmailAndPassword(email, password);
}

async function getUser(userId) {
    return await repo.getUser(userId);

}

module.exports = {
    validateEmailAndPassword,
    getUser
}
