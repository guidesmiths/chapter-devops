const kafkaUtils = require('./shared/kafka-utils')

module.exports = async (context) => {
    const message = `message to kafka: ${Math.floor(Math.random() * 10000)}`
    await kafkaUtils.sendMessage('test-topic',);
    return {
        status: 200,
        body: message
    };
}