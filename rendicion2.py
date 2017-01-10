# -*- coding: utf-8 -*-
import urllib2
import requests 
from cookielib import CookieJar

def getRendicionCookies():
    """Obtiene una nueva cookie"""
    url = "http://www.rendiciondecuentas.es/es/consultadeentidadesycuentas/buscarCuentas/consultarCuenta.html"
    s = requests.Session()
    s.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36'
    r = s.get(url)
    return r.headers.get('Set-Cookie')


def getDatRendicion(actual,ejercicio, id_form, nombreFichero, cookie): 
    """Obtiene fichero html con los datos resultantes de navegar por el arbol, para una entidad y una fecha"""   

    url = "http://www.rendiciondecuentas.es/VisualizadorPortalCiudadano/VisualizadorPortal.jsp"

    headers = {
        'Accept' : 'text/html, application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Encoding' : 'gzip, deflate',
        'Accept-Language' : 'en-US,en;q=0.5',
        'Connection' : 'keep-alive',
        'Cookie' : cookie,
        'Host' : 'www.rendiciondecuentas.es',
        'Referer' : 'http://www.rendiciondecuentas.es/VisualizadorPortalCiudadano/VisualizadorPortal.jsp',
        'Upgrade-Insecure-Requests' : '1',
        'User-Agent' : 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:50.0) Gecko/20100101 Firefox/50.0'
    }

    s = requests.Session()
    s.headers = headers

    data = {
        'actual' : actual,
        'ejercicio' : ejercicio,
        'id_form' : id_form,
        'modelo' : 'NOR',
        'nombreFichero' : nombreFichero,
        'paginacion' : '10',
        'table' : '1'
    }

    response = s.get(url, data = data)
    s.close
    return response


def getNIFs(rslt):
    """Dado un fichero html, busca un NIF después de encontrar una referencia a nifEntidad"""
    result = "F"
       
    doc = BeautifulSoup(rslt.text, 'html.parser')

    #Buscar NIF
    fullHref = doc.find_all(href=re.compile("nifEntidad"))
    fullHref =str(fullHref)
    for i in range(len(fullHref)):
        if fullHref [i:i+10] == 'nifEntidad' : 
            inicio = i +11
            result = "T" 

    
    if result == "T":
        #Buscar nombre (si existe NIF)
        all_th = doc.find_all('th', class_='txtCenter')

        for item in all_th:
            name = item.string
        
        return '"' + fullHref [inicio:inicio+9]+'","'+ name + '"'
    else:
        return "NA"



