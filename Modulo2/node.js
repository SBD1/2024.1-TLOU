const { Client } = require('pg');

// Criando uma conexão ao banco de dados PostgreSQL
const client = new Client({
  host: 'localhost',
  user: 'postgres',
  password: 'postgres',
  port: 5432,
  database: 'tlou'
});

// Conectando ao banco de dados
client.connect()
  .then(() => {
    console.log('Conectado ao banco de dados com sucesso!');
    return client.end(); // Fechar a conexão após a conexão ser bem-sucedida
  })
  .catch(err => {
    console.error('Erro ao conectar ao banco de dados:', err);
  });
