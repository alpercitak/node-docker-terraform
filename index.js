const express = require('express');

const app = express();
const PORT = process.env.NODE_PORT || 3000;

app.get('/', (req, res) => {
  res
    .send({ message: process.env.APP_NAME ?? 'default' })
    .status(200)
    .end();
});

app.listen(PORT, () => {
  console.log(`server started on: ${PORT}`);
});
