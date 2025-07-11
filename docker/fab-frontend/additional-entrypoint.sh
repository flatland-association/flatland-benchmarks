set -euxo

cd /usr/share/nginx/html/
FILE_NAME=`ls main*.js`
cp ${FILE_NAME} /tmp/${FILE_NAME}
sed -i 's|issuer:"https://keycloak.flatland.cloud/realms/flatland",|issuer:"http://localhost:8081/realms/flatland",|g' /tmp/${FILE_NAME}
cat /tmp/${FILE_NAME} > ${FILE_NAME}
fgrep -o 'issuer:"http://localhost:8081/realms/flatland"' main*.js
