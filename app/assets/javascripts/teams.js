$(() => {
  getTlflTeamAvail(), getTlflTeamTrade();
});

class Team {
  constructor(obj) {
    this.id = obj.id;
    this.name = obj.full_name;
    this.players = obj.players;
    this.dst = obj.team_dst;
    this.picks = obj.draft_picks;
  }
}

const sortOrder = ["QB", "RB", "WR", "TE", "K"];

const getTlflTeamTrade = () => {
  $("#tlfl_team_one_id").on("change", e => {
    e.preventDefault();
    let teamId = e.target.value;
    $.get(`/api/v1/tlfl_teams/${teamId}`, teamData => {
      let tlflTeam = new Team(teamData);
      let displayAssets = tlflTeam.displayTeamAssets();
      $("#team-one-assets").html(displayAssets);
    });
  });
};

const getTlflTeamAvail = () => {
  $("#tlfl_team_id").on("change", e => {
    e.preventDefault();
    let teamId = e.target.value;
    $.get(`/api/v1/tlfl_teams/${teamId}`, teamData => {
      let tlflTeam = new Team(teamData);
      let displayTeam = tlflTeam.displayTeamAvail();
      $(".tlfl-team-available").html(displayTeam);
    });
  });
};

Team.prototype.displayTeamAvail = function() {
  let sortedPlayers = this.players.sort(function(a, b) {
    return sortOrder.indexOf(a.position) - sortOrder.indexOf(b.position);
  });
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

Team.prototype.displayTeamAssets = function() {
  let sortedPlayers = this.players.sort(function(a, b) {
    return sortOrder.indexOf(a.position) - sortOrder.indexOf(b.position);
  });
  let players = sortedPlayers
    .map(player => {
      return `
        <label class="line-height">
          <input type="checkbox" name="players_one[]" id="players_" value="${player.id}" onclick="selectedPlayersTrade(this)">
            ${player.position} ${player.full_name}
          </input>
        </label><br>
      `;
    })
    .join("");

  return `
  <br>
    <strong>ROSTER</strong><br>
    ${players}
    <label class="line-height">
      <input type="checkbox" name="dst_one" id="players_" value="${this.dst.id}" onclick="selectedDstTrade(this)">
        DT ${this.dst.full_name}
      </input>
    </label>
    <br>
    Include Protection?
  `;
};
