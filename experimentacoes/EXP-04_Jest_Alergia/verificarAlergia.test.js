
const verificarAlergia = require('./verificarAlergia');

// TESTE 1 - Com conflito
test('Identifica conflito de alergia', () => {
    const alergias = ['Dipirona'];
    const medicamento = ['Dipirona'];

    expect(verificarAlergia(alergias, medicamento)).toBe(true);
});

// TESTE 2 - Sem conflito
test('Identifica ausencia de conflito', () => {
    const alergias = ['Penicilina'];
    const medicamento = ['Paracetamol'];

    expect(verificarAlergia(alergias, medicamento)).toBe(false);
});

// TESTE 3 - Medicamento composto
test('Identifica conflito em medicamento composto', () => {
    const alergias = ['Dipirona'];
    const medicamento = ['Cafeina', 'Dipirona', 'Orfenadrina'];

    expect(verificarAlergia(alergias, medicamento)).toBe(true);
});
