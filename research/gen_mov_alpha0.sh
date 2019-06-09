#!/usr/bin/env/ bash

out="movies_alpha0.html"
html_head(){
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
  <link rel="stylesheet" href="css/alpha0_style.css">
  <script src="js/jquery-3.4.1.min.js"></script>
  <script src="js/navigation.js"></script>
  <title>Zero Forcing Results</title>
</head>
__EOF
}

html_header(){
  cat << __EOF
<body>
  <div class="wrap container_24">
    <header class="clearfix">
      <h1 class="grid_14">Zero Forcing Results</h1>
      <nav class="grid_10">
        <ul>
          <li><a href="#">Home</a></li>
          <li><a href="jobs.html">Jobs</a></li>
          <li><a href="#">Contact</a></li>
        </ul>
      </nav>
    </header>
__EOF
}

html_sideNav(){
  arr=("$@")
  python << __EOF
def getValue(token,str):
  return str.split(token)[-1].split('_')[0]

def writeDropdownBtn(Bo):
  code = """
      <button class="dropdown-btn" id="Bo{}"
        onclick="activateDropdown(this)">Bo = {}
        <i class="fa fa-caret-down"></i>
      </button>
      <div class="dropdown-container">""".format(Bo,Bo)
  return code

def writeDropdownContent(Re):
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
    code+= writeDropdownContent(Re)
  else:
    code+="""
      </div>"""
    Bo = getValue('Bo',item)
    code+= writeDropdownBtn(Bo)
    code+= writeDropdownContent(Re)
code+="""
      </div>
    </aside>
"""
with open("$out","a+") as f:
  f.write("%s" % code)
  f.close()
__EOF
}

html_main(){
  cat << __EOF
    <div class="main clearfix">
      <h5 class="grid_16">Parameters &alpha;=<i>f</i>=0. Sorted by Bo,
        Re.</h5>
      <div class="primary grid_24">
        <button class="bodyButton" id="toTopBtn" onclick="topFunction()" title="Go to top"><i class="fa fa-angle-double-up fa-2x"></i></button>
        
        <button class="bodyButton" id="opnSideNavBtn" onclick="openNav()"><i class="fa fa-search fa-lg"></i></button>
__EOF
}
html_movies(){
  rec="$1"
  str=$(python << __EOF
name = "$rec"
tokens = ['Bo', 'Re']
values = dict()
for token in tokens:
  values[token] = name.split(token)[-1].split('_')[0]
print('<b id="Bo{}_Re{}">Bo = {} | Re = {}</b>'.format(values["Bo"],values["Re"],values["Bo"],values["Re"]))
__EOF
2>&1)
  cat << __EOF
        <hr>

        <p>
          ${str}
        </p>

        <img class="grid_24"
          src="imgs/ts${rec}"
          alt="urts">

        <img class="grid_24"
          src="imgs/fft${rec}"
          alt="urts">

        <img class="grid_24"
          src="imgs/orbit${rec}"
          alt="urts">

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
# The next line obtains unique sorted list. Gives problems if Bo and Re
# are the same, written exactly the same. Example:
#   Bo = 1e1, Re = 1e1  --> Does not work well
#   Bo = 1e1, Re = 10e0 --> Works well!
movies=$(find movies -type f -iname '*.mp4' -exec basename {} \; | awk 'BEGIN{FS="_"} {gsub("Bo","",$0); gsub("Re","",$0); gsub($1,"",$0); print $0}' | sort -u -t "_" -gk 3,3 -k 2,2 | awk 'BEGIN{FS="_"} {gsub($2,"Re"$2,$0); gsub($3,"Bo"$3,$0); gsub($1,"",$0); print $0}')
IFS=$'\n' inputmovies=($movies)

html_head > $out
html_header >> $out
html_sideNav ${inputmovies[@]} # This function appends from python 
html_main >> $out

for mov in $movies; do
  html_movies "$movies" >> $out
done

html_footer >> $out

