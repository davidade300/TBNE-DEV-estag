# em algum momento isso será um crawler de funcoes advpl no TDN
# se o TDN retornar 200 em vez de 403 ofc

import requests as re

url = "https://tdn.totvs.com/display/tec/tcsqlerror"

resposta = re.get(url)
print(resposta)