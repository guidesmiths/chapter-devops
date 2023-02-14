const {MongoClient} = require('mongodb');

let databaseInstance;

const connect = async () => {
    if (!databaseInstance) {
        const mongoInstance = await MongoClient.connect('');
        databaseInstance = mongoInstance.db('fission');
    }
}

const store = async (collectionName, data) => {
    const collection = databaseInstance.collection(collectionName);
    await collection.insertOne(data);
}

const list = async (collectionName) => {
    const collection = databaseInstance.collection(collectionName);
    return await collection.find({}).toArray();
}

module.exports = {
    connect,
    store,
    list
}