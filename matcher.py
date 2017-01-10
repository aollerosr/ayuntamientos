from difflib import SequenceMatcher

a = open('/home/antonio/Python/orphanListas.csv', 'r')
b = open('/home/antonio/Python/orphanReference.csv', 'r')
a = a.read().split('\n')
b = b.read().split('\n')

rslt = ""

for lineA in a:
    strA = str(lineA)
    for lineB in b:
        strB = str(lineB)
        print(strA)    
        rslt = rslt + '"' + lineA + '", "' + lineB + '", ' + str(SequenceMatcher(None, lineA, lineB).ratio()) + "\n"
    

print(rslt)

c = open('/home/antonio/Python/matcherResult.csv', 'w')
c.write(rslt)


c.close()