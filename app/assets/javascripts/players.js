class Player {
  constructor(obj) {
    this.id = obj.id;
    this.name = obj.full_name;
    this.position = obj.position;
  }
}

const selectedPlayers = player => {
  $.get(`/api/v1/players/${player.value}`, playerData => {
    let tlflPlayer = new Player(playerData);
    if (player.checked)
      $(".selected-available").append(tlflPlayer.displayPlayer());
    if (player.checked === false) $(`#selected-${player.value}`).remove();
  });
};

Player.prototype.displayPlayer = function() {
  return `
    <div id="selected-${this.id}" style="display:inline">${this.position} ${this.name}<br></div>
  `;
};

const playerSearch = () => {
  let input, filter, ul, li, txt, i;
  input = document.getElementById("avail-player-search");
  filter = input.value.toUpperCase();
  ul = document.getElementById("avail-player-list");
  li = ul.getElementsByTagName("li");
  for (i = 0; i < li.length; i++) {
    txt = li[i].innerText;
    if (txt.toUpperCase().indexOf(filter) > -1) {
      li[i].style.display = "";
    } else {
      li[i].style.display = "none";
    }
  }
};

class Dst {
  constructor(obj) {
    this.id = obj.id;
    this.name = obj.full_name;
  }
}

const selectedDst = dst => {
  $.get(`/api/v1/team_dsts/${dst.value}`, dstData => {
    let tlflDst = new Dst(dstData);
    if (dst.checked) $(".selected-available").append(tlflDst.displayDst());
    if (dst.checked === false) $(`#selected-${dst.value}`).remove();
  });
};

Dst.prototype.displayDst = function() {
  return `
    <div id="selected-${this.id}" style="display:inline">DT ${this.name}<br></div>
  `;
};
