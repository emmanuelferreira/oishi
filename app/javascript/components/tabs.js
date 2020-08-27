function initTabSelector() {
  const tabcontent = document.getElementsByClassName("tabcontent");
  let i;
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }

  document.querySelectorAll('.tablinks').forEach(item => {
    item.addEventListener('click', event => {
      tabsSelector(event, event.target.dataset.tab);
    });
  });
}

function tabsSelector(evt, categoryName) {
  evt.preventDefault();
  let i, tabcontent, tablinks;
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace("active", "");
  }
  document.getElementById(categoryName).style.display = "block";
  evt.currentTarget.className += " active";
};
export { initTabSelector }