const express = require('express');

const app = express();
const PORT = process.env.NODE_PORT || 3000;

app.get('/', (req, res) => {
  return res.json({ message: process.env.APP_NAME }).status(200);
});

app.listen(PORT, () => {
  console.log(`server started on: ${PORT}`);
});
