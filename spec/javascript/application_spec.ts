import "javascript/application";

it("disables Turbo", () => {
  expect(Turbo.session.drive).toBeFalsy();
});
