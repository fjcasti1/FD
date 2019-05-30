import fileinput, os

# ssh agave 'mq' | tail -n +2 | python jobs.py
OUTFILE = '/home/kiko/public_html/Website/research/jobs.html'

fields = ['jobID','partition','jobName','ST','t','tLim',
    'nodes','CPUcores','comment']
N = 0
mydict = dict((field,[]) for field in fields)
for line in fileinput.input():
  linelist = [item for item in line.strip('\n').split(' ') if item]
  linedict = dict((fields[i],linelist[i]) for i in range(0,len(fields)))
  [ mydict[field].append(linedict[field]) for field in fields ]
  N += 1
        
Nrun = mydict['ST'].count('RUNNING')
Npend = mydict['ST'].count('PENDING')

code = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="css/reset.css">
  <link rel="stylesheet" href="css/960_24_col.css">
  <link rel="stylesheet" href="css/text.css">
  <link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="css/jobs.css">
  <meta http-equiv="refresh" content="30">
  <title>Agave Jobs Information</title>
</head>
<body>
  <div class="wrap container_24">
    <header class="clearfix">
      <h1 class="grid_14">Agave Jobs Information</h1>
      <nav class="grid_10">
        <ul>
          <li><a href="#">Home</a></li>
          <li><a href="alpha0.html" target="_blank">Results</a></li>
        </ul>
      </nav>
    </header>

    <div class="main clearfix">
      <div class="primary grid_24">
        <h3 class="info">Currently Running Jobs: {}</h3>
        <h3 class="info">Currently Pending Jobs: {}</h3>
        <table>
          <tbody>
            <tr>
              <th>
                <h4>Job ID</h4>
              </th>
              <th>
                <h4>Partition</h4>
              </th>
              <th>
                <h4>Job Name</h4>
              </th>
              <th>
                <h4>Status</h4>
              </th>
              <th>
                <h4>Time Used</h4>
              </th>
              <th>
                <h4>Time Limit</h4>
              </th>
              <th>
                <h4>Nodes</h4>
              </th>
              <th>
                <h4>CPU Cores</h4>
              </th>
              <th>
                <h4>Comment</h4>
              </th>
            </tr>
""".format(Nrun,Npend)

for j in range(0,N):
  code +="""            <tr>
"""
  for field in fields:
    code +="""              <td>
                <h5>{}</h5>
              </td>
""".format(mydict[field][j])
  code +="""            </tr>
"""

code +="""          </tbody>
        </table>
      </div>
    </div>
  </div>
</body>
</html>
"""

with open(OUTFILE,"w") as f:
  f.write("%s" % code)
  f.close()
