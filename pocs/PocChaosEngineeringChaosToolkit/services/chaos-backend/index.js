const express = require('express');
const rateLimit = require('express-rate-limit')
const app = express();
const port = process.env.PORT || 3000;

const limiter = rateLimit({
    windowMs: 60 * 1000, // 1 minutes
    max: 10, // Limit each IP to 10 requests per `window` (here, per 1 minutes)
    standardHeaders: true, // Return rate limit info in the `RateLimit-*` headers
    legacyHeaders: false, // Disable the `X-RateLimit-*` headers
})

app.use(limiter); // Limit concurrent requests

app.get('/', function(req, res) {
    setTimeout((() => {
        res.json({
            message: 'all good!'
        });
    }), 500); // Mock latency in ms
});

app.listen(port, () => {
    console.log(`Listening on port ${port}`);
});