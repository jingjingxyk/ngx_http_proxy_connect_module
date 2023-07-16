

KEY_FILE=wildcard.your-domain.com.key.pem
CERT_FILE=wildcard.your-domain.com.fullchain.pem
HOST='cn'
# self sign ca
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"



