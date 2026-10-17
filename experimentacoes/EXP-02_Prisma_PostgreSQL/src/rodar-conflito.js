// Executa a consulta de conflito para 3 casos e imprime o resultado (evidência da EXP-02)
const { PrismaClient } = require('@prisma/client');
const { verificarConflito } = require('./conflito');
const prisma = new PrismaClient();

async function main() {
  const paciente = await prisma.usuario.findUnique({ where: { cpf: '11111111111' } });
  if (!paciente) throw new Error('Paciente de teste não encontrado. Rode: npx prisma db seed');

  const casos = [
    { descricao: 'Amoxil (amoxicilina)          -> esperado: CONFLITO', anvisa: 'ANV-0001' },
    { descricao: 'Clavulin (composto c/ amox.)  -> esperado: CONFLITO', anvisa: 'ANV-0002' },
    { descricao: 'Tylenol (paracetamol)         -> esperado: SEM conflito', anvisa: 'ANV-0003' },
  ];

  console.log(`Paciente: ${paciente.primeiro_nome} ${paciente.sobrenome} (alérgica a amoxicilina)\n`);

  for (const caso of casos) {
    const med = await prisma.medicamento.findUnique({ where: { codigo_anvisa: caso.anvisa } });
    const r = await verificarConflito(prisma, paciente.id_usuario, med.id_medicamento);
    console.log(caso.descricao);
    console.log('  resultado:', r.conflito ? 'CONFLITO' : 'sem conflito');
    if (r.conflito) console.table(r.motivos);
    console.log('');
  }
}

main()
  .catch((e) => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
