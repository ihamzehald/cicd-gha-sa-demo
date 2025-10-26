const express = require('express');
const app = express();
const port = process.env.PORT || 8080;
app.get('/', (_, res) => res.send(`${process.env.SERVICE_NAME} is UP.`));
app.listen(port, () => console.log(`listening on ${port}`));