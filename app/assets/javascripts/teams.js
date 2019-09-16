$(() => {
  getTlflTeam();
});

const getTlflTeam = () => {
  $("#tlfl_team_id").on("change", e => {
    e.preventDefault();
    let teamId = e.target.value;
    $.get(`/api/v1/tlfl_teams/${teamId}`, teamData => {
      let tlflTeam = new Team(teamData);
      let displayTeam = tlflTeam.displayTeam();
      $(".tlfl-team-available").html(displayTeam);
    });
  });
};

class Team {
  constructor(obj) {
    this.id = obj.id;
    this.name = obj.full_name;
    this.players = obj.players;
    this.dst = obj.team_dst;
  }
}

Team.prototype.displayTeam = function() {
  let playersQbRbWr = this.players
    .map(player => {
      if (
        player.position === "QB" ||
        player.position === "RB" ||
        player.position === "WR"
      )
        return `${player.position} ${player.full_name} <br>`;
    })
    .sort()
    .join("");

  let playersTeK = this.players
    .map(player => {
      if (player.position === "TE" || player.position === "K")
        return `${player.position} ${player.full_name} <br>`;
    })
    .join("");

  let total = this.players.length;

  if (this.dst) total++;

  return `
            <h4 style="display:inline">${this.name}: ${total}</h4><br>
            <p style="display:inline">${playersQbRbWr}</p>
            <p style="display:inline">${playersTeK}</p>
            <p>${this.dst ? `DT ${this.dst.full_name}` : ""}</p>
    `;
};
