class Player {
  constructor(obj) {
    this.id = obj.id;
    this.name = obj.full_name;
    this.position = obj.position;
  }
}

Player.prototype.displayPlayer = function() {
  return `
        <div id="selected-${this.id}" style="display:inline">${this.position} ${this.name}<br></div>
    `;
};

const selectedPlayers = player => {
  $.get(`/api/v1/players/${player.value}`, playerData => {
    let tlflPlayer = new Player(playerData);
    if (player.checked)
      $(".selected-available").append(tlflPlayer.displayPlayer());
    if (player.checked === false) $(`#selected-${player.value}`).remove();
  });
};
