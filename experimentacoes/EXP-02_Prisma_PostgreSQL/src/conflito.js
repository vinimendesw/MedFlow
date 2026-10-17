// Regra de alerta alergia x medicamento (RF-010, RN-011).
// Cruza: paciente -> alergia -> substância -> medicamento_substancia -> medicamento.
// Por usar a tabela de substâncias, detecta conflito também em medicamentos COMPOSTOS.

async function verificarConflito(prisma, idPaciente, idMedicamento) {
  const alergias = await prisma.paciente_possui_alergia.findMany({
    where: { id_paciente: idPaciente, data_exclusao: null }, // ignora registros com soft delete
    include: { alergia: true },
  });

  const idsSubstancia = alergias.map((a) => a.alergia.id_substancia);
  if (idsSubstancia.length === 0) return { conflito: false, motivos: [] };

  const componentes = await prisma.medicamento_substancia.findMany({
    where: { id_medicamento: idMedicamento, id_substancia: { in: idsSubstancia } },
    include: { substancia: true },
  });

  const motivos = componentes.map((c) => {
    const a = alergias.find((x) => x.alergia.id_substancia === c.id_substancia);
    return {
      substancia: c.substancia.nome,
      alergia: a.alergia.nome,
      severidade_reacao: a.severidade_reacao,
      nivel_risco: a.alergia.nivel_risco,
    };
  });

  return { conflito: motivos.length > 0, motivos };
}

module.exports = { verificarConflito };
