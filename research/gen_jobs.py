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
  <link rel="stylesheet" href="css/monitor.css">
  <script src="js/jquery-3.4.1.min.js"></script>
  <script src="js/navigation.js"></script>
  <meta http-equiv="refresh" content="30">
  <title>Agave Jobs Information</title>
</head>
<body>
  <div class="wrap container_24">
    <header class="clearfix">
      <h1 class="grid_14">Zero Forcing Results</h1>
      <nav class="grid_10">
        <ul>
          <li><a href="#">Home</a></li>
          <li>
            <button class="dropbtn" id="MenuDropBtn"
              onclick="activateMenuDropdown(this)">Results
              <i class="fa fa-caret-down"></i>
          </li>
          <li><a href="jobs.html">Jobs</a></li>
        </ul>
      </nav>
    </header>
    <div class="menu clearfix" id="MegaMenu">
      <div class="header">
        <h1>Knife Edge Viscosimeter</h1>
      </div>
      <div class="grid_8 alpha">
        <h3>Monitors</h3>
        <ul>
          <li><a href="monitor_alpha0e0.html">&alpha; = 0e0</a></li>
          <li><a href="monitor_alpha1e-2.html">&alpha; = 1e-2</a></li>
          <li><a href="monitor_alpha1e-1.html">&alpha; = 1e-1</a></li>
        </ul>
      </div>
      <div class="grid_8">
        <h3>Videos</h3>
        <ul>
          <li><a href="movies_alpha0e0.html">&alpha; = 0e0</a></li>
          <li><a href="movies_alpha1e-2.html">&alpha; = 1e-2</a></li>
          <li><a href="movies_alpha1e-1.html">&alpha; = 1e-1</a></li>
        </ul>
      </div>
      <div class="grid_8 omega">
        <h3>Other</h3>
        <ul>
        </ul>
      </div>
    </div>

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
