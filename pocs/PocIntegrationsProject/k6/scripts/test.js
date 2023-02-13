import http from 'k6/http';
import { sleep } from 'k6';

const method = __ENV.TARGET_METHOD || 'get'

const targetUrl = __ENV.TARGET_URL; // Replace this with your public one

const targetPayload = __ENV.TARGET_PAYLOAD

const requestParams = {
    headers: {
        'Content-Type': 'application/json',
    },
}

export const options = {
    vus: 10,
    duration: '30s',
};

export default function () {
    if(method === 'post'){
        http.post(targetUrl, targetPayload, requestParams);
    } else {
        http.get(targetUrl)
    }
    sleep(1);
}
