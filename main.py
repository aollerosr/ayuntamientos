from bs4 import BeautifulSoup
import rendicion2 
import csv
import numpy
import pandas as pd
import requests 

 
import sys    # sys.setdefaultencoding is cancelled by site.py
reload(sys)    # to re-enable sys.setdefaultencoding()
sys.setdefaultencoding('utf-8')

fl = pd.read_csv('/home/antonio/ayuntamientos/datos/basePedirDatos.csv')
ano = '2013'
estado = 'Balance'
cookie = 'JSESSIONID=EDD2550F9C6F2ACB146F06F69F27277C.tomcatVisualizador1; _ga=GA1.2.1696214080.1479418776; JSESSIONID=50CE85017517E150BAC6AB6E022A3481; _gat=1'

#cookie = rendicion2.getRendicionCookies() #la cookie no funciona


for i in fl.NIF:
    fichero = i + '_' + ano + '_NOR_CUENTAS-ANUALES.xml'    
    print 'Trabajando en: ' + fichero
    r = rendicion2.getDatRendicion('0', ano, estado, fichero, cookie)
    if r.ok == True:
        parseTable(r,'/home/antonio/ayuntamientos/datos/descargas/', ano + "_" + i + "_" + estado + '.csv')
    r.close()


    


