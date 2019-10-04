class Dst {
  constructor(obj) {
    this.id = obj.id;
    this.name = obj.full_name;
    this.nfl = obj.nfl_abbrev;
  }
}

// Fetches all Dsts
const allDsts = [];

function getAllDsts() {
  allDsts.length = 0;
  $.get(`/api/v1/team_dsts/`, dsts => {
    dsts.map(dst => {
      allDsts.push(dst);
    });
  });
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

const filterDstAvail = () => {
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
  $(`.player-scroll-list`).html(availDsts);
};

Dst.prototype.displayDst = function() {
  return `
      <div id="selected-${this.id}" style="display:inline">DT ${this.name}<br></div>
    `;
};
