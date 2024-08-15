import psycopg2
from psycopg2 import OperationalError

# Configurações de conexão
conn_params = {
    'dbname': 'tlou',
    'user': 'postgres',
    'password': 'postgres',
    'host': 'localhost',
    'port': '5432'
}

def create_connection():
    """Cria uma conexão com o banco de dados PostgreSQL e retorna o objeto de conexão."""
    conn = None
    try:
        conn = psycopg2.connect(**conn_params)
        print("Conexão bem-sucedida!")
    except OperationalError as e:
        print(f"Erro ao conectar ao PostgreSQL: {e}")
    return conn

def close_connection(conn):
    """Fecha a conexão com o banco de dados."""
    if conn:
        conn.close()
        print("Conexão encerrada.")

def main():
    connection = create_connection()
    close_connection(connection)

if __name__ == "__main__":
    main()

