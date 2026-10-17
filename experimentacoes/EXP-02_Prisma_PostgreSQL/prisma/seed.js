// Dados de teste da EXP-02 (todos fictícios)
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const jaExiste = await prisma.usuario.findUnique({ where: { cpf: '11111111111' } });
  if (jaExiste) {
    console.log('Seed já aplicado. Para refazer: npx prisma migrate reset');
    return;
  }

  // --- Substâncias (catálogo) ---
  const amoxicilina = await prisma.substancia.create({
    data: { nome: 'Amoxicilina', classe_quimica: 'Penicilina', codigo_dcb: 'DCB-0001' },
  });
  const clavulanato = await prisma.substancia.create({
    data: { nome: 'Clavulanato de potássio', classe_quimica: 'Inibidor de beta-lactamase', codigo_dcb: 'DCB-0002' },
  });
  const paracetamol = await prisma.substancia.create({
    data: { nome: 'Paracetamol', classe_quimica: 'Analgésico', codigo_dcb: 'DCB-0003' },
  });

  // --- Medicamentos (Clavulin é COMPOSTO: amoxicilina + clavulanato) ---
  const amoxil = await prisma.medicamento.create({
    data: {
      nome_comercial: 'Amoxil', principio_ativo: 'Amoxicilina', codigo_anvisa: 'ANV-0001',
      substancias: { create: [{ id_substancia: amoxicilina.id_substancia, concentracao: '500 mg' }] },
    },
  });
  const clavulin = await prisma.medicamento.create({
    data: {
      nome_comercial: 'Clavulin', principio_ativo: 'Amoxicilina + Clavulanato', codigo_anvisa: 'ANV-0002',
      substancias: {
        create: [
          { id_substancia: amoxicilina.id_substancia, concentracao: '875 mg' },
          { id_substancia: clavulanato.id_substancia, concentracao: '125 mg' },
        ],
      },
    },
  });
  const tylenol = await prisma.medicamento.create({
    data: {
      nome_comercial: 'Tylenol', principio_ativo: 'Paracetamol', codigo_anvisa: 'ANV-0003',
      substancias: { create: [{ id_substancia: paracetamol.id_substancia, concentracao: '750 mg' }] },
    },
  });

  // --- Alergia (catálogo) ---
  const alergiaAmox = await prisma.alergia.create({
    data: { id_substancia: amoxicilina.id_substancia, nome: 'Alergia a Amoxicilina', nivel_risco: 'ALTO' },
  });

  // --- Usuários (paciente e médicos). paciente/medico compartilham a PK com usuario ---
  const usuPaciente = await prisma.usuario.create({
    data: {
      primeiro_nome: 'Maria', sobrenome: 'Teste', cpf: '11111111111',
      email: 'maria.teste@example.com', senha_hash: 'hash-fake', tipo_usuario: 'PACIENTE',
      paciente: { create: { data_nascimento: new Date('1950-05-10'), sexo: 'F', tipo_sanguineo: 'O+' } },
    },
  });
  const usuMedicoGO = await prisma.usuario.create({
    data: {
      primeiro_nome: 'Carlos', sobrenome: 'Exemplo', cpf: '22222222222',
      email: 'carlos.exemplo@example.com', senha_hash: 'hash-fake', tipo_usuario: 'MEDICO',
      medico: { create: { crm: '12345', uf_crm: 'GO' } },
    },
  });
  // Mesmo CRM em outra UF: com a correção UNIQUE(crm, uf_crm) isto DEVE funcionar
  await prisma.usuario.create({
    data: {
      primeiro_nome: 'Ana', sobrenome: 'Modelo', cpf: '33333333333',
      email: 'ana.modelo@example.com', senha_hash: 'hash-fake', tipo_usuario: 'MEDICO',
      medico: { create: { crm: '12345', uf_crm: 'SP' } },
    },
  });
  console.log('OK: mesmo CRM (12345) em GO e SP foi aceito.');

  // Mesmo CRM na mesma UF: DEVE falhar (P2002)
  try {
    await prisma.usuario.create({
      data: {
        primeiro_nome: 'Duplicado', sobrenome: 'Teste', cpf: '44444444444',
        email: 'duplicado@example.com', senha_hash: 'hash-fake', tipo_usuario: 'MEDICO',
        medico: { create: { crm: '12345', uf_crm: 'GO' } },
      },
    });
    console.log('ERRO: o CRM duplicado na mesma UF foi aceito (não deveria).');
  } catch (e) {
    console.log('OK: CRM duplicado na mesma UF foi rejeitado (' + e.code + ').');
  }

  // --- Vínculo: paciente é alérgica a amoxicilina ---
  await prisma.paciente_possui_alergia.create({
    data: {
      id_paciente: usuPaciente.id_usuario,
      id_alergia: alergiaAmox.id_alergia,
      severidade_reacao: 'GRAVE',
      identificado_por_id_usuario: usuMedicoGO.id_usuario,
    },
  });

  console.log('Seed concluído.');
  console.log({ amoxil: amoxil.id_medicamento, clavulin: clavulin.id_medicamento, tylenol: tylenol.id_medicamento });
}

main()
  .catch((e) => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
