-- Mesma consulta em SQL puro (para rodar direto no PostgreSQL e tirar print)
-- docker exec -it medflow-pg psql -U medflow -d medflow
SELECT u.primeiro_nome AS paciente,
       m.nome_comercial AS medicamento,
       s.nome           AS substancia_em_conflito,
       a.nome           AS alergia,
       ppa.severidade_reacao
FROM paciente_possui_alergia ppa
JOIN usuario u                ON u.id_usuario = ppa.id_paciente
JOIN alergia a                ON a.id_alergia = ppa.id_alergia
JOIN medicamento_substancia ms ON ms.id_substancia = a.id_substancia
JOIN substancia s             ON s.id_substancia = ms.id_substancia
JOIN medicamento m            ON m.id_medicamento = ms.id_medicamento
WHERE ppa.data_exclusao IS NULL
ORDER BY m.nome_comercial;
