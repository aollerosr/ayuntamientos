# -*- coding: utf-8 -*-
import urllib2
import requests 
from cookielib import CookieJar
from bs4 import BeautifulSoup
import mechanize


def getRendicionCookies():
    """Obtiene una nueva cookie"""
    url = "http://www.rendiciondecuentas.es/es/consultadeentidadesycuentas/buscarCuentas/consultarCuenta.html"
    s = requests.Session()
    s.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36'
    r = s.get(url)
    return r.headers.get('Set-Cookie')


def getDatRendicion(actual, ejercicio, id_form, nombreFichero, cookie): 
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


def parseTable(doc, path, fileName):
    #doc = BeautifulSoup(r.text, 'html.parser')
    table = doc.body.table
    header = doc.body.thead
    bodyTable = doc.body.tbody
    data = []
    headerRow = [th.get_text() for th in header.find("tr").find_all("th")]
    data.append(headerRow)


    for row in bodyTable.findAll("tr"):
        newRow = [td.get_text()  for td in row.find_all("td")]
        data.append(newRow)

    with open(path + fileName, 'wb') as f:
        writer = csv.writer(f)
        for item in data:
            writer.writerow(item)

def getEstado(idEntidadPpal, idEntidad, idTipoEntidad, ejercicio, nifEntidad, id_form):
    br = mechanize.Browser()

    # Cookie Jar
    cj = cookielib.LWPCookieJar()
    br.set_cookiejar(cj)

    # Browser options
    br.set_handle_equiv(True)
    br.set_handle_gzip(True)
    br.set_handle_redirect(True)
    br.set_handle_referer(True)
    br.set_handle_robots(False)

    # Follows refresh 0 but not hangs on refresh > 0
    br.set_handle_refresh(mechanize._http.HTTPRefreshProcessor(), max_time=1)

    
    # User-Agent (this is cheating, ok?)
    br.addheaders = [('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1')]
    
    url = "http://www.rendiciondecuentas.es/es/consultadeentidadesycuentas/buscarCuentas/consultarCuenta.html?dd=true&idEntidadPpal=" + idEntidadPpal + "&idEntidad=" + idEntidad + "&idTipoEntidad=" + idTipoEntidad + "&idModelo=3&ejercicio=" + ejercicio + "&nifEntidad=" + nifEntidad
    
    br.open(url)
    br.select_form(nr=1)
    br.form['option'] = ['vc']
    br.submit()
    
    nombreFichero = nifEntidad + '_' + ejercicio + '_NOR_CUENTAS-ANUALES.xml'
    
    url = "http://www.rendiciondecuentas.es/VisualizadorPortalCiudadano/ServletDatos?ejercicio=2008&modelo=NOR&paginacion=10&actual=0&id_form=" + id_form + "&nombreFichero=" + nombreFichero +  "&table=1"
    br.open(url)
    r = br.response()
    r = BeautifulSoup(r.read(), 'html.parser')
    
    return r
    

