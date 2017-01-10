from bs4 import BeautifulSoup
import rendicion2 
import csv
import numpy 
import sys    # sys.setdefaultencoding is cancelled by site.py
reload(sys)    # to re-enable sys.setdefaultencoding()
sys.setdefaultencoding('utf-8')

cookie = rendicion2.getRendicionCookie()
a = rendicion2.getDatRendicion('0', '2014', 'Balance', 'P0400100D_2015_NOR_CUENTAS-ANUALES.xml', 'JSESSIONID=01344652F6361A987D42AF3A5BD6FA54.tomcatVisualizador2; JSESSIONID=1D014858FC9D39A7721AC43CCBD5F880; _gat=1; _ga=GA1.2.733593762.1480358784; treeview=000000000000000000000000000000000000000000')
print(a.text)

doc = BeautifulSoup(a.text, 'html.parser')
table = doc.body.table
header = doc.body.thead
bodyTable = doc.body.tbody
data = []
headerRow = [th.get_text() for th in header.find("tr").find_all("th")]
data.append(headerRow)


for row in bodyTable.findAll("tr"):
    newRow = [td.get_text() for td in row.find_all("td")]
    data.append(newRow)


with open('some.csv', 'wb') as f:
    writer = csv.writer(f)
    for item in data:
    	writer.writerow(item)


