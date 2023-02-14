const mongoUtils = require('./shared/mongo-utils')

module.exports = async (context) => {
    console.log(context.request.body);
    await mongoUtils.connect();
    const data = context.request.body;
    await mongoUtils.store('kafka-messages', data);
}
