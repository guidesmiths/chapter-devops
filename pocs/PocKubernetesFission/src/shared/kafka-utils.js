const { Kafka } = require('kafkajs')

const kafka = new Kafka({
    clientId: 'http-producer',
    brokers: ['fission-kafka-0.fission-kafka-headless.fission.svc.cluster.local:9092'],
})

const producer = kafka.producer()

const sendMessage = async (topic, message) => {
    await producer.connect()
    await producer.send({
        topic,
        messages: [
            { value: message },
            ],
    })
    console.log(`message sent to topic ${topic}: ${message}`);
    await producer.disconnect()
}

module.exports = {
    sendMessage
}
