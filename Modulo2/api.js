import pg from "pg";

import { readFileSync } from "fs";

const { Client } = pg;
var sqlTables = readFileSync("./DDL.sql").toString();
var sqlData = readFileSync("./DML.sql").toString();


class Api {
  db = new Client({
    database: "postgres",
    user: "postgres",
    password: "postgres",
    host: "localhost",
    port: 5432,
  });

  constructor() {
    this.db.connect();
  }

  createTables = async () => {
    let response = false;
    await this.db.query(sqlTables).then((results) => {
      response = true;
    });
    return response;
  };

  populateTables = async () => {
    let response = false;
    await this.db.query(sqlData).then((results) => {
      response = true;
    });
    return response;
  };

}

export default Api;
