class DraftPick {
  constructor(obj) {
    this.id = obj.id;
    this.full = obj.full;
  }
}

const selectedPicksTrade = pick => {
  let tm_num = pick.name.slice(6, 9);
  $.get(`/api/v1/draft_picks/${pick.value}`, pickData => {
    let tlflPick = new DraftPick(pickData);
    if (pick.checked)
      $(`#team-${tm_num}-trades`).append(tlflPick.displayPick());
    if (pick.checked === false) $(`#selected-${pick.value}`).remove();
  });
};

DraftPick.prototype.displayPick = function() {
  return `
      <div id="selected-${this.id}" style="display:inline">${this.full}<br></div>
    `;
};

const selectedProtectionTrade = protection => {
  let tm_num = protection.name.slice(11, 14);
  if (protection.checked)
    $(`#team-${tm_num}-trades`).append(
      `<div id="protection-${tm_num}-display">Protection Spot</div>`
    );
  if (protection.checked === false) $(`#protection-${tm_num}-display`).remove();
};
