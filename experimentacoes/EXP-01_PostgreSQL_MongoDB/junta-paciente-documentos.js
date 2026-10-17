const { Client } = require('pg');
const { MongoClient, ObjectId } = require('mongodb');
const fs = require('fs');

const docs = JSON.parse(fs.readFileSync('./documentos_exp01.json', 'utf-8'));

const PG_URL = 'postgres://medflow:medflow123@localhost:5433/medflow';
const MONGO_URL = 'mongodb://localhost:27017';
const ID_PACIENTE = 1054;

async function main() {
  const pg = new Client({ connectionString: PG_URL });
  const mongoClient = await MongoClient.connect(MONGO_URL);

  await pg.connect();
  const colecao = mongoClient.db('medflow').collection('documentos');

  // 1. Grava os documentos no MongoDB (limpa antes, para a execução ser repetível)
  await colecao.deleteMany({});
  await colecao.insertMany(
    docs.map((d) => ({ ...d, _id: new ObjectId(d._id) }))
  );
  console.log(`[Mongo] ${docs.length} documentos inseridos.`);

  // 2. Lê o paciente no PostgreSQL
  const { rows } = await pg.query(
    `SELECT u.primeiro_nome, u.sobrenome, p.data_nascimento
       FROM paciente p
       JOIN usuario u ON u.id_usuario = p.id_paciente
      WHERE p.id_paciente = $1`,
    [ID_PACIENTE]
  );

  if (rows.length === 0) {
    throw new Error(`Paciente ${ID_PACIENTE} não encontrado no PostgreSQL.`);
  }

  // 3. Lê os documentos do paciente no MongoDB
  const documentos = await colecao
    .find({ 'referencias_relacionais.id_paciente_sql': ID_PACIENTE })
    .toArray();

  // 4. Junção feita na aplicação (não existe JOIN entre bancos diferentes)
  const resultado = {
    paciente: rows[0],
    documentos,
  };

  console.log('\n=== Paciente + Documentos (junção na aplicação) ===');
  console.log(JSON.stringify(resultado, null, 2));

  await pg.end();
  await mongoClient.close();
}

main().catch((err) => {
  console.error('Erro:', err.message);
  process.exit(1);
});
