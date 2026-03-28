import {bootStimulus, getController} from "support/stimulus";
import ChecklistItemController from "controllers/checklist_item_controller";
import {assert} from "helpers/assert";

const checkUrl = "/checks/1/update_checklist_item";

function setupDOM(): void {
  document.body.innerHTML = `
    <meta name="csrf-token" content="test-csrf-token">
    <input
      type="checkbox"
      data-controller="checklist-item"
      data-checklist-item-card-id-value="card-1"
      data-checklist-item-item-id-value="item-1"
      data-checklist-item-url-value="${checkUrl}"
    >
  `;
}

async function setupController(): Promise<void> {
  setupDOM();
  await bootStimulus("checklist-item", ChecklistItemController);
}

function checkbox(): HTMLInputElement {
  const selector = "[data-controller='checklist-item']";
  return assert(document.querySelector<HTMLInputElement>(selector));
}

function controller(): ChecklistItemController {
  return getController(checkbox(), "checklist-item", ChecklistItemController);
}

describe("#toggle request", () => {
  it("sends the full request when the checkbox is checked", async () => {
    await setupController();
    checkbox().checked = true;
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue(new Response()));

    controller().toggle();

    expect(vi.mocked(globalThis.fetch)).toHaveBeenCalledWith(
      checkUrl,
      expect.objectContaining({
        body: JSON.stringify({
          cardId: "card-1",
          itemId: "item-1",
          state: "complete",
        }),
        headers: {
          "content-type": "application/json",
          "X-CSRF-Token": "test-csrf-token",
        },
        method: "PUT",
      }),
    );
  });

  it("sends state incomplete when the checkbox is unchecked", async () => {
    await setupController();
    checkbox().checked = false;
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue(new Response()));

    controller().toggle();

    expect(vi.mocked(globalThis.fetch)).toHaveBeenCalledWith(
      checkUrl,
      expect.objectContaining({
        body: JSON.stringify({
          cardId: "card-1",
          itemId: "item-1",
          state: "incomplete",
        }),
      }),
    );
  });
});

describe("#toggle on fetch failure", () => {
  it("reverts the checkbox on network error", async () => {
    await setupController();
    checkbox().checked = true;
    vi.stubGlobal("fetch", vi.fn().mockRejectedValue(new Error("oops")));

    controller().toggle();

    await Promise.resolve();
    await Promise.resolve();

    expect(checkbox().checked).toBe(false);
  });

  it("reverts the checkbox to its previous state on HTTP error", async () => {
    await setupController();
    checkbox().checked = true;
    const errorResponse = new Response(null, {status: 422});
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue(errorResponse));

    controller().toggle();

    await Promise.resolve();

    expect(checkbox().checked).toBe(false);
  });
});

describe("#toggle when element is not an input", () => {
  it("does not send a fetch request", async () => {
    document.body.innerHTML = `<div
      data-controller="checklist-item"
      data-checklist-item-card-id-value="card-1"
      data-checklist-item-checklist-id-value="checklist-1"
      data-checklist-item-item-id-value="item-1"
      data-checklist-item-url-value="${checkUrl}"
    ></div>`;
    await bootStimulus("checklist-item", ChecklistItemController);
    vi.stubGlobal("fetch", vi.fn());
    const el = assert(document.querySelector<HTMLElement>("[data-controller]"));
    const ctrl = getController(el, "checklist-item", ChecklistItemController);

    ctrl.toggle();

    expect(vi.mocked(globalThis.fetch)).not.toHaveBeenCalled();
  });
});

describe("#toggle without a CSRF meta tag", () => {
  it("reverts the checkbox and does not send a request", async () => {
    document.body.innerHTML = `
      <input
        type="checkbox"
        data-controller="checklist-item"
        data-checklist-item-card-id-value="card-1"
        data-checklist-item-item-id-value="item-1"
        data-checklist-item-url-value="${checkUrl}"
      >
    `;
    await bootStimulus("checklist-item", ChecklistItemController);
    checkbox().checked = true;
    vi.stubGlobal("fetch", vi.fn());

    controller().toggle();

    expect(vi.mocked(globalThis.fetch)).not.toHaveBeenCalled();
    expect(checkbox().checked).toBe(false);
  });
});
