import {Controller} from "@hotwired/stimulus";

function stateFor(checked: boolean): string {
  if (checked) { return "complete"; }
  return "incomplete";
}

export default class extends Controller {
  static override values = {
    cardId: String,
    itemId: String,
    url: String,
  };

  declare cardIdValue: string;

  declare itemIdValue: string;

  declare urlValue: string;

  toggle(): void {
    const {element} = this;

    if (!(element instanceof HTMLInputElement)) { return; }

    const csrfSelector = "meta[name=\"csrf-token\"]";
    const csrfMeta = document.querySelector<HTMLMetaElement>(csrfSelector);
    if (!csrfMeta) {
      element.checked = !element.checked;
      return;
    }

    const state = stateFor(element.checked);

    fetch(this.urlValue, {
      body: JSON.stringify({
        cardId: this.cardIdValue,
        itemId: this.itemIdValue,
        state,
      }),
      headers: {
        "content-type": "application/json",
        "X-CSRF-Token": csrfMeta.content,
      },
      method: "PUT",
    }).
      then((response) => {
        if (!response.ok) { element.checked = !element.checked; }
      }).
      catch(() => {
        element.checked = !element.checked;
      });
  }
}
