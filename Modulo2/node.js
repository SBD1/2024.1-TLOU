// npm install mysql2

// Importando o pacote mysql2
const mysql = require('mysql2');

// Criando uma conexão ao banco de dados
const connection = mysql.createConnection({
  host: 'localhost',      // O host onde o banco de dados está rodando
  user: 'seu_usuario',    // O nome de usuário para acessar o banco de dados
  password: 'sua_senha',  // A senha do usuário
  database: 'nome_do_banco' // O nome do banco de dados que você quer acessar
});

// Conectando ao banco de dados
connection.connect((err) => {
  if (err) {
    console.error('Erro ao conectar ao banco de dados:', err);
    return;
  }
  console.log('Conectado ao banco de dados com sucesso!');
});

// Fechando a conexão (opcional, apenas quando precisar)
connection.end();
