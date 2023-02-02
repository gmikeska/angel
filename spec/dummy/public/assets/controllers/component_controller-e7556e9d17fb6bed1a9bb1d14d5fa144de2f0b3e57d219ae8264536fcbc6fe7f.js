import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="component"
export default class extends Controller {
  static targets = [ "query", "errorMessage", "results" ]
  static outlets = [ "query", "errorMessage", "results" ]
  static values = {
    status: { type:String, default: 'loading' }
  }
  loaded(){

  }
  loading(){

  }
  connect() {
    debugger
  }
};
