const mongoUtils = require('./shared/mongo-utils')

module.exports = async (context) => {
    await mongoUtils.connect();
    const data = await mongoUtils.list('kafka-messages');
    return {
        status: 200,
        body: data
    };
}