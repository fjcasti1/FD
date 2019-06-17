/* All dropdown buttons to toggle between hiding and
 * showing its dropdown content - This allows the user to have multiple
 * dropdowns without any conflict */
function activateDropdown(dropdownObj) {
  var dropdown = document.getElementById(dropdownObj.id);
  dropdown.classList.toggle("active")
  dropdownContent = dropdown.nextElementSibling;
  if (dropdownContent.style.display === "block") {
    dropdownContent.style.display = "none";
  } 
  else {
    dropdownContent.style.display = "block";
  }
}

/* Set the width of the side navigation to 250px */
function openNav() {
  document.getElementById("SideNav").style.width = "252px";
/*  document.getElementById("SideNav").style.width = "15%";*/
}

/* Set the width of the side navigation to 0 */
function closeNav() {
  document.getElementById("SideNav").style.width = "0";
  var dropdowns = document.getElementsByClassName("dropdown-btn active");
    for (var i = dropdowns.length-1; i>-1; i--) {
        dropdowns[i].classList.toggle("active")
    }
  var contents = document.getElementsByClassName("dropdown-container");
    for (var i = 0; i < contents.length; i++) {
        if (contents[i].style.display === "block") {
          contents[i].style.display = "none";
        } 
    }
}

// When the user scrolls down 140px from the top of the document, show
// the button
window.onscroll = function() {scrollFunction()};

function scrollFunction() {
  if (document.body.scrollTop > 140 || document.documentElement.scrollTop > 140)
  {
    document.getElementById("toTopBtn").style.display = "block";
  } 
  else 
  {
    document.getElementById("toTopBtn").style.display = "none";
  }
}

// When the user clicks on the button, scroll to the top of the document
function topFunction() {
  document.body.scrollTop = 0; // For Safari
  document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
}
// Fades out the button that opens the side navigator when its pressed
$(document).ready(function(){
  $("#opnSideNavBtn").click(function(){
    $("#opnSideNavBtn").fadeOut(450);
  });
});
// When the user closes the side navigator, the button that opens it
// fades in
$(document).ready(function(){
  $("#clsSideNavBtn").click(function(){
    $("#opnSideNavBtn").fadeIn(450);
  });
});

/* Dropdown MegaMenu */
function activateMenuDropdown(dropdownObj) {
  var dropdown = document.getElementById("MegaMenu");
/*  if (dropdown.style.display === "none") {
    dropdown.style.display = "block";
    setTimeout(function() {
      dropdown.style.opacity = 1;
    }, 20);
  } 
  else {
    dropdown.style.display = "block";
  }*/
  dropdown.classList.toggle("show")
/*  document.getElementById("MegaMenu").style.display = "block";*/
/*  dropdownContent = dropdown.nextElementSibling;
  if (dropdownContent.style.display === "block") {
    dropdownContent.style.display = "none";
  } 
  else {
    dropdownContent.style.display = "block";
  }*/
}
