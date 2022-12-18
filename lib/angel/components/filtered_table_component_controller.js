import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "filterList", "filterTypeSelect", "filterInput" ]
  connect() {
    console.log("Hello, Stimulus!", this.element);
  }
}
