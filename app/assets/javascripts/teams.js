class Team {
  constructor(obj) {
    this.id = obj.id;
    this.name = obj.full_name;
    this.players = obj.players;
    this.dst = obj.team_dst;
    this.picks = obj.draft_picks;
    this.protections = obj.protections;
  }
}

const sortOrder = ["QB", "RB", "WR", "TE", "K"];

const getTlflTeamIr = team => {
  $(`#ir-reserving-player`).html("");
  $(`#ir-replacement-options`).html("");
  $(`#ir-replacement-player`).html("");
  let teamId = team.value;
  $.get(`/api/v1/tlfl_teams/${teamId}`, teamData => {
    let tlflTeam = new Team(teamData);
    let displayPlayers = tlflTeam.displayTeamPlayersIr();
    $(`#ir-roster`).html(displayPlayers);
  });
};

const getTlflTeamTrade = team => {
  let tm_num = team.id.slice(10, 13);
  let teamId = team.value;
  $(`#team-${tm_num}-trades`).html("");
  $.get(`/api/v1/tlfl_teams/${teamId}`, teamData => {
    let tlflTeam = new Team(teamData);
    let displayAssets = tlflTeam.displayTeamAssets(tm_num);
    $(`#team-${tm_num}-assets`).html(displayAssets);
    $(`#team-${tm_num}-trades-head`).html(
      `<strong>${tlflTeam.name} Trade:</strong>`
    );
  });
};

const getTlflTeamAvail = team => {
  let teamId = team.value;
  $.get(`/api/v1/tlfl_teams/${teamId}`, teamData => {
    let tlflTeam = new Team(teamData);
    let displayTeam = tlflTeam.displayTeamAvail();
    $(".tlfl-team-available").html(displayTeam);
  });
};

Team.prototype.displayTeamAvail = function() {
  let sortedPlayers = this.players.sort(
    (a, b) => sortOrder.indexOf(a.position) - sortOrder.indexOf(b.position)
  );

  let players = sortedPlayers
    .map(player => {
      return `${player.position} ${player.full_name} <br>`;
    })
    .join("");

  let total = this.players.length;

  if (this.dst) total++;

  return `
    <h4 style="display:inline">${this.name}: ${total}</h4><br>
    <p style="display:inline">${players}</p>
    <p>${this.dst ? `DT ${this.dst.full_name}` : ""}</p>
  `;
};

Team.prototype.displayTeamAssets = function(tm_num) {
  let sortedPlayers = this.players.sort(
    (a, b) => sortOrder.indexOf(a.position) - sortOrder.indexOf(b.position)
  );
  let players = sortedPlayers
    .map(player => {
      return `
        <label class="line-height">
          <input type="checkbox" name="players_${tm_num}[]" id="players_" value="${player.id}" onclick="selectedPlayersTrade(this)">
            ${player.position} ${player.full_name}
          </input>
        </label><br>
      `;
    })
    .join("");

  let sortedPicks = this.picks.sort((a, b) =>
    a.overall > b.overall
      ? 1
      : a.overall === b.overall
      ? a.round > b.round
        ? 1
        : -1
      : -1
  );

  let picks = sortedPicks
    .map(pick => {
      return `
        <label class="line-height">
          <input type="checkbox" name="picks_${tm_num}[]" id="picks_" value="${pick.id}" onclick="selectedPicksTrade(this)">
            ${pick.full}
          </input>
        </label><br>
      `;
    })
    .join("");

  return `
    <br>
    Protection Spots: ${this.protections}
    <br><br>
    <strong>ROSTER</strong><br>
    ${players}
    <label class="line-height">
      <input type="checkbox" name="dst_${tm_num}" id="players_" value="${this.dst.id}" onclick="selectedDstTrade(this)">
        DT ${this.dst.full_name}
      </input>
    </label>
    <br><br>
    <strong>DRAFT PICKS</strong><br>
    ${picks}
    <br>
    <label class="line-height">
      <input type="checkbox" name="protection_${tm_num}" id="protection-${tm_num}" onclick="selectedProtectionTrade(this)">
        Protection Spot
      </input>
    </label>
    <br><br><br>
  `;
};

Team.prototype.displayTeamPlayersIr = function() {
  let sortedPlayers = this.players.sort(
    (a, b) => sortOrder.indexOf(a.position) - sortOrder.indexOf(b.position)
  );
  let players = sortedPlayers
    .map(player => {
      if (player.ir_id === null)
        return `
          <label class="line-height">
            <input type="radio" name="ir_player" value="${player.id}" onclick="selectedPlayerIr(this)" required>
              ${player.position} ${player.full_name}
            </input>
          </label><br>
        `;
    })
    .join("");

  return `
    <br>
    <p style="display:inline">${players}</p>
  `;
};
