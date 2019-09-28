class Player {
  constructor(obj) {
    this.id = obj.id;
    this.name = obj.full_name;
    this.position = obj.position;
    this.nfl = obj.nfl_abbrev;
    // this.tlflTeam = obj.tlfl_team;
    // this.available = obj.available;
  }
}

// Fetches all players
const allPlayers = [];

function getAllPlayers() {
  allPlayers.length = 0;
  $.get(`/api/v1/players/`, players => {
    players.map(player => {
      allPlayers.push(player);
    });
  });
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

const filterPositionAvail = pos => {
  let sortedPlayers = allPlayers.sort(
    (a, b) => sortOrder.indexOf(a.position) - sortOrder.indexOf(b.position)
  );
  let posAvail;
  if (pos.innerText === "All") {
    posAvail = sortedPlayers
      .map(player => {
        if (player.available === true)
          return `
            <li>
              <label class="line-height">
                <input type="checkbox" name="players[]" id="players_" value="${player.id}" onclick="selectedPlayers(this)">
                  ${player.position} ${player.last_name}, ${player.first_name} - ${player.nfl_abbrev}
                </input>
              </label>
            </li>
          `;
      })
      .join("");
    $(`.player-scroll-list`).html(posAvail);
    let availDsts = allDsts
      .map(dst => {
        if (dst.tlfl_team_id === null)
          return `
            <li>
              <label class="line-height">
                <input type="checkbox" name="dst" id="dst" value="${dst.id}" onclick="selectedDst(this)">
                  DT ${dst.full_name} - ${dst.nfl_abbrev}
                </input>
              </label>
            </li>
          `;
      })
      .join("");
    $(`.player-scroll-list`).append(availDsts);
  } else {
    posAvail = allPlayers
      .map(player => {
        if (player.available === true && player.position === pos.innerText)
          return `
            <li>
              <label class="line-height">
                <input type="checkbox" name="players[]" id="players_" value="${player.id}" onclick="selectedPlayers(this)">
                  ${player.position} ${player.last_name}, ${player.first_name} - ${player.nfl_abbrev}
                </input>
              </label>
            </li>
          `;
      })
      .join("");
    $(`.player-scroll-list`).html(posAvail);
  }
};

Player.prototype.displayPlayerIrOptions = function() {
  let irOptions = allPlayers
    .map(player => {
      if (
        player.nfl_abbrev === this.nfl &&
        player.position === this.position &&
        player.available === true
      )
        return `
          <label class="line-height">
            <input type="radio" name="replacement" value="${player.id}" onclick="selectedPlayerReplacement(this)" required>
              ${player.position} ${player.full_name}
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
