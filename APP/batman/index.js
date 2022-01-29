const express = require("express");
const path = require("path");

const app = express();
const port = process.env.PORT || "8089";

app.use(express.static(__dirname + '/'));

app.listen(port, () =>
{
    console.log(`Listening to requests on http://0.0.0.0:${port}`);
});

app.get('/batman', function(req, res)
{
    res.sendFile(path.join(__dirname, '/batman.html'));
});

