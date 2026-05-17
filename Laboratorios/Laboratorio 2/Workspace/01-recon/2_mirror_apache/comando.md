# Usar --no-proxy para ignorar el proxy
wget --no-proxy --mirror --convert-links --adjust-extension --page-requisites --no-parent --wait=1 --limit-rate=100k -P ./sitio_web http://10.0.3.5/