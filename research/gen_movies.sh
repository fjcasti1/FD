#!/usr/bin/env/ bash

declare -a alphaList=$(python <<__EOF
from glob import glob
alphaList=[]
D = {}
for f in glob('imgs/*'):
  alpha = f.split('alpha')[-1].split('_')[0]
  if alpha not in alphaList:
    alphaList.append(alpha)
    D[str(float(alpha))] = alpha
for i in sorted(D):
  print(D[i])
__EOF
)
declare -a alphaMovieList=$(python <<__EOF
from glob import glob
alphaList=[]
D = {}
for f in glob('movies/*'):
  alpha = f.split('alpha')[-1].split('_')[0]
  if alpha not in alphaList:
    alphaList.append(alpha)
    D[str(float(alpha))] = alpha
for i in sorted(D):
  print(D[i])
__EOF
)

html_head(){
  alphaValue="$1"
  cat << __EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="css/reset.css">
  <link rel="stylesheet" href="css/960_24_col.css">
  <link rel="stylesheet" href="css/text.css">
  <link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="css/monitor.css">
  <script src="js/jquery-3.4.1.min.js"></script>
  <script src="js/navigation.js"></script>
  <title>Movies &alpha; = $alphaValue</title>
</head>
__EOF
}

html_header(){
  cat << __EOF
<body>
  <div class="wrap container_24">
    <header class="clearfix">
      <h1 class="grid_14">Video Visualization</h1>
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
__EOF
}

html_menu(){
  declare -a figList=($1)
  declare -a movList=($2)
  python << __EOF
figList="${figList[@]}".split()
movList="${movList[@]}".split()
code = """    <div class="menu clearfix" id="MegaMenu">
      <div class="header">
        <h1>Knife Edge Viscosimeter</h1>
      </div>
      <div class="grid_8 alpha">
        <h3>Monitors</h3>
        <ul>"""
for item in figList:
  code+="""
          <li><a href="monitor_alpha{}.html">&alpha; = {}</a></li>""".format(item,item)
code+="""
        </ul>
      </div>
      <div class="grid_8">
        <h3>Videos</h3>
        <ul>"""
for item in movList:
  code+="""
          <li><a href="movies_alpha{}.html">&alpha; = {}</a></li>""".format(item,item)
code+="""
        </ul>
      </div>
      <div class="grid_8 omega">
        <h3>Other</h3>
        <ul>
        </ul>
      </div>
    </div>"""
  
with open("$out","a+") as f:
  f.write("%s" % code)
  f.close()
__EOF
}

html_sideNav0(){
  arr=("$@")
  python << __EOF
def getValue(token,str):
  return str.strip('.png').split(token)[-1].split('_')[0]

def writeDropdownBtn(Bo):
  code = """
      <button class="dropdown-btn" id="Bo{}"
        onclick="activateDropdown(this)">Bo = {}
        <i class="fa fa-caret-down"></i>
      </button>
      <div class="dropdown-container">""".format(Bo,Bo)
  return code

def writeDropdownContent(Bo,Re):
  code = """
        <a href="#Bo{}_Re{}">Re = {}</a>""".format(Bo,Re,Re)
  return code

input = "${arr[@]}"
list = input.split()
code = """
    <aside id="SideNav" class="sidenav">
      <a href="javascript:void(0)" class="closebtn" id="clsSideNavBtn" onclick="closeNav()">&times;</a>i"""

Bo = getValue('Bo',list[0])
code+= writeDropdownBtn(Bo)

for item in list:
  Re = getValue('Re',item)
  if Bo == getValue('Bo',item):
    code+= writeDropdownContent(Bo,Re)
  else:
    code+="""
      </div>"""
    Bo = getValue('Bo',item)
    code+= writeDropdownBtn(Bo)
    code+= writeDropdownContent(Bo,Re)
code+="""
      </div>
    </aside>
"""
with open("$out","a+") as f:
  f.write("%s" % code)
  f.close()
__EOF
}

html_sideNav(){
  arr=("$@")
  python << __EOF
def getValue(token,str):
  return str.strip('.mp4').split(token)[-1].split('_')[0]

def writeDropdownBtn(Bo):
  code = """
      <button class="dropdown-btn" id="Bo{}"
        onclick="activateDropdown(this)">Bo = {}
        <i class="fa fa-caret-down"></i>
      </button>
      <div class="dropdown-container">""".format(Bo,Bo)
  return code

def writeDropdownContent1(Bo,Re):
  code = """
        <button class="dropdown-btn2" id="Bo{}_Re{}"
          onclick="activateDropdown2(this)">Re = {}
          <i class="fa fa-caret-down"></i>
        </button>
        <div class="dropdown-container2">""".format(Bo,Re,Re)
  return code

def writeDropdownContent2(Bo,Re,wf):
  code = """
          <a href="#Bo{}_Re{}_wf{}">&omega;<sub>f</sub> = {}</a>""".format(Bo,Re,wf,wf)
  return code

input = "${arr[@]}"
list = input.split()
code = """
    <aside id="SideNav" class="sidenav">
      <a href="javascript:void(0)" class="closebtn" id="clsSideNavBtn" onclick="closeNav()">&times;</a>i"""

Bo = getValue('Bo',list[0])
Re = getValue('Re',list[0])
code+= writeDropdownBtn(Bo)
code+= writeDropdownContent1(Bo,Re)

for item in list:
  wf = getValue('wf',item)
  if Bo == getValue('Bo',item):
    if Re == getValue('Re',item):
      code+= writeDropdownContent2(Bo,Re,wf)
    else:
      Re = getValue('Re',item)
      code+="""
        </div>"""
      code+= writeDropdownContent1(Bo,Re)
      code+= writeDropdownContent2(Bo,Re,wf)
  else:
    Bo = getValue('Bo',item)
    Re = getValue('Re',item)
    code+="""
        </div>
      </div>"""
    code+= writeDropdownBtn(Bo)
    code+= writeDropdownContent1(Bo,Re)
    code+= writeDropdownContent2(Bo,Re,wf)
code+="""
        </div>
      </div>
    </aside>
"""
with open("$out","a+") as f:
  f.write("%s" % code)
  f.close()
__EOF
}

html_main(){
  alphaValue="$1"
  cat << __EOF
    <div class="main clearfix">
      <h5 class="grid_16">Parameter &alpha; = $alphaValue. Sorted by Bo, Re, &omega;<sub>f</sub>.</h5>
      <div class="primary grid_24">
        <button class="bodyButton" id="toTopBtn" onclick="topFunction()" title="Go to top"><i class="fa fa-angle-double-up fa-2x"></i></button>
        
        <button class="bodyButton" id="opnSideNavBtn" onclick="openNav()"><i class="fa fa-search fa-lg"></i></button>
__EOF
}

html_movies(){
  rec="$1"
  str=$(python << __EOF
import numpy as np
name = "$rec".strip('.mp4')
tokens = ['alpha','Bo', 'Re','wf']
values = dict()
for token in tokens:
  values[token] = name.split(token)[-1].split('_')[0]

if values['wf'] == '0e0':
  wftitle = '0'
else:
  wftitle = values['wf'].lstrip('0')

if values['alpha'] == '0e0':
  print('<b id="Bo{}_Re{}">&alpha; = {} | Bo = {} | Re = {} </b>'.format(values["Bo"],values["Re"],values["alpha"],values["Bo"],values["Re"]))
else:
  print('<b id="Bo{}_Re{}_wf{}">&alpha; = {} | Bo = {} | Re = {} | &omega;<sub>f</sub> = {}</b>'.format(values["Bo"],values["Re"],values["wf"],values["alpha"],values["Bo"],values["Re"],wftitle))
__EOF
2>&1)
  cat << __EOF
        <hr>

        <p>
          ${str}
        </p>

        <video class="grid_8 alpha" autoplay muted loop controls id="myVideo">
          <source src="movies/s${rec}"
            type="video/mp4">
        </video>
        <video class="grid_8" autoplay muted loop controls id="myVideo">
          <source src="movies/x${rec}"
            type="video/mp4">
        </video>
        <video class="grid_8 omega" autoplay muted loop controls id="myVideo">
          <source src="movies/g${rec}"
            type="video/mp4">
        </video>

        <video class="grid_8 alpha" autoplay muted loop controls id="myVideo">
          <source src="movies/s_pert${rec}"
            type="video/mp4">
        </video>
        <video class="grid_8" autoplay muted loop controls id="myVideo">
          <source src="movies/x_pert${rec}"
            type="video/mp4">
        </video>
        <video class="grid_8 omega" autoplay muted loop controls id="myVideo">
          <source src="movies/g_pert${rec}"
            type="video/mp4">
        </video>
        <video class="grid_24" autoplay muted loop controls id="myVideo">
          <source src="movies/surf_v${rec}"
            type="video/mp4">
        </video>
__EOF
}

html_footer(){
  cat << __EOF
      </div>
    </div>
  </div>
</body>
</html>
__EOF
}

search() {
  local -n arr=$1              # use nameref for indirection
  alphaValue="${2}"
# The next line obtains unique sorted list. Gives problems if Bo and Re
# are the same, written exactly the same. Example:
#   Bo = 1e1, Re = 1e1  --> Does not work well
#   Bo = 1e1, Re = 10e0 --> Works well!
  movies=$(find movies/ -type f -iname "*alpha${alphaValue}*.mp4" -not -iname '*pert*' -not -iname '*surf*' -exec basename {} \; | awk 'BEGIN{FS="_"} {gsub("Bo","",$0); gsub("Re","",$0); gsub("wf","",$0); gsub($1,"",$0); print $0}'| sort -t "_" -gk 3,3 -k 2,2 -k 1,1 -k 4,4 | uniq | awk 'BEGIN{FS="_"} {gsub($2,"Re"$2,$0); gsub($3,"Bo"$3,$0); gsub($5,"wf"$5,$0); gsub($1,"",$0); gsub("alphaBo","alpha",$0); print $0}')
  IFS=$'\n' arr=($movies)
}

for alpha in ${alphaMovieList[@]}
do
  out="movies_alpha${alpha}.html"
  echo "$out"
  echo "Searching movies"
  search movies "$alpha"       # call function to populate the array
  echo "Writing Head"
  html_head $alpha > $out
  echo "Writing Header"
  html_header >> $out
  echo "Writing Menu"
  html_menu "${alphaList[@]}" "${alphaMovieList[@]}" 
  echo "Writing sideNav" 
  if [[ $alpha == '0e0' ]]; then
    html_sideNav0 ${movies[@]} # This function appends from python 
    echo "Zero"
  else
    html_sideNav ${movies[@]} # This function appends from python 
    echo "Not zero"
  fi
  
  echo "Writing Main"
  html_main $alpha >> $out
  echo "Writing Movies"
  for mov in ${movies[@]}; do
    html_movies "$mov" >> $out
  done
  echo "Writin Footer"
  html_footer >> $out
    
  echo "$out DONE"
done

