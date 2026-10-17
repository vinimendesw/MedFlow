
function verificarAlergia(alergias, componentes) {
    return componentes.some(componente =>
        alergias.includes(componente)
    );
}

module.exports = verificarAlergia;
