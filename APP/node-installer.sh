#!/bin/bash
echo "instalando node"
sudo apt update > /dev/null 2>&1 
sudo apt install nodejs -y  && echo "Node instalado correctamente!"
nodejs -v
echo ""
echo "Instalando npm"
sudo apt install npm -y && echo "npm instalado correctamente!"
echo "Creando hello world app"
cat <<EOF > app.js
const http = require('http');

const hostname = '0.0.0.0';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hola Mundo');
});

server.listen(port, hostname, () => {
  console.log(`El servidor se está ejecutando en http://${hostname}:${port}/`);
});
EOF


node app.js &

