var express = require('express');
var cors = require('cors');
var app = express();

app.use(cors());
app.use(express.static('./public/'));

app.listen(3000);

console.log('localhost:3000');