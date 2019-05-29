import fileinput

# ssh agave 'mq' | tail -n +2 | python jobs.py

fields = ['jobID','partition','jobName','ST','t','tLim',
    'nodes','CPUcoresMIN','CPUcores','nodeList','comment']

mydict = dict((field,[]) for field in fields)

for line in fileinput.input():
  linelist = [item for item in line.split(' ') if item]
  linedict = dict((fields[i],linelist[i]) for i in range(0,len(fields)))
  [ mydict[field].append(linedict[field]) for field in fields ]
        
#  print(linedict)
#  print('')

print('')
print('')
print(mydict)
