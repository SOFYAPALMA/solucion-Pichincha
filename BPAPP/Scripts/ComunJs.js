
function MensajeGeneral(msj) {
    $("#NotificacionesGenerales").html('<span class="text-danger field-validation-error"> - ' + msj + '<br /></span>');
}

function LimpiarMensajeGeneral() {
    $("#NotificacionesGenerales").empty();
}