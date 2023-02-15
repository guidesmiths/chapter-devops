const axios = require('axios');
const alertToSlackFunction = require('./index');
const sampleInput = require('./fixtures/sample-input.json')
const sampleOutput = require('./fixtures/sample-output.json')

jest.mock("axios");
jest.mock('./config', () => ({ slackChannelWebhookUrl: 'slackChannelWebhookUrl'}))

const context = { log: jest.fn() }

describe('alertToSlackFunction', () => {
    test('should work basic case', (done) => {
        alertToSlackFunction(context, { body: sampleInput })
            .then(() => {
                expect(axios.post).toBeCalledWith('slackChannelWebhookUrl', sampleOutput);
                expect(context.log).toBeCalled();
                done()
            })
    })
})
