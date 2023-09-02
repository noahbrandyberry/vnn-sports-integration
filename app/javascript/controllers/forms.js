import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form"];

  submit() {
    this.formTarget.action = "/admin/import_sources/preview";
    this.formTarget.method = "post";
    const methodInput = document.getElementsByName("_method")[0];
    if (methodInput) {
      methodInput.remove();
    }
    this.formTarget.requestSubmit();
  }
}
