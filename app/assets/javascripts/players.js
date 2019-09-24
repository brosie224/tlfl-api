$(() => {
  getAllPlayers();
});

class Player {
  constructor(obj) {
    this.id = obj.id;
    this.name = obj.full_name;
    this.position = obj.position;
    this.nfl = obj.nfl_abbrev;
    this.tlflTeam = obj.tlfl_team;
    this.ir_match = 0;
  }
}

// Displays players selected to be added to team
const selectedPlayers = player => {
  $.get(`/api/v1/players/${player.value}`, playerData => {
    let tlflPlayer = new Player(playerData);
    if (player.checked)
      $(".selected-available").append(tlflPlayer.displayPlayer());
    if (player.checked === false) $(`#selected-${player.value}`).remove();
  });
};

// Displays players selected to trade from each team
const selectedPlayersTrade = player => {
  let tm_num = player.name.slice(8, 11);
  $.get(`/api/v1/players/${player.value}`, playerData => {
    let tlflPlayer = new Player(playerData);
    if (player.checked)
      $(`#team-${tm_num}-trades`).append(tlflPlayer.displayPlayer());
    if (player.checked === false) $(`#selected-${player.value}`).remove();
  });
};

// Displays player selected to be put on IR and the replacement options
const selectedPlayerIr = player => {
  $.get(`/api/v1/players/${player.value}`, playerData => {
    let tlflPlayer = new Player(playerData);
    $(`#ir-reserving-player`).html(tlflPlayer.displayPlayer());
    $(`#ir-replacement-options`).html(tlflPlayer.displayPlayerIrOptions());
    $(`#avail-team-pos`).html(
      `<strong>Available ${tlflPlayer.nfl} ${tlflPlayer.position}</strong>`
    );
  });
};

// Displays player selected to be put on IR replacement
const selectedPlayerReplacement = player => {
  $.get(`/api/v1/players/${player.value}`, playerData => {
    let tlflPlayer = new Player(playerData);
    $(`#ir-replacement-player`).html(tlflPlayer.displayPlayer());
  });
};

// Fetches all players
let allAvailable = [];

function getAllPlayers() {
  $("#tlfl_team_ir_id").on("change", e => {
    e.preventDefault();
    allAvailable.length = 0;
    $(`#avail-team-pos`).html("");
    $.get(`/api/v1/players/`, players => {
      players.map(player => {
        allAvailable.push(player);
      });
    });
  });
}

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

Player.prototype.displayPlayerIrOptions = function() {
  let irOptions = allAvailable
    .map(player => {
      if (
        player.nfl_abbrev === this.nfl &&
        player.position === this.position &&
        player.tlfl_team === null
      )
        return `
        <label class="line-height">
          <input type="radio" name="ir_replacement" value="${player.id}" onclick="selectedPlayerReplacement(this)" required>
            ${player.position} ${player.full_name}
          </input>
        </label><br>
      `;
    })
    .join("");

  return irOptions;
};

Player.prototype.displayPlayer = function() {
  return `
    <div id="selected-${this.id}" style="display:inline">${this.position} ${this.name}<br></div>
  `;
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

const selectedDstTrade = dst => {
  let tm_num = dst.name.slice(4, 7);
  $.get(`/api/v1/team_dsts/${dst.value}`, dstData => {
    let tlflDst = new Dst(dstData);
    if (dst.checked) $(`#team-${tm_num}-trades`).append(tlflDst.displayDst());
    if (dst.checked === false) $(`#selected-${dst.value}`).remove();
  });
};

Dst.prototype.displayDst = function() {
  return `
    <div id="selected-${this.id}" style="display:inline">DT ${this.name}<br></div>
  `;
};
